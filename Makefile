SOURCES=Thesis-main


DVIS=$(SOURCES:=.dvi)
PDFS=$(SOURCES:=.pdf)
BBL=$(SOURCES:=.bbl)
AUX=$(SOURCES:=.aux)
PS=$(SOURCES:=.ps)

default: $(PDFS)
#default: $(PS)

$(PDFS): %.pdf: %.ps
	@echo "------------------making $@------------------"
#	dvipdf $<
	ps2pdf -dCompatibilityLevel=1.4 -dPDFSETTINGS=/printer -dSubsetFonts=true -dEmbedAllFonts=true $<

$(PS): %.ps: %.dvi
	@echo "------------------making $@------------------"
	dvips  -Ppdf -G0 -o $@ $<

$(DVIS): %.dvi: %.tex %.bbl
	@echo "------------------making $@------------------"
	latex $<
	latex $<
	touch *.bbl $@

$(BBL): %.bbl: %.aux
	@echo "------------------making $@------------------"
	bibtex $<

$(AUX): %.aux: %.tex
	@echo "------------------making $@------------------"
	latex $<

tarball: clean
	today=`date +%d%m%y` ;\
	tar cvzf ../$(SOURCES).$$today.tar.gz .
clean:
	rm -f *.log *.aux *.dvi $(SOURCES).pdf *.gz *.tmp *.blg $(SOURCES).ps $(SOURCES).bbl
	rm -f *~
