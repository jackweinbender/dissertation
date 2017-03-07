# Makefile for dissertation

# Requirements:
#	pandoc
#		- pandoc-citeproc
#		- society-of-biblical-literature-fullnote-bibliography.csl
#	xelatex
#		- biblatex-sbl
#	make

# Run `make` to build

# Document specifics
title = dissertation
input_file = src/*.md
bib_file = src/bibliography.bib

# Pandoc Commands
pandoc=pandoc \
	--top-level-division=chapter \
	--filter pandoc-citeproc \
	--bibliography=$(bib_file) \
	--smart $(input_file)

pandoc-csl=$(pandoc) \
	--csl="society-of-biblical-literature-fullnote-bibliography.csl" \
	--citation-abbreviations="abbr.json"

default: format build

build: setup doc odt tex clean

setup:
	@ rm -rf build &&\
	mkdir build

doc:
	@ echo "Building MS Word..." && \
	$(pandoc-csl) -o build/$(title).docx

odt:
	@ echo "Building OpenDocument..." && \
	$(pandoc-csl) -o build/$(title).odt


tex: clean tex-pandoc tex-build tex-clean

tex-pandoc:
	@ echo "Building xelatex PDF..." && \
	mkdir tmp && \
	$(pandoc) --biblatex --latex-engine=xelatex \
	--template=src/template.tex \
	-so tmp/$(title).tex

tex-build:
	@ xelatex -no-pdf --output-directory=tmp tmp/$(title).tex && \
	biber tmp/$(title) && \
	xelatex --output-directory=tmp tmp/$(title).tex

tex-clean:
	@ mv tmp/$(title).pdf build/$(title).pdf && \
	rm -rf tmp

clean: 
	@ rm -rf tmp*

format:
	@ biber --tool --nolog --quiet \
	--output-fieldcase=lower \
	--output-field-order=[title] \
	-O $(bib_file) \
	$(bib_file)