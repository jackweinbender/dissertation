# Makefile for dissertation

# Requirements:
#	xelatex
#		- biblatex-sbl
#	make

# Run `make` to build

default: biber build-tex-full

build-tex-full:
	@ echo 'Starting Latexmk...'
	@ cd latex && make

build-tex:
	@ echo 'Starting xelatex...'
	@ cd latex && make xelatex

clean:
	@ cd latex && make clean

biber:
	@ echo 'Processing .bib files...'
	@ cd bib && make

push: git-push gs-push-check gs-push
pull: git-pull gs-pull-check gs-pull

git-push:
	@ echo 'Pushing to GitHub...' && \
	git push github --all && \
	echo 'Done.'

git-pull:
	@ echo 'Pulling from GitHub...' && \
	git pull github --all && \
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

gs-login:
	@ gcloud auth login