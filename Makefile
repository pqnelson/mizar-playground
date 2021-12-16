PDFTEX=pdflatex
TEX=latex
BIB=bibtex
BOOK=driver
#NOWEBOPTS=-delay -index -latxe
NOWEBOPTS=-delay -index -latex
CHAR=nw/characteristic
NWFILES=$(wildcard nw/*.nw nw/*/*.nw)
DEFS_CMD=$(foreach file, $(NWFILES), def/$(file))
EXTRACT_CMD=$(foreach file, $(NWFILES), extract_text/$(file))
DUMB_NWFILES=$(CHAR).nw $(CHAR)/environ.nw $(CHAR)/preparatory.nw \
	$(CHAR)/automorphism.nw $(CHAR)/isomorphism.nw $(CHAR)/results.nw

all: doc

check:
	mizf text/tmp

# noweb many-file extraction voodoo starts here
def/nw/%.nw:
	nodefs nw/$*.nw > $*.defs
defs: $(DEFS_CMD)
	nodefs *.defs | sort -u

extract_text/nw/%.nw:
	noweave -n -indexfrom all.defs nw/$*.nw > tex/$*.tex

fancy_extract_text: defs $(EXTRACT_CMD)
	@echo $(NWFILES)
# noweb many-file extraction voodoo ends here

dumb_extract_text:
	noweave $(NOWEBOPTS) $(DUMB_NWFILES) > tex/characteristic.tex

extract_code:
	notangle -RTEXT/tmp.miz $(NWFILES) > text/char.miz

without_bib:
	$(TEX) $(BOOK)
	noindex $(BOOK)
	makeindex $(BOOK)
	$(TEX) $(BOOK)

with_bib: without_bib
	$(BIB) $(BOOK)
	$(TEX) $(BOOK)
	$(TEX) $(BOOK)

doc: dumb_extract_text with_bib
	dvipdfmx $(BOOK).dvi
