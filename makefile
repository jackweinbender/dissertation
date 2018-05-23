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
input_files = src/03*.md
bib_file = latex/bibliography.bib
tmp = build/.tmp

# Pandoc Commands
pandoc=pandoc \
	-f markdown+smart \
	--top-level-division=chapter \
	--filter ./text-expand.py

pandoc-csl=$(pandoc) $(input_files) src/99_bibliography \
	--filter pandoc-citeproc \
	--bibliography=$(bib_file) \
	--csl="society-of-biblical-literature-fullnote-bibliography.csl" \
	--citation-abbreviations="abbr.json" \
	--reference-doc=reference.docx

default: format doc #build-all

build: setup doc

build-all: setup doc tex

setup:
	@ rm -rf build &&\
	mkdir build

doc:
	@ echo "Building MS Word..." && \
	$(pandoc-csl) -o build/$(title).docx

open-doc:
	@ open build/$(title).docx

open-pdf:
	@ open build/$(title).pdf

tex: format tex-pandoc tex-full-build

tex-pandoc:
	@ echo "Building xelatex PDF..."
	@ $(pandoc) src/01*.md --biblatex -o latex/_chapter01_rwb.tex
	@ $(pandoc) src/02*.md --biblatex -o latex/_chapter02_memory.tex
	@ $(pandoc) src/03*.md --biblatex -o latex/_chapter03_genesis_apocryphon.tex
	@ $(pandoc) src/05*.md --biblatex -o latex/_chapter05_chronicles.tex

tex-build:
	@ cd latex && make build

tex-full-build:
	@ cd latex && make

format: setup format-partials format-concat format-biber

format-partials:
	@ find bib -name "_*.bib" -exec \
	biber --tool --nolog --quiet \
	--output-align \
	--output-fieldcase=lower \
	-O {} {} \;

format-concat:
	@ rm -rf $(bib_file) && \
	cat bib/*.bib > $(bib_file)

format-biber:
	@ biber --tool --nolog --quiet \
	--strip-comments \
	--output-align \
	--output-fieldcase=lower \
	--output-resolve \
	-O $(bib_file) \
	$(bib_file) && \
	cp $(bib_file) build/bibliography.bib

push: git-push gs-push-check gs-push
pull: git-pull gs-pull-check gs-pull

git-push:
	@ echo 'Pushing to GitHub...' && \
	git push github master && \
	echo 'Done.'

git-pull:
	@ echo 'Pulling from GitHub...' && \
	git pull github master && \
	echo 'Done.'

gs-push-check:
	@ echo 'Checking with Google Cloud Storage...' && \
	gsutil rsync \
	-nrdx '\..*|.*/\.[^/]*$|.*/\..*/.*$|_.*' \
	bib/files gs://jlw-dissertation/ && \
	read -p "Press enter to continue..."

gs-push:
	@ echo 'Pushing files to Google Cloud Storage...' && \
	gsutil -m rsync \
	-rdx '\..*|.*/\.[^/]*$|.*/\..*/.*$|_.*' \
	bib/files gs://jlw-dissertation/ && \
	echo 'Done.'

gs-pull-check:
	@ echo 'Retrieving files from Google Cloud Storage...' && \
	gsutil rsync \
	-nrdx '\..*|.*/\.[^/]*$|.*/\..*/.*$|_.*' \
	gs://jlw-dissertation/ bib/files && \
	read -p "Press enter to continue..."

gs-pull:
	@ echo 'Retrieving files from Google Cloud Storage...' && \
	gsutil -m rsync \
	-rdx '\..*|.*/\.[^/]*$|.*/\..*/.*$|_.*' \
	gs://jlw-dissertation/ bib/files && \
	echo 'Done.'
