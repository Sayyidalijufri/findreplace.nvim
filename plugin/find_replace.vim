if exists('g:loaded_find_replace') | finish | endif
let g:loaded_find_replace = 1

command! FindReplace lua require('find_replace').open()
