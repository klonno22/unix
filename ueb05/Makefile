SHELL=/bin/dash

.PHONY: all archive trimmed converted search-% help clean
.SECONDARY:

#Liest default von PDF Seite 1
FROM_PAGE=1

SRCS=$(wildcard *.pdf)
CONV=$(SRCS:.pdf=.converted)
TRIM=$(CONV:.converted=.trimmed)

ALL_TRIMMED=$(wildcard *.trimmed) $(CONV:.converted=.trimmed)

CLEAN=$(CONV:.converted=.converted) $(TRIM:.trimmed=.trimmed) archive.tgz

#ALL TARGET abhängig von archive.tgz
all: archive.tgz

#ARCHIVE TARGET abhängig von archive.tgz
archive: archive.tgz

#ARCHIVE.TGZ abhängig von den Trimmed Datein
archive.tgz:$(ALL_TRIMMED)
		@tar cfz archive.tgz $^	#Verpackt alle .trimmed Datein


#HELP TARGET gibt die Hilfe zurück
help:
		@echo "Makefile which converts pdf documents to text files"
		@echo ""
		@echo "VARIABLES"
		@echo "  FROM_PAGE   - page number of first pdf page to convert"
		@echo ""
		@echo "TARGETS"
		@echo "  all         - default target, does the same as archive target"
		@echo "  archive     - create all converted and trimmed files and an archive.tgz"
		@echo "  trimmed     - create all converted and trimmed files"
		@echo "  converted   - create all converted files"
		@echo "  search-WORD - create all converted files and search for a given WORD"
		@echo "  help        - display this help and exit"
		@echo "  clean       - remove all generated files"

#CONVERTED abhängig von allen .converted Datein
converted: $(CONV)

#CONVERTED TARGET jede PDF in .converted Datein umwandeln mit Default
%.converted: %.pdf
		@pdftotext -f $(FROM_PAGE) $< $@

trimmed: $(TRIM)

%.trimmed: %.converted
			@cat $^ | grep -v -E 'Seite [0-9]+' > $@

#SEARCH TARGET sucht in allen .converted Datein nach SuchWort ($*)
search-%: $(CONV)
		@grep $* $^


#CLEAN TARGET Löscht alles was keine Quelldatei hat oder keine Quelldatei ist
clean: $(CLEAN)
			@rm -f $^
