session_root "${BDUCK_TMUX_LAYOUT_SESSION_DIR}"

BDUCK_TMUX_LAYOUT_SESSION_NAME=$(basename "$BDUCK_TMUX_LAYOUT_SESSION_DIR" | tr '. ' '__')
BDUCK_TMUX_LAYOUT_NVIM_SOCKET="/tmp/nvim-${BDUCK_TMUX_LAYOUT_SESSION_NAME}.sock"
BDUCK_TMUX_LAYOUT_NVIM_COMMAND="nvim --listen \"$BDUCK_TMUX_LAYOUT_NVIM_SOCKET\""

if initialize_session "${BDUCK_TMUX_LAYOUT_SESSION_NAME}"; then
	new_window 
	run_cmd "while ${BDUCK_TMUX_LAYOUT_NVIM_COMMAND}; do true; done"

	new_window 

	new_window 
	run_cmd "pi"
fi

if [[ -n "$BDUCK_TMUX_LAYOUT_START_WINDOW" ]]; then
	select_window "$BDUCK_TMUX_LAYOUT_START_WINDOW"
else
	select_window 3
fi

finalize_and_go_to_session
