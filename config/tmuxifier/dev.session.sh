session_root "${TS_DIR}"

if initialize_session "${TS_NAME}"; then
	new_window "editor"
	run_cmd "nvim ."
	select_pane 3

	new_window "shell"

	new_window "agent"
	#run_cmd "opencode"
	if [ -d ${TS_DIR}/.git ]; then
		split_h 10
		run_cmd "lazygit"
	fi
	select_pane 3

	new_window "server"
	if grep -qE '^dev *:' ${TS_DIR}/Makefile; then
		run_cmd "make dev"
	fi

	select_window 3
fi

finalize_and_go_to_session
