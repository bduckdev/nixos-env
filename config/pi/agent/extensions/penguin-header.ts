import type {
  ExtensionAPI,
  ExtensionContext,
  Theme,
} from "@earendil-works/pi-coding-agent";
import { VERSION } from "@earendil-works/pi-coding-agent";
import {
  truncateToWidth,
  visibleWidth,
  wrapTextWithAnsi,
} from "@earendil-works/pi-tui";

const QUOTES = [
  "He who controls the dotfiles controls the universe.",
  "Never deploy on Friday, unless your enemy expects stability.",
  "A clean build is merely an ambush that has not happened yet.",
  "Know your codebase, know your stack trace, fear neither production nor staging.",
  "The supreme art of debugging is to fix the bug without reproducing it.",
  "When surrounded, open another terminal.",
  "Every dependency is innocent until the lockfile changes.",
  "If the tests pass too quickly, the wise developer grows suspicious.",
  "Opportunities multiply as they are forked.",
  "To confuse your enemy, first confuse your future self.",
  "Victorious developers commit first and then go to lunch.",
  "There is no greater danger than a command copied from a forum post.",
  "The repository that can be explained is not the true repository.",
  "Move swift as Git, stay silent as a detached HEAD.",

  "Appear AFK when you are debugging; appear debugging when you are AFK.",
  "The wise developer keeps one terminal for work and seventeen for morale.",
  "If a command requires sudo, contemplate first the fragility of empire.",
  "He who force-pushes without fear has not yet met the consequences.",
  "A thousand-line config begins with one unnecessary option.",
  "The enemy cannot know your plan if you have not written one.",
  "When the compiler speaks, even emperors must listen.",
  "One warning ignored becomes ten warnings inherited.",
  "The victorious engineer wins first, then writes the implementation.",
  "The defeated engineer writes the implementation, then discovers the requirements.",
  "Before blaming the kernel, inspect the typo.",
  "Before blaming the typo, blame the kernel.",
  "There are no legacy systems, only systems whose authors have escaped.",
  "When the bug disappears under observation, you have entered the realm of spirits.",
  "A segfault is the machine's way of rejecting your philosophy.",
  "He who fears undefined behavior should not summon C.",
  "He who does not fear undefined behavior has misunderstood C.",
  "The pointer knows where it points. The programmer merely has opinions.",
  "Allocate carefully, for every malloc creates a future free.",
  "The memory you do not allocate cannot be leaked.",
  "The stack is swift, the heap is patient.",
  "When in doubt, add another struct.",
  "A clever abstraction is merely tomorrow's archaeological site.",
  "The best abstraction is the one deleted before code review.",
  "Do not pursue DRY so far that you arrive at madness.",
  "Three duplicated lines are sometimes cheaper than one immortal abstraction.",
  "He who generalizes before the third use case builds a temple to speculation.",
  "Interfaces are treaties signed before either kingdom knows what it wants.",
  "Every framework promises victory. Every framework demands tribute.",
  "The dependency you add today will be abandoned precisely when you need it.",
  "Choose dependencies as you choose allies: reluctantly and with pinned versions.",
  "A package manager remembers every mistake.",
  "The lockfile is the census of your empire.",
  "When node_modules appears, disk space retreats.",
  "One does not defeat complexity by installing complexity.",
  "If your build requires the internet, the internet is now part of your build system.",
  "The cloud is another man's computer, and his pager is asleep.",
  "Production is the terrain upon which assumptions go to die.",
  "Staging is production wearing ceremonial armor.",
  "No plan survives first contact with the user.",
  "No schema survives first contact with production data.",
  "The database remembers what the application wishes to forget.",
  "An index placed wisely is worth ten servers.",
  "The fastest query is the query never made.",
  "A cache is a promise to debug two realities instead of one.",
  "There are only two hard problems: cache invalidation, naming things, and counting.",
  "The wise engineer invalidates the cache. The wiser engineer removes it.",
  "Never trust a benchmark you did not accidentally optimize for.",
  "Milliseconds become microseconds when management enters the room.",
  "Premature optimization is the root of all benchmarks.",
  "Measure twice, rewrite in Rust once.",
  "Rewrite not in Rust merely because the crab whispers to you.",
  "Rust prevents many mistakes, but not the decision to rewrite everything.",
  "Go is simple until someone discovers reflection.",
  "C has no hidden costs because the costs are standing directly in front of you.",
  "C++ offers many paths. Most lead through a template error.",
  "Java permits no pointer arithmetic, yet suffering finds another way.",
  "Python makes the first draft easy and the tenth year interesting.",
  "JavaScript will accept your offering whether or not it understands it.",
  "TypeScript is JavaScript wearing armor it can remove at runtime.",
  "Lua enters quietly and soon controls the entire editor.",
  "The Lisp programmer sees parentheses. Others see the abyss.",
  "He who masters regex solves one problem and acquires several smaller demons.",
  "A regex written yesterday is an ancient text today.",
  "The parser is mightier than the split.",
  "If you are parsing structured data with string slicing, defeat has already begun.",
  "Every protocol is simple before the first edge case.",
  "The happy path is merely the road on which no users have yet traveled.",
  "An edge case encountered twice is now a requirement.",
  "The TODO survives longer than the empire that created it.",
  "Temporary code enjoys exceptional longevity.",
  "Nothing is more permanent than a workaround with good comments.",
  "A FIXME without an issue number is a letter to the dead.",
  "Comments describe intention. Git blame describes history.",
  "Git blame reveals the culprit. Often, the culprit is you.",
  "Rebase history carefully; the ancestors are easily angered.",
  "A merge conflict is two developers discovering free will.",
  "When branches diverge, seek first the one who touched package.json.",
  "Never resolve a merge conflict while emotionally invested.",
  "The commit named 'fix' contains multitudes.",
  "The second 'final' commit is rarely final.",
  "The wise developer squashes shame before opening the pull request.",
  "A pull request of ten lines invites discussion. A pull request of ten thousand inspires surrender.",
  "Review small changes, lest large changes review you.",
  "The strongest code review comment is 'why does this exist?'",
  "If nobody understands the clever code, the clever code has defeated its own army.",
  "Readable code requires fewer legends.",
  "Naming is the first battle and the last.",
  "If you cannot name the function, perhaps you do not know what it does.",
  "Boolean arguments are tiny flags carried into civil war.",
  "A function with seven parameters is already negotiating surrender.",
  "The function that does everything will eventually do nothing correctly.",
  "State concealed is state waiting to betray you.",
  "Global state has no borders.",
  "Concurrency turns ordinary mistakes into folklore.",
  "The race condition attacks only when the debugger is absent.",
  "Threads multiply faster than understanding.",
  "A mutex placed everywhere is merely single-threading with paperwork.",
  "Deadlock is two warriors politely waiting forever.",
  "Distributed systems are where clocks become opinions.",
  "Two generals may agree. Two databases require a protocol.",
  "The network is reliable until the demonstration begins.",
  "Packets lost in transit leave no graves.",
  "There is no single source of truth once someone adds replication.",
  "Eventual consistency is confidence expressed in the future tense.",
  "Consensus is easy when everyone agrees.",
  "A timeout is merely uncertainty converted into milliseconds.",
  "Retry carefully, lest you perform the same payment seven times.",
  "Idempotency is the art of surviving enthusiasm.",
  "The server that cannot fail has not yet been deployed.",
  "Redundancy is waste until 3:14 AM.",
  "Backups are mythology until restoration is tested.",
  "A backup never restored is merely decorative storage.",
  "Observability begins where print statements become socially unacceptable.",
  "Logs are letters written by the past to an exhausted future.",
  "If everything is logged, nothing is observable.",
  "The dashboard with forty graphs contains zero answers.",
  "A green dashboard is not proof of peace.",
  "The alert that fires constantly is an alert that fires never.",
  "Pager fatigue is victory achieved by the enemy without battle.",
  "A service without metrics is a province beyond the emperor's maps.",
  "The wise operator knows that uptime ends.",
  "Five nines are achieved one maintenance window at a time.",
  "Kubernetes solves the problem of not having Kubernetes.",
  "Containers are processes wearing paperwork.",
  "YAML is whitespace given administrative authority.",
  "Infrastructure as code eventually becomes code nobody wishes to refactor.",
  "Terraform state remembers sins no human recalls.",
  "Nix grants reproducibility in exchange for learning what a derivation is.",
  "He who understands Nix has either transcended or been permanently altered.",
  "A reproducible failure is progress.",
  "The immutable system still contains mutable humans.",
  "The package exists. The documentation does not.",
  "When documentation fails, consult the source. When source fails, consult git blame.",
  "A flag discovered in a commit message is still technically documented.",
  "The man page is patient. The developer is not.",
  "Stack Overflow answered many questions before the ancient archives were sealed.",
  "An answer from 2014 may save you or destroy you.",
  "Copy commands only after understanding at least half of the punctuation.",
  "Curl piped to shell is trust expressed efficiently.",
  "The shell remembers nothing and forgives less.",
  "Quote your variables, unless chaos is the objective.",
  "Whitespace is invisible terrain.",
  "One missing semicolon can halt an army; one extra semicolon can command it.",
  "The terminal does exactly what you ask, which is rarely what you intended.",
  "When rm asks no questions, ask yourself several.",
  "The wise developer aliases nothing dangerous.",
  "The foolish developer aliases sudo rm -rf and calls it convenience.",
  "If you cannot remember what the alias does, it has become infrastructure.",
  "Every shell script eventually becomes a programming language against its author's wishes.",
  "A Makefile is a build system until someone learns Make.",
  "The build is deterministic except for everything around it.",
  "Works on my machine is not a defense. It is intelligence about the battlefield.",
  "The container works on everyone's machine because everyone's machine is now the container.",
  "Virtualization moves the problem into a smaller computer.",
  "When the VM fails, remember there is another computer beneath it.",
  "The deepest stack trace is the one inside yourself.",
  "The bug was not in the code. The bug was in your model of the code.",
  "To understand the system, delete one line and observe who screams.",
  "If changing nothing fixes the problem, document nothing and leave quietly.",
  "Sometimes the correct fix is restarting the process and denying knowledge.",
  "The ancient masters called this 'turning it off and on again.'",
  "When all else fails, read the error message.",
] as const;

