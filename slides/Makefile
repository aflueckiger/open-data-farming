## Put this Makefile in your project directory---i.e., the directory
## containing the paper you are writing. Assuming you are using the
## rest of the toolchain here, you can use it to create .html, .tex,
## and .pdf output files (complete with bibliography, if present) from
## your markdown file.
## -	Change the paths at the top of the file as needed.
## -	Using `make` without arguments will generate html, tex, and pdf
## 	output files from all of the files with the designated markdown
##	extension. The default is `.md` but you can change this.
## -	You can specify an output format with `make tex`, `make pdf` or
## - 	`make html`.
## -	Doing `make clean` will remove all the .tex, .html, and .pdf files
## 	in your working directory. Make sure you do not have files in these
##	formats that you want to keep!


## Markdown extension (e.g. md, markdown, mdown).
MEXT = md

## All markdown files in the working directory
SRC = $(filter-out README.md, $(wildcard *.$(MEXT)))


## Location of CSS file
CSS = resources/custom_style_reveal.css

# Cross reference options
CROSSREF = --filter pandoc-crossref -M figPrefix:"Figure" -M eqnPrefix:"Equation" -M tblPrefix:"Table"

PDFS=$(SRC:.md=.pdf)
HTML=$(SRC:.md=.html)
TEX=$(SRC:.md=.tex)


MD_DIR?= md_slides
PDF_DIR?= pdf_slides
TEX_DIR?= tex_slides
HTML_DIR?= html_slides

md_slides := $(wildcard $(MD_DIR)/*.md)
pdf_slides := $(patsubst $(MD_DIR)/%.md,$(PDF_DIR)/%.pdf,$(md_slides))
tex_slides := $(patsubst $(MD_DIR)/%.md,$(TEX_DIR)/%.tex,$(md_slides))
html_slides := $(patsubst $(MD_DIR)/%.md,$(HTML_DIR)/%.html,$(md_slides))


print-%:
	@echo $* = $($*)

prepare-dir:
	mkdir -p $(MD_DIR)
	mkdir -p $(PDF_DIR)
	mkdir -p $(TEX_DIR)
	mkdir -p $(HTML_DIR)

all:	$(PDFS) $(HTML) $(TEX)

html:	clean $(HTML)
tex:	clean $(TEX)


%.html:	%.md
	pandoc -f markdown+emoji -t revealjs -s -o $@ $< \
	-V revealjs-url=https://cdn.jsdelivr.net/npm/reveal.js  \
	-V navigationMode=linear \
	-V theme=white \
	-V slideNumber=true \
	-V biblio-title:References \
	--include-in-header $(CSS)



clean:
	rm -f *.html *.pdf *.tex *.bcf *.blg
