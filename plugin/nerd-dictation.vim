function! s:NDInstall()
    echom "Installing vosk:"
    let ans = input("This will run 'pip3 install vosk' and 'git clone ideasman42/nerd-dictation' plugin folder; proceed? [y/N]: ")
    if ans[0] ==? "y"
        execute "!pip3 install vosk"
        let clonedir = "https://github.com/ideasman42/nerd-dictation.git "
        "let plugindir = expand("<sfile>:h")
        let g:here=expand("<sfile>")
        "execute "!git clone " . clonedir . plugindir
    endif
endfunction

command! NDInstall call s:NDInstall()
