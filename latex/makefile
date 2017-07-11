tmp = .tmp
title = dissertation

default: full-build clean

full-build: 
	@ latexmk -xelatex -time -quiet -f $(title).tex

build: xelatex clean

xelatex:
	@ xelatex $(title).tex

clean:
	@ mv $(title).pdf ../build/$(title).pdf
	@ latexmk -c $(title).tex
	