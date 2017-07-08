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
input_files = src/*.md
bib_file = latex/bibliography.bib
tmp = build/.tmp

# Pandoc Commands
pandoc=pandoc \
	--top-level-division=chapter \
	--filter pandoc-citeproc \
	--bibliography=$(bib_file) \
	--smart 

pandoc-csl=$(pandoc) $(input_files) \
	--csl="society-of-biblical-literature-fullnote-bibliography.csl" \
	--citation-abbreviations="abbr.json"

default: format build-all

build: setup doc odt

build-all: setup doc odt tex clean

setup:
	@ rm -rf build &&\
	mkdir build

doc:
	@ echo "Building MS Word..." && \
	$(pandoc-csl) -o build/$(title).docx

odt:
	@ echo "Building OpenDocument..." && \
	$(pandoc-csl) -o build/$(title).odt

open-doc:
	@ open build/$(title).docx

open-odt:
	@ open build/$(title).odt

open-pdf:
	@ open build/$(title).pdf

tex: clean format tex-pandoc tex-build tex-clean open-pdf

tex-pandoc:
	@ echo "Building xelatex PDF..." && \
	$(pandoc) src/01*.md --biblatex -o latex/_chapter01_rwb.tex

tex-build:
	@ mkdir $(tmp) && \
	xelatex -no-pdf --output-directory=$(tmp) latex/$(title).tex && \
	biber $(tmp)/$(title) && \
	xelatex -no-pdf --output-directory=$(tmp) latex/$(title).tex && \
	biber $(tmp)/$(title) && \
	xelatex --output-directory=$(tmp) latex/$(title).tex

tex-clean:
	@ mv $(tmp)/$(title).pdf build/$(title).pdf && \
	rm -rf $(tmp)

clean: 
	@ rm -rf $(tmp)*

format: format-partials format-concat format-biber

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