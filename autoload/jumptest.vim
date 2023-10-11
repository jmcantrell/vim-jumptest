function! s:get(name, default) abort
    return get(b:, a:name, get(g:, a:name, a:default))
endfunction

function! jumptest#alternate_file(file) abort
    if empty(a:file)
        throw 'missing file'
    endif

    let test_tag = s:get('jumptest_tag', '_test')
    let prefix = s:get('jumptest_prefix', '[^/.]\+')
    let suffix = s:get('jumptest_suffix', '\(\.[^/]\+\)\?$')

    let main_pattern = prefix . '\zs\ze' . suffix
    let test_pattern = prefix . '\zs' . test_tag . '\ze' . suffix

    if a:file =~# test_pattern
        return substitute(a:file, test_pattern, '', '')
    elseif a:file =~# main_pattern
        return substitute(a:file, main_pattern, test_tag, '')
    else
        throw 'jumptest: file not matched by main/test patterns'
    endif
endfunction

function! jumptest#jump() abort
    let file = expand('%')

    if empty(file)
        return
    endif

    let alternate_file = jumptest#alternate_file(file)

    if empty(alternate_file)
        return
    endif

    execute 'edit ' . alternate_file
endfunction
