if exists('g:jumptest_loaded')
    finish
endif
let g:jumptest_loaded = 1

function! s:get(name, default) abort
    return get(g:, a:name, get(b:, a:name, a:default))
endfunction

function! s:alt_file() abort
    if empty(expand('%'))
        echoerr 'Buffer has no filename!'
        return
    endif

    let dir = expand('%:h')
    let name = expand('%:t:r')
    let ext = expand('%:t:e')

    let tag = s:get('jumptest_tag')

    let alt_name = name =~# $'.*\.{tag}'
        \ ? name[:-(len(tag)+2)]
        \ : $'{name}.test'

    return join([dir, join([alt_name, ext], '.')], '/')
endfunction

function! s:jumptest() abort
    let alt_file = s:alt_file()
    if !empty(alt_file)
        execute $'edit {alt_file}'
    endif
endfunction

command! JumpTest call s:jumptest()
