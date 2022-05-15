PDFTEX=pdflatex
TEX=latex
BIB=bibtex
BOOK=driver
#NOWEBOPTS=-delay -index -latxe
NOWEBOPTS=-latex
CHAR=nw/characteristic
NWFILES=$(wildcard nw/characteristic.nw nw/characteristic/*.nw)
DEFS_CMD=$(foreach file, $(NWFILES), def/$(file))
EXTRACT_CMD=$(foreach file, $(NWFILES), extract_text/$(file))
CHARACTERISTIC_SUBGROUP=$(CHAR).nw $(CHAR)/environ.nw $(CHAR)/preparatory.nw \
	$(CHAR)/automorphism.nw $(CHAR)/inner.nw $(CHAR)/results.nw \
	$(CHAR)/meet.nw $(CHAR)/centralizer.nw
RADRES=nw/002-radicals-residues
RADICALS=$(RADRES).nw $(RADRES)/environ.nw $(RADRES)/outline.nw \
	$(RADRES)/pi-group.nw $(RADRES)/hall-pi-groups.nw \
	$(RADRES)/p-cores.nw $(RADRES)/products.nw
PERMUGROUP=nw/003-permutation-group
PERMUTATION_GROUP=$(PERMUGROUP).nw $(PERMUGROUP)/environ.nw $(PERMUGROUP)/outline.nw \
	$(PERMUGROUP)/alternating-group.nw
DUMB_NWFILES=$(CHARACTERISTIC_SUBGROUP)
NW_UNDERSCORE=-filter 'sed "/^@use /s/_/\\\\_/g;/^@defn /s/_/\\\\_/g"'

all: doc

check:
	mizf text/tmp

# noweb many-file extraction voodoo starts here
def/nw/%.nw:
	@echo $*
	nodefs nw/$*.nw >> all.defs
rm_defs:
	-rm *.defs
	touch 001.defs
	touch 002.defs
defs: rm_defs
	nodefs $(CHARACTERISTIC_SUBGROUP) > 001.defs
	nodefs $(RADICALS) > 002.defs
	nodefs $(PERMUTATION_GROUP) > 003.defs
	sort -u 001.defs | cpif 001.defs
	sort -u 002.defs | cpif 002.defs
	sort -u 003.defs | cpif 003.defs

extract_text/nw/%.nw:
	noweave -n -indexfrom all.defs nw/$*.nw > tex/$*.tex

fancy_extract_text: defs $(EXTRACT_CMD)
	@echo $(NWFILES)
# noweb many-file extraction voodoo ends here

dumb_extract_text: defs
	noweave $(NOWEBOPTS) -n -indexfrom 001.defs $(CHARACTERISTIC_SUBGROUP) > tex/characteristic.tex
	noweave $(NOWEBOPTS) -n -indexfrom 002.defs $(RADICALS) > tex/radicals.tex
	noweave $(NOWEBOPTS) -n -indexfrom 003.defs $(PERMUTATION_GROUP) > tex/permutation_group.tex
code:
	notangle -RTEXT/group-22.miz $(CHARACTERISTIC_SUBGROUP) > text/group_22.miz
	notangle -RDICT/GROUP-22.VOC $(CHARACTERISTIC_SUBGROUP) > dict/group_22.voc
	notangle -RTEXT/group-23.miz $(RADICALS) > text/group_23.miz
	notangle -RDICT/GROUP-23.VOC $(RADICALS) > dict/group_23.voc
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
