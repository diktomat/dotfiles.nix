function e
	set sock $XDG_RUNTIME_DIR/nvim.sock
	if test -S $sock
		if test $argv[1] = "-tab" -o $argv[1] = "-send" -o $argv[1] = "-expr"
			set remote --remote$argv[1]
			set -e argv[1]
		else
			set remote --remote
		end
		nvim --server $sock $remote $argv
	else
		neovide --multigrid -- --listen $sock $argv
	end
end
