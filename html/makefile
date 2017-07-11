title = dissertation

default: full-build clean

full-build: 
	@ htlatex $(title).tex "xhtml, charset=utf-8" " -cunihtf -utf8"

clean:
	@ cat *.html > $(title).html
	@ mv $(title).html ../build/$(title).html
	@ rm -rf *.html
	@ latexmk -c $(title).tex
	