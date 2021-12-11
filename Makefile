PDFTEX=pdflatex
TEX=latex
BIB=bibtex

all: doc

check:
	mizf text/tmp

extract_text:
	noweave -delay -index -latex tutorial.nw > tutorial.tex

without_bib:
	$(TEX) tutorial
	$(TEX) tutorial
	dvipdfmx tutorial.dvi

doc: extract_text without_bib
