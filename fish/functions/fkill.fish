function fkill
	if test "$UID" != "0";
		set -f pid (ps -xr -U=$UID |tail -n +2 |fzf --preview '' |awk '{print $1}')
	else
		set -f pid (ps -axr |tail -n +2 |fzf --preview '')
	end
	kill $argv $pid
end
