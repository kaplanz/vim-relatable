" relatable.vim - Relatable tab completion
" Maintainer:   Zakhary Kaplan <https://zakharykaplan.ca>
" Version:      0.1.2
" SPDX-License-Identifier: Vim

function! relatable#complete(substr)
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

function! relatable#tabwrapper(shiftTab)
  " Extract tabKey
  let tabKey = (a:shiftTab) ? "\<S-Tab>" : "\<Tab>"

  " Determine tabDirection
  if &completeopt =~# 'noinsert'
    let tabDirection = (a:shiftTab) ? "\<Up>" : "\<Down>"
  else
    let tabDirection = (a:shiftTab) ? "\<C-p>" : "\<C-n>"
  endif

  " Navigate through popup menu if visible
  if pumvisible()
    return tabDirection
  endif

  " Get substr from current word
  let pos = getpos('.')
  let substr = matchstr(strpart(getline(pos[1]), 0, pos[2] - 1), "[^ \t]*$")

  " Pass through appropriate tab character if substr is empty
  if empty(substr)
    return tabKey
  endif

  " Try completion
  let completion = relatable#complete(substr)
  " If no completion found, default to keywords in 'complete'
  if !len(completion)
    let completion = (a:shiftTab) ? "\<C-p>" : "\<C-n>"
  " Start at bottom when not using 'noselect' and shift-tab pressed
  elseif &completeopt !~# 'noselect' && a:shiftTab
    let completion .= repeat(tabDirection, 2)
  endif

  " Return completion command
  return completion
endfunction

" vim:fdl=0:fdm=indent:
