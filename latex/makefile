title = dissertation_draft

default: full-build clean

full-build: 
	@ latexmk -xelatex -time -quiet -f $(title).tex

build: xelatex clean

xelatex:
	@ xelatex $(title).tex

clean:
	@ latexmk -c $(title).tex
	