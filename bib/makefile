bib_file = bibliography.bib

default: bibliography.bib
	
format-partials:
	@ find . -name "_*.bib" -exec \
	biber --tool --nolog --quiet \
	--output-align \
	--output-fieldcase=lower \
	-O {} {} \;

bibliography.bib: concat
	@ biber --tool --nolog --quiet \
	--strip-comments \
	--output-align \
	--output-fieldcase=lower \
	--output-resolve \
	-O $(bib_file) \
	$(bib_file)

concat: format-partials
	@ rm -rf $(bib_file) && \
	cat _*.bib > $(bib_file)