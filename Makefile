PDFTEX=pdflatex
TEX=latex
BIB=bibtex
BOOK=driver
#NOWEBOPTS=-delay -index -latxe
NOWEBOPTS=-delay -index -latex
CHAR=nw/characteristic
NWFILES=$(wildcard nw/characteristic.nw nw/characteristic/*.nw)
DEFS_CMD=$(foreach file, $(NWFILES), def/$(file))
EXTRACT_CMD=$(foreach file, $(NWFILES), extract_text/$(file))
CHARACTERISTIC_SUBGROUP=$(CHAR).nw $(CHAR)/environ.nw $(CHAR)/preparatory.nw \
	$(CHAR)/automorphism.nw $(CHAR)/inner.nw $(CHAR)/results.nw \
	$(CHAR)/meet.nw $(CHAR)/centralizer.nw \
	$(CHAR)/residues-and-radicals.nw
DUMB_NWFILES=$(CHARACTERISTIC_SUBGROUP)

all: doc

check:
	mizf text/tmp

# noweb many-file extraction voodoo starts here
def/nw/%.nw:
	@echo $*
	nodefs nw/$*.nw >> all.defs
rm_defs:
	-rm all.defs
	touch all.defs
defs: rm_defs $(DEFS_CMD)
	sort -u all.defs | cpif all.defs

extract_text/nw/%.nw:
	noweave -n -indexfrom all.defs nw/$*.nw > tex/$*.tex

fancy_extract_text: defs $(EXTRACT_CMD)
	@echo $(NWFILES)
# noweb many-file extraction voodoo ends here

dumb_extract_text:
	noweave $(NOWEBOPTS) $(CHARACTERISTIC_SUBGROUP) > tex/characteristic.tex

code:
	notangle -RTEXT/char.miz $(CHARACTERISTIC_SUBGROUP) > text/char.miz
	notangle -RDICT/CHAR.VOC $(CHARACTERISTIC_SUBGROUP) > dict/char.voc

without_bib:
	$(TEX) $(BOOK)
	noindex $(BOOK)
	makeindex $(BOOK)
	makeindex mizar
	$(TEX) $(BOOK)

with_bib: without_bib
	$(BIB) $(BOOK)
	$(BIB) mml
	$(TEX) $(BOOK)
	$(TEX) $(BOOK)

doc: dumb_extract_text with_bib
	dvipdfmx $(BOOK).dvi
