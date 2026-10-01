import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";
import { stat } from "node:fs/promises";
import { homedir } from "node:os";
import { isAbsolute, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";

type ViewInput = {
	path: string;
	line?: number;
	column?: number;
};

type ResolvedView = {
	path: string;
	line?: number;
	column?: number;
};

function shellQuote(value: string): string {
	return `'${value.replaceAll("'", "'\\''")}'`;
}

function resolvePath(input: string, cwd: string): string {
	let normalized = input.trim();
	if (normalized.startsWith("@")) normalized = normalized.slice(1);

	if (normalized === "~") {
		normalized = homedir();
	} else if (normalized.startsWith("~/")) {
		normalized = join(homedir(), normalized.slice(2));
	} else if (normalized.startsWith("file://")) {
		normalized = fileURLToPath(normalized);
	}

	return isAbsolute(normalized) ? resolve(normalized) : resolve(cwd, normalized);
}

async function resolveViews(inputs: ViewInput[], cwd: string, signal?: AbortSignal): Promise<ResolvedView[]> {
	const views: ResolvedView[] = [];
	const invalid: string[] = [];
	const seen = new Set<string>();

	for (const input of inputs) {
		signal?.throwIfAborted();

		if (input.column !== undefined && input.line === undefined) {
			invalid.push(`${input.path} (column requires line)`);
			continue;
		}

		let path: string;
		try {
			path = resolvePath(input.path, cwd);
			const info = await stat(path);
			if (!info.isFile()) {
				invalid.push(`${input.path} (not a regular file)`);
				continue;
			}
		} catch {
			invalid.push(`${input.path} (not found)`);
			continue;
		}

		const view: ResolvedView = {
			path,
			...(input.line === undefined ? {} : { line: input.line, column: input.column ?? 1 }),
		};
		const key = `${view.path}\0${view.line ?? ""}\0${view.column ?? ""}`;
		if (!seen.has(key)) {
			seen.add(key);
			views.push(view);
		}
	}

	if (invalid.length > 0) {
		throw new Error(`Cannot open these views:\n${invalid.map((item) => `- ${item}`).join("\n")}`);
	}
	if (views.length === 0) {
		throw new Error("No file views were provided.");
	}

	return views;
}

function buildPaneCommand(view: ResolvedView, nvimPath: string): string {
	const position =
		view.line === undefined ? "" : ` ${shellQuote(`+call cursor(${view.line}, ${view.column ?? 1})`)}`;
	return `exec ${shellQuote(nvimPath)}${position} -- ${shellQuote(view.path)}`;
}

function buildStandaloneCommand(views: ResolvedView[]): string {
	const positionCommands = views.flatMap((view, index) => {
		if (view.line === undefined) return [];
		const selectTab = views.length > 1 ? `tabnext ${index + 1} | ` : "";
		return `${selectTab}call cursor(${view.line}, ${view.column ?? 1})`;
	});
	if (views.length > 1 && positionCommands.length > 0) positionCommands.push("tabfirst");

	const tabs = views.length > 1 ? " -p" : "";
	const positions =
		positionCommands.length === 0 ? "" : ` -c ${shellQuote(positionCommands.join(" | "))}`;
	const paths = views.map((view) => shellQuote(view.path)).join(" ");
	return `nvim${tabs}${positions} -- ${paths}`;
}

async function findNvim(pi: ExtensionAPI, signal?: AbortSignal): Promise<string> {
	const result = await pi.exec("sh", ["-c", "command -v nvim"], { signal, timeout: 5_000 });
	const nvimPath = result.stdout.trim().split(/\r?\n/)[0];
	if (result.code !== 0 || !nvimPath) {
		throw new Error("nvim is not available in Pi's PATH");
	}
	return nvimPath;
}

async function runTmux(
	pi: ExtensionAPI,
	views: ResolvedView[],
	nvimPath: string,
	cwd: string,
	signal?: AbortSignal,
): Promise<string> {
	const run = async (args: string[]) => {
		const result = await pi.exec("tmux", args, { signal });
		if (result.code !== 0) {
			const details = result.stderr.trim() || result.stdout.trim() || `exit code ${result.code}`;
			throw new Error(`tmux ${args[0]} failed: ${details}`);
		}
		return result;
	};

	let windowId: string | undefined;
	try {
		const created = await run([
			"new-window",
			"-d",
			"-P",
			"-F",
			"#{window_id}",
			"-n",
			"nv",
			"-c",
			cwd,
			buildPaneCommand(views[0], nvimPath),
		]);
		windowId = created.stdout.trim().split(/\r?\n/).at(-1);
		if (!windowId) throw new Error("tmux did not return the new window id");

		for (const view of views.slice(1)) {
			await run(["split-window", "-d", "-t", windowId, "-c", cwd, buildPaneCommand(view, nvimPath)]);
		}

		await run(["select-layout", "-t", windowId, "tiled"]);
		await run(["select-window", "-t", windowId]);
		return windowId;
	} catch (error) {
		if (windowId) {
			await pi.exec("tmux", ["kill-window", "-t", windowId]).catch(() => undefined);
		}
		throw error;
	}
}

export default function (pi: ExtensionAPI) {
	pi.registerTool({
		name: "open_in_neovim",
		label: "Open in Neovim",
		description:
			"Open exact existing file views in Neovim. Inside tmux, creates a new window with one tiled pane per view. Outside tmux, returns a copyable command without launching an editor.",
		promptSnippet: "Open requested files or source locations in Neovim",
		promptGuidelines: [
			"Use open_in_neovim whenever the user explicitly asks to open, view, or edit files in Neovim/nvim; do not substitute a bash tmux command.",
			"Before calling open_in_neovim, resolve references to exact existing file paths. Broad requests such as 'open those files' should include all relevant views, while qualified requests should include only the requested subset.",
		],
		parameters: Type.Object({
			views: Type.Array(
				Type.Object({
					path: Type.String({ description: "Existing file path, absolute or relative to the session cwd" }),
					line: Type.Optional(Type.Integer({ minimum: 1, description: "Optional 1-based line" })),
					column: Type.Optional(Type.Integer({ minimum: 1, description: "Optional 1-based column" })),
				}),
				{ minItems: 1 },
			),
		}),
		executionMode: "sequential",
		async execute(_toolCallId, params, signal, _onUpdate, ctx) {
			const views = await resolveViews(params.views, ctx.cwd, signal);
			const nvimPath = await findNvim(pi, signal);

			if (!process.env.TMUX) {
				const command = buildStandaloneCommand(views);
				return {
					content: [
						{
							type: "text",
							text: `No tmux session is active, so Neovim was not launched. Give the user this command to copy and run:\n\n${command}`,
						},
					],
					details: { opened: false, insideTmux: false, command, views },
				};
			}

			const windowId = await runTmux(pi, views, nvimPath, ctx.cwd, signal);
			return {
				content: [
					{
						type: "text",
						text: `Opened ${views.length} Neovim view${views.length === 1 ? "" : "s"} in tmux window ${windowId}, one pane per view.`,
					},
				],
				details: { opened: true, insideTmux: true, windowId, views },
			};
		},
	});

	pi.registerCommand("nv", {
		description: "Open relevant files in Neovim (optionally narrowed by a request)",
		handler: async (args, ctx) => {
			const request = args.trim();
			const content = request
				? [
						"Handle this /nv request now:",
						request,
						"Use the conversation and project context to resolve it. Open only the files/views relevant to this request, then call open_in_neovim exactly once. Do not include unrelated files from earlier responses.",
					].join("\n\n")
				: "Handle this /nv request now. Inspect your immediately preceding assistant response, collect every relevant file/view you mentioned there, resolve each to an exact existing path, and call open_in_neovim exactly once. If no file was mentioned, say so instead of guessing.";

			pi.sendMessage(
				{
					customType: "nv-request",
					content,
					display: false,
					details: { request: request || undefined },
				},
				{ deliverAs: "followUp", triggerTurn: true },
			);

			if (!ctx.isIdle()) ctx.ui.notify("Queued /nv for when the current response finishes", "info");
		},
	});
}
