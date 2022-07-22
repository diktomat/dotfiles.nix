function frg
	set -f RG "rg -i -l --hidden --no-ignore-vsc"
	set -f FZF_DEFAULT_COMMAND "$RG --files"
	fzf --bind "change:reload:$RG {q} |cut -d ':' -f1 |uniq" --preview "rg -i --pretty --context 2 {q} {}" --disabled
end
