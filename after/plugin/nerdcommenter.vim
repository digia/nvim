"
" preservim/nerdcommenter 
"
let g:NERDSpaceDelims = 1 " Add spaces after comment delimiters by default
let g:NERDTrimTrailingWhitespace = 1 " Enable trimming of trailing whitespace when uncommenting
let g:NERDCreateDefaultMappings = 0 " Do not create the default mappings since they're <leader> prefixed

map gcc <plug>NERDCommenterToggle
map gcn <plug>NERDCommenterNested
map gci <plug>NERDCommenterInvert
map gcy <plug>NERDCommenterYank
map gc$ <plug>NERDCommenterToEOL
map gcA <plug>NERDCommenterAppend
map gcu <plug>NERDCommenterUncomment
map gcm <plug>NERDCommenterMinimal
map gcs <plug>NERDCommenterSexy

