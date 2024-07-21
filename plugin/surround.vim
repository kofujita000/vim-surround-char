function! SurroundVisualWithChar()
	let l:open_char = nr2char(getchar())
	let l:close_char = l:open_char
	let l:end_line = line("'>")
	let l:end_col = col("'>")

	if l:open_char == '('
		let l:close_char = ')'
	elseif l:open_char == '{'
		let l:close_char = '}'
	elseif l:open_char == '['
		let l:close_char = ']'
	elseif l:open_char == '<'
		let l:close_char = '>'
	elseif l:open_char == '"'
		let l:open_char = '\"'
		let l:close_char = '\"'
	endif

	execute ":'<,'>s/\\\%V.*\\\%V./" . l:open_char . "&" . l:close_char . "/g"

	call cursor(l:end_line, l:end_col + 2)
endfunction

function! DeleteSurroundWithChar()
	let l:open_char = nr2char(getchar())
	let l:close_char = l:open_char
	let l:current_pos = col('.')
	let l:line = getline('.')
	let l:line_len = len(l:line)

	if l:open_char == '('
		let l:close_char = ')'
	elseif l:open_char == '{'
		let l:close_char = '}'
	elseif l:open_char == '['
		let l:close_char = ']'
	elseif l:open_char == '<'
		let l:close_char = '>'
	endif

	let l:open_found = -1
	let l:col = l:current_pos
	while l:col >= 1
		let l:col -= 1
		if l:line[l:col] == l:open_char
			let l:open_found = l:col
			break
		endif
	endwhile

	if l:open_found == -1
		echo "Opening character '" . l:open_char . "' not found."
		return
	endif

	let l:close_found = -1
	let l:col = l:current_pos
	while l:col < l:line_len
		let l:col += 1
		if l:line[l:col] == l:close_char
			let l:close_found = l:col
			break
		endif
	endwhile
	if l:close_found == -1
		echo "Closing character '" . l:close_char . "' not found."
		return
	endif

	execute "normal! " . (l:open_found) . "|"
	execute "normal! \"_x"

	execute "normal! " . (l:close_found) . "|"
	execute "normal! \"_x"

	execute "normal! " . (l:current_pos - 1) . "|"
endfunction

xnoremap <silent> m :<C-u>call SurroundVisualWithChar()<CR>
nnoremap <silent> m :<C-u>call DeleteSurroundWithChar()<CR>