const ART = [
  ".--.",
  "|o_o |",
  "|:_/ |",
  "//   \\ \\",
  "(|     |)",
  "/'\\_   _/`\\",
  "\\___)=(___/",
] as const;

function randomQuote(previous?: string): string {
  const choices = QUOTES.filter((quote) => quote !== previous);
  return choices[Math.floor(Math.random() * choices.length)] ?? QUOTES[0];
}

function center(line: string, width: number): string {
  return (
    " ".repeat(Math.max(0, Math.floor((width - visibleWidth(line)) / 2))) + line
  );
}

function colorArt(line: string, index: number, theme: Theme): string {
  if (index < 3) return theme.fg("thinkingXhigh", line);
  if (index < 6) return theme.fg("accent", line);
  return theme.fg("warning", line);
}

function makeHeader(theme: Theme, quote: string) {
  return {
    render(width: number): string[] {
      const safeWidth = Math.max(1, width);
      const lines: string[] = [""];

      if (safeWidth >= 24) {
        for (let index = 0; index < ART.length; index += 1) {
          lines.push(
            truncateToWidth(
              center(colorArt(ART[index], index, theme), safeWidth),
              safeWidth,
              "",
            ),
          );
        }
      } else {
        lines.push(
          truncateToWidth(
            center(
              theme.fg("thinkingXhigh", "(o_o) PENGUIN ONLINE"),
              safeWidth,
            ),
            safeWidth,
            "",
          ),
        );
      }

      const title = theme.bold(
        theme.fg("accent", " P I ") +
          theme.fg("thinkingXhigh", " // PENGUIN MODE "),
      );
      lines.push("");
      lines.push(truncateToWidth(center(title, safeWidth), safeWidth, ""));
      lines.push("");

      const quoteWidth = Math.max(12, Math.min(72, safeWidth - 4));
      const wrappedQuote = wrapTextWithAnsi(
        theme.italic(theme.fg("text", `“${quote}”`)),
        quoteWidth,
      );
      for (const quoteLine of wrappedQuote) {
        lines.push(
          truncateToWidth(center(quoteLine, safeWidth), safeWidth, ""),
        );
      }

      const attribution =
        theme.fg("muted", "— Sun Tzu ") + theme.fg("warning", "[probably]");
      lines.push(
        truncateToWidth(center(attribution, safeWidth), safeWidth, ""),
      );
      lines.push("");
      lines.push(
        truncateToWidth(
          center(
            theme.fg("dim", `pi v${VERSION}  •  /reroll-quote`),
            safeWidth,
          ),
          safeWidth,
          "",
        ),
      );
      lines.push("");
      return lines;
    },
    invalidate() {},
  };
}

function installHeader(ctx: ExtensionContext, previousQuote?: string): string {
  const quote = randomQuote(previousQuote);
  ctx.ui.setHeader((_tui, theme) => makeHeader(theme, quote));
  return quote;
}

export default function (pi: ExtensionAPI) {
  let currentQuote: string | undefined;

  pi.on("session_start", (_event, ctx) => {
    if (ctx.mode === "tui") currentQuote = installHeader(ctx, currentQuote);
  });

  pi.registerCommand("reroll-quote", {
    description: "Generate another definitely-not-Sun-Tzu quote",
    handler: async (_args, ctx) => {
      if (ctx.mode !== "tui") return;
      currentQuote = installHeader(ctx, currentQuote);
      ctx.ui.notify("Ancient wisdom recalibrated", "info");
    },
  });
}
