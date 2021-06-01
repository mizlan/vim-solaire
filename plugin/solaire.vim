function! Solaire()
    let buf = winbufnr(0)
    let win = winnr()
    if SolaireShouldDim(buf)
        call SolaireDim(win)
    endif
endfunction

function! SolaireShouldDim(bufnr)
    return !bufexists(a:bufnr) ||
           \ !buflisted(a:bufnr) ||
           \ getbufvar(a:bufnr, '&filetype') ==# 'help' ||
           \ getbufvar(a:bufnr, '&filetype') ==# '' ||
           \ bufname(a:bufnr) ==# ''
endfunction

function! SolaireCreateHighlight()
    let hex = synIDattr(synIDtrans(hlID("Normal")), "bg#")
    "  make it less strong on light themes
    let shade = &background ==# 'light' ? 0.07 : 0.2
    let new_hex = SolaireCreateDimmedColor(hex, shade)
    execute 'highlight! SolaireDimmed guibg=' . new_hex
endfunction

function! SolaireCreateDimmedColor(hex, shade)
    let r = eval('0x'.a:hex[1:2])
    let g = eval('0x'.a:hex[3:4])
    let b = eval('0x'.a:hex[5:6])
    let new_r = printf('%02x', float2nr(round(r * (1 - a:shade))))
    let new_g = printf('%02x', float2nr(round(g * (1 - a:shade))))
    let new_b = printf('%02x', float2nr(round(b * (1 - a:shade))))
    echom new_r.' '.new_g.' '.new_b
    return '#'.new_r.new_g.new_b
endfunction

function! SolaireDim(winnr)
    if has('nvim')
        setlocal winhighlight=Normal:SolaireDimmed
    else
        setlocal wincolor=SolaireDimmed
    endif
endfunction

call SolaireCreateHighlight()
augroup SolaireHighlight
  autocmd!
  autocmd ColorScheme * call SolaireCreateHighlight()
augroup END

autocmd WinEnter * call Solaire()
autocmd BufEnter * call Solaire()
