function! s:get(name, default) abort
    return get(b:, a:name, get(g:, a:name, a:default))
endfunction

function! jumptest#alt_file(file, tag) abort
    if empty(a:file)
        throw 'missing file'
    endif

    if empty(a:tag)
        throw 'missing tag'
    endif

    let dir = fnamemodify(a:file, ':h')
    let ext = fnamemodify(a:file, ':t:e')

    " If the extension is the same as the tag, it probably means the file had
    " no extension, so enforce that. Otherwise the result will be something
    " like 'foo.test.test'.
    if ext == a:tag
        let name = fnamemodify(a:file, ':t')
        let ext = ''
    else
        let name = fnamemodify(a:file, ':t:r')
    endif

    let alt_name = name =~# $'.*\.{a:tag}'
        \ ? name[:-(len(a:tag)+2)]
        \ : $'{name}.{a:tag}'

    let alt_file = join([dir, alt_name], '/')

    if !empty(ext)
        let alt_file .= $'.{ext}'
    endif

    return alt_file
endfunction

function! jumptest#jump() abort
    let file = expand('%')

    if empty(file)
        return
    endif

    let tag = s:get('jumptest_tag', 'test')
    let alt_file = jumptest#alt_file(file, tag)

    if empty(alt_file)
        return
    endif

    execute $'edit {alt_file}'
endfunction
