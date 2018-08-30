.PHONY: all clean
all:
	@echo "\n---------------------\n## Documenting...\n---------------------\n"
	Rscript -e "devtools::document(roclets=c('rd', 'collate', 'namespace'))"
	@echo "\n---------------------\n## Installing...\n---------------------\n"
	R CMD INSTALL --no-multiarch --with-keep.source .
clean:
	@echo "\n---------------------\n## Cleaning docs...\n---------------------\n"
	rm man/*.Rd
