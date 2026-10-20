
session_root "~/Documents/cool-vault1/"

if initialize_session "notes"; then
	new_window 
	run_cmd "while nvim .; do true; done"

	new_window 
fi

finalize_and_go_to_session
