setl textwidth=99

setl tags+=~/.vim/systags/rust
if getftime(expand("~/.vim/systags/rust")) < getftime(g:ftplugin_rust_source_path)
	echom "Regenerating systags.."
	call system("ctags -R --languages=rust --exclude=examples --exclude=tests --exclude=tests.rs -f ~/.vim/systags/rust " . g:ftplugin_rust_source_path . " &")
endif

augroup rust
	au!
	au BufWritePost *.rs silent! !ctags -R --languages=rust . &
augroup end
