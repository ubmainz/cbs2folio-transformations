# Sources:
# - https://devhints.io/makefile
#
TRANSFORMER:=poetry run python scripts/transform.py
FORMATTER:=xmllint --encode UTF-8 --format

BUILDDIR:=build
OUTDIR:=$(BUILDDIR)/out
DIFFDIR:=$(BUILDDIR)/diff

test_files:=$(patsubst hebis/testexamples/%, $(OUTDIR)/%, $(wildcard hebis/testexamples/iln*step*.xml))

TEST: $(test_files)

BUILDDIRS: 
	mkdir --parents $(OUTDIR) $(DIFFDIR)

$(OUTDIR)/%-step1.xml: hebis/testexamples/%.xml hebis/pica2instance-new.xsl BUILDDIRS
	$(TRANSFORMER) --in-file $< --out-file $@ hebis/pica2instance-new.xsl
	$(FORMATTER) --output $@ $@

$(OUTDIR)/%-step2.xml: hebis/testexamples/%-step1.xml hebis/relationships.xsl BUILDDIRS
	$(TRANSFORMER) --in-file $< --out-file $@ hebis/relationships.xsl  
	$(FORMATTER) --output $@ $@

$(OUTDIR)/%-step3.xml: hebis/testexamples/%-step2.xml hebis/holdings-items-hebis-hrid-test.xsl BUILDDIRS
	$(TRANSFORMER) --in-file $< --out-file $@ hebis/holdings-items-hebis-hrid-test.xsl
	$(FORMATTER) --output $@ $@

$(OUTDIR)/%-step4.xml: hebis/testexamples/%-step3.xml hebis/holding-items-hebis-%.xsl BUILDDIRS
	$(TRANSFORMER) --in-file $< --out-file $@ hebis/holding-items-hebis-$*.xsl 
	$(FORMATTER) --output $@ $@

$(OUTDIR)/%-step5.xml: hebis/testexamples/%-step4.xml codes2uuid.xsl BUILDDIRS
	$(TRANSFORMER) --in-file $< --out-file $@ codes2uuid.xsl  
	$(FORMATTER) --output $@ $@

$(OUTDIR)/%-step6.xml: hebis/testexamples/%-step5.xml  hebis/codes2uuid-hebis-%.xsl BUILDDIRS
	$(TRANSFORMER) --in-file $< --out-file $@  hebis/codes2uuid-hebis-$*.xsl 
	$(FORMATTER) --output $@ $@
