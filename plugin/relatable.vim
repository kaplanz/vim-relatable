" relatable.vim - Relatable tab completion
" Maintainer:   Zakhary Kaplan <https://github.com/zakharykaplan>
" Version:      0.1.2
" SPDX-License-Identifier: Vim

" Setup: {{{
if exists("g:loaded_relatable") || &compatible || v:version < 700
  finish
endif
let g:loaded_relatable = 1
" }}}

" Options: {{{
if !exists('g:relatable_default_mappings')
  let g:relatable_default_mappings = 1
endif
" }}}

" Autocmds: {{{
augroup Relatable
  autocmd!
augroup END
" }}}

" Mappings: {{{
inoremap <expr> <Plug>RelatableTabNext relatable#tabwrapper(0)
inoremap <expr> <Plug>RelatableTabPrev relatable#tabwrapper(1)
if g:relatable_default_mappings
  imap <Tab> <Plug>RelatableTabNext
  imap <S-Tab> <Plug>RelatableTabPrev
endif
" }}}

" vim:fdl=0:fdm=marker:
