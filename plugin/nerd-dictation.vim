let s:plugindir = expand('<sfile>:p:h:h')

function! s:NDInstall()
    echom "Installing vosk:"
    let ans = input("This will run 'pip3 install vosk' and 'git clone ideasman42/nerd-dictation' plugin folder; proceed? [y/N]: ")
    if ans[0] ==? "y"
        execute "!pip3 install vosk"
        let clonedir = "https://github.com/ideasman42/nerd-dictation.git "
        execute "!git clone " . clonedir . s:plugindir . "nerd-dictation"
    endif
endfunction

command! NDInstall call s:NDInstall()
