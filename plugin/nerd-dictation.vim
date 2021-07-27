let s:plugindir = expand('<sfile>:p:h:h')
let s:nerdcmd = s:plugindir . "/nerd-dictation/nerd-dictation"


function! s:NDInstall()
    echom "Installing/Reinstalling:"
    let ans = input("This will run 'pip3 install vosk' and 'git clone ideasman42/nerd-dictation' plugin folder; proceed? [y/N]: ")
    if ans[0] ==? "y"
        execute "!pip3 install vosk"
        let clonedir = "https://github.com/ideasman42/nerd-dictation.git "
        let installdir = s:plugindir . "/nerd-dictation"
        " try removing existing dir
        if isdirectory(installdir)
            silent execute "!rm -rf " . installdir
            execute "!echo 'cleaned git nerd-dictation; reinstallng'"
        endif
        execute "!git clone " . clonedir . installdir
    else
        echom "Canceled"
    endif
endfunction

function! s:NDBegin(...)
    if empty(glob(s:nerdcmd))
        echom "nerd-dictation not found; install via :NDInstall"
    elseif len(s:ModelList("","","")) > 0
        let lang = get(a:, 1, "EN")
        let model = s:plugindir . "/models/" . lang
        silent execute "! " . s:nerdcmd . " begin --vosk-model-dir=" . model . " &"
        redraw!
    else
        echom "No language model available; install running :NDModelInstall"
    endif
endfunction

function! s:NDEnd()
    silent execute "! " . s:nerdcmd . " end"
endfunction

function! s:InstallModel()
    let modfile = s:plugindir . "/.moduleinstall.txt"
    let scratchbuf = s:plugindir . "/.tempinstallinfo.txt"
    " open buffer
    execute("new " .  scratchbuf)
    execute("0read " .  modfile)
    execute("au! BufWritePost " . scratchbuf . " call s:CompleteInstall()")
endfunction

function! s:CompleteInstall()
    " Get info
    let scratchbuf = s:plugindir . "/.tempinstallinfo.txt"
    let installinfo = readfile(scratchbuf)[3:4]
    let module = trim(split(installinfo[0], "::")[1])
    let name = trim(split(installinfo[1], "::")[1])
    " Define conveninece names
    let module = "https://alphacephei.com/vosk/models/" . module . ".zip"
    let name =  s:plugindir . "/models/" . name
    " Shell scripting
    execute("!rm " . scratchbuf)
    execute("!wget " . module . " -O " . name . ".zip")
    execute("!unzip -d " . name . "tmp -o " . name . ".zip")
    execute("!mv " . name . "tmp/* " . name)
    execute("!rm -rf " . name . ".zip " . name . "tmp")
endfunction

function! s:RemoveModels(...)
    for md in a:000
        silent execute("!rm -rf " . s:plugindir . "/models/" . md)
    endfor
    echom "Removed model(s): " . join(a:000)
endfunction

"""" Plugin commands
command! NDInstall call s:NDInstall()

command! NDModelInstall call s:InstallModel()

command! -complete=customlist,s:ModelList -nargs=+ NDModelRemove call s:RemoveModels(<f-args>) | redraw!

command! NDModelList echom "Available models: [" . join(s:ModelList("","","")) . "]"

" Start nerd-dictation completing available languages
command!  -complete=customlist,s:ModelList -nargs=? NDBegin call s:NDBegin(<f-args>)
function! s:ModelList(A,L,P)
    let cmd = "ls --ignore=README.md " . s:plugindir . "/models"
    return systemlist(cmd)
endfunction

" Stop nerd-dictation
command! NDEnd silent call s:NDEnd() | redraw!
