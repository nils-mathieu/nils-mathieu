function fish_prompt
	# If the current status is non-zero, print it.
	set saved_status $status
	if test $saved_status != 0
		set_color --italic red
		echo -n "Error Code"
		set_color normal
		echo -n " "
		set_color --bold red
		echo $saved_status
		set_color normal
	end

	# Print the current time.
	set_color --bold magenta
	echo -n " ━━━━━" (date "+%H:%M:%S") "━━━━━ "
	set_color normal

	# If the current directory exists within a git work-tree, show the path within that repository.
	# Otherwise, print the regular prompt pdw.
	if git rev-parse 2> /dev/null
		set current_branch (git branch --show-current)
		set relative_path (basename (git rev-parse --show-toplevel))/(git rev-parse --show-prefix)
		set relative_path (echo $relative_path | string trim --right -c "/")

		set_color --dim green
		echo -n "("
		echo -n $current_branch
		echo -n ")"
		set_color normal
		set_color green
		echo " "$relative_path
		set_color normal
	else
		set_color --bold blue
		set -l fish_prompt_pwd_dir_length 0
		prompt_pwd
		set_color normal
	end

	set_color --bold white
	echo -n " >_ "	
	set_color normal
end
