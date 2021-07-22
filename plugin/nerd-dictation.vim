let s:plugindir = expand('<sfile>:p:h:h')

function! s:NDInstall()
    echom "Installing/Reinstalling:"
    let ans = input("This will run 'pip3 install vosk' and 'git clone ideasman42/nerd-dictation' plugin folder; proceed? [y/N]: ")
    if ans[0] ==? "y"
        execute "!pip3 install vosk"
        let clonedir = "https://github.com/ideasman42/nerd-dictation.git "
        let installdir = s:plugindir . "/nerd-dictation"
        " try removing existing dir
        if isdirectory(installdir)
            execute "!rm -rf installdir"
        endif
        execute "!git clone " . clonedir . installdir
    endif
endfunction

command! NDInstall call s:NDInstall()
