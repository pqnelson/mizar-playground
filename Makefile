PDFTEX=pdflatex
TEX=latex
BIB=bibtex
BOOK=driver
#NOWEBOPTS=-delay -index -latxe
NOWEBOPTS=-latex -n
CHAR=nw/001-characteristic
NWFILES=$(wildcard nw/001-characteristic.nw nw/001-characteristic/*.nw)
DEFS_CMD=$(foreach file, $(NWFILES), def/$(file))
EXTRACT_CMD=$(foreach file, $(NWFILES), extract_text/$(file))
CHARACTERISTIC_SUBGROUP=$(CHAR).nw $(CHAR)/environ.nw $(CHAR)/preparatory.nw \
	$(CHAR)/automorphism.nw $(CHAR)/inner.nw $(CHAR)/results.nw \
	$(CHAR)/meet.nw $(CHAR)/centralizer.nw
PRODGRP=nw/002-product-group
PRODUCT_GROUP=$(PRODGRP).nw $(PRODGRP)/environ.nw $(PRODGRP)/index.nw \
	$(PRODGRP)/morphisms-of-products.nw \
	$(PRODGRP)/group-families.nw $(PRODGRP)/subgroup-family.nw \
	$(PRODGRP)/trivial-product.nw $(PRODGRP)/inclusion-morphism.nw \
	$(PRODGRP)/homomorphism-family.nw $(PRODGRP)/projection-morphism.nw \
	$(PRODGRP)/universal-properties.nw $(PRODGRP)/center-and-commutator-subgroups.nw \
	$(PRODGRP)/quotient-of-products.nw $(PRODGRP)/recognition-theorems.nw \
	$(PRODGRP)/null-object.nw $(PRODGRP)/quotient-groups.nw 
MATGRP1=nw/003-matrix-group
MATRIXGROUP1=$(MATGRP1).nw $(MATGRP1)/environ.nw $(MATGRP1)/index.nw \
	$(MATGRP1)/monoid.nw $(MATGRP1)/linear-groups-over-field.nw \
	$(MATGRP1)/special-linear-group.nw
G24=nw/004-semidirect-product
GROUP24=$(G24).nw $(G24)/environ.nw $(G24)/index.nw $(G24)/preliminaries.nw \
	$(G24)/semidirect-product.nw $(G24)/complements.nw $(G24)/universal-property.nw
RADRES=nw/003-radicals-residues
RADICALS=$(RADRES).nw $(RADRES)/environ.nw $(RADRES)/outline.nw \
	$(RADRES)/pi-numbers.nw \
	$(RADRES)/pi-group.nw $(RADRES)/hall-pi-groups.nw \
	$(RADRES)/p-cores.nw $(RADRES)/products.nw
PERMUGROUP=nw/004-permutation-group
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
#	nodefs $(CHARACTERISTIC_SUBGROUP) > 001.defs
	nodefs $(PRODUCT_GROUP) > 002.defs
	nodefs $(MATRIXGROUP1) > 003.defs
	nodefs $(GROUP24) > 004.defs
#	nodefs $(PERMUTATION_GROUP) > 004.defs
	sort -u 001.defs | cpif 001.defs
	sort -u 002.defs | cpif 002.defs
	sort -u 003.defs | cpif 003.defs

extract_text/nw/%.nw:
	noweave -n -indexfrom all.defs nw/$*.nw > tex/$*.tex

fancy_extract_text: defs $(EXTRACT_CMD)
	@echo $(NWFILES)
# noweb many-file extraction voodoo ends here

dumb_extract_text: defs
#	noweave -indexfrom 001.defs $(NOWEBOPTS) $(CHARACTERISTIC_SUBGROUP) > tex/characteristic.tex
#	noweave -indexfrom 002.defs $(NOWEBOPTS) $(PRODUCT_GROUP) > tex/product-group.tex
#	noweave $(NOWEBOPTS) -indexfrom 003.defs $(MATRIXGROUP1) > tex/matrix-group1.tex
	noweave $(NOWEBOPTS) -indexfrom 004.defs $(GROUP24) > tex/semidirect-product.tex
#	noweave $(NOWEBOPTS) -indexfrom 004.defs $(PERMUTATION_GROUP) > tex/permutation_group.tex
code:
	notangle -RTEXT/group-24.miz $(GROUP24) | tr -d '\r' > text/group_24.miz
	notangle -RDICT/group-24.voc $(GROUP24) | tr -d '\r' > dict/group_24.voc
#	notangle -RTEXT/group-22.miz $(CHARACTERISTIC_SUBGROUP) > text/group_22.miz
#	notangle -RDICT/GROUP-22.VOC $(CHARACTERISTIC_SUBGROUP) > dict/group_22.voc
#	notangle -RTEXT/group-23.miz $(PRODUCT_GROUP) | tr -d '\r' > text/group_23.miz
#	notangle -RDICT/GROUP-23.VOC $(PRODUCT_GROUP) | tr -d '\r' > dict/group_23.voc
#	notangle -RTEXT/matgrp-1.miz $(MATRIXGROUP1) | tr -d '\r' > text/matgrp_1.miz
#	notangle -RDICT/matgrp-1.voc $(MATRIXGROUP1) | tr -d '\r' > dict/matgrp_1.voc

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
