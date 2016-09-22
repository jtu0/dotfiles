" my filetype file
if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  au! BufRead,BufNewFile *.mine         setfiletype mine
  au! BufRead,BufNewFile *.rhtml        setfiletype html
  au! BufRead,BufNewFile *.html.erb     setfiletype html
augroup END

