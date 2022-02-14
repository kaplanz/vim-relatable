" relatable.vim - Relatable tab completion
" Maintainer:   Zakhary Kaplan <https://zakhary.dev>
" Version:      0.1.5
" SPDX-License-Identifier: Vim

" Handle <CR> in a popup menu
function! relatable#cr()
  return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction

" Handle <S-Tab> for completion
function! relatable#stab()
  return s:TabWrapper(1)
endfunction

" Handle <Tab> for completion
function! relatable#tab()
  return s:TabWrapper(0)
endfunction

" Suggest a complete method from a substring
function! s:Complete(substr)
  " Set match patterns for completion search type
  let filepat = (has('win32') || has('win64')) ? '\\\|\/' : '\/'

  " Try completion
  if match(a:substr, filepat) != -1
    return "\<C-x>\<C-f>"
  elseif !empty(&spell)
    return "\<C-x>\<C-k>"
  elseif &filetype == 'vim'
    return "\<C-x>\<C-v>"
  elseif !empty(&completefunc)
    return "\<C-x>\<C-u>"
  elseif !empty(&omnifunc)
    return "\<C-x>\<C-o>"
  endif

  " Return an empty string if no completion found
  return ''
endfunction

" Wrap common tab behaviour
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

" vim:fdl=0:fdm=indent:
