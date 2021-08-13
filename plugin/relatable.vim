" relatable.vim - Relatable tab completion
" Maintainer:   Zakhary Kaplan <https://zakharykaplan.ca>
" Version:      0.1.4
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
inoremap <expr> <Plug>RelatableReturn   relatable#Return()
inoremap <expr> <Plug>RelatableTab      relatable#Tab()
inoremap <expr> <Plug>RelatableShiftTab relatable#ShiftTab()
if g:relatable_default_mappings
  imap <Tab>   <Plug>RelatableTab
  imap <S-Tab> <Plug>RelatableShiftTab
endif
" }}}

" vim:fdl=0:fdm=marker:
