PDFTEX=pdflatex
TEX=latex
BIB=bibtex
BOOK=driver
NOWEBOPTS=-delay -index -latex

all: doc

check:
	mizf text/tmp

extract_text:
	noweave $(NOWEBOPTS) nw/characteristic.nw > tex/characteristic.tex

orig_extract_text:
	noweave -delay -index -latex tutorial.nw > tutorial.tex

without_bib:
	$(TEX) $(BOOK)
	$(TEX) $(BOOK)
	dvipdfmx $(BOOK).dvi

doc: extract_text without_bib
