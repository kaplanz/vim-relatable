" relatable.vim - Relatable tab completion
" Maintainer:   Zakhary Kaplan <https://zakharykaplan.ca>
" Version:      0.1.3
" SPDX-License-Identifier: Vim

function! s:Complete(substr)
  " Set match patterns for completion search type
  let filepat = (has('win32') || has('win64')) ? '\\\|\/' : '\/'

  " Try completion
  if match(a:substr, filepat) != -1
    return "\<C-x>\<C-f>"
  elseif &spell
    return "\<C-x>\<C-k>"
  elseif &filetype == 'vim'
    return "\<C-x>\<C-v>"
  elseif &completefunc
    return "\<C-x>\<C-u>"
  elseif &omnifunc
    return "\<C-x>\<C-o>"
  endif

  " Return an empty string if no completion found
  return ''
endfunction

function! s:TabWrapper(shift)
  " Exteact tab key
  let tabkey = (a:shift) ? "\<S-Tab>" : "\<Tab>"

  " Determine direction
  if &completeopt =~# 'noinsert'
    let direction = (a:shift) ? "\<Up>" : "\<Down>"
  else
    let direction = (a:shift) ? "\<C-p>" : "\<C-n>"
  endif

  " Navigate through popup menu if visible
  if pumvisible()
    return direction
  endif

  " Get substr from current word
  let pos = getpos('.')
  let substr = matchstr(strpart(getline(pos[1]), 0, pos[2] - 1), "[^ \t]*$")

  " Pass through appropriate tab character if substr is empty
  if empty(substr)
    return tabkey
  endif

  " Attempt completion
  let completion = s:Complete(substr)
  " If no completion found, default to keywords in 'complete'
  if !len(completion)
    let completion = (a:shift) ? "\<C-p>" : "\<C-n>"
  " Start at bottom when not using 'noselect' and <S-Tab> pressed
  elseif &completeopt !~# 'noselect' && a:shift
    let completion .= repeat(direction, 2)
  endif

  " Return completion command
  return completion
endfunction

function! relatable#ShiftTab()
  return s:TabWrapper(1)
endfunction

function! relatable#Tab()
  return s:TabWrapper(0)
endfunction

" vim:fdl=0:fdm=indent:
