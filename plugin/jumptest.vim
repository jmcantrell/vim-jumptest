if exists('g:jumptest_loaded')
    finish
endif
let g:jumptest_loaded = 1

command! JumpTest call jumptest#jump()
