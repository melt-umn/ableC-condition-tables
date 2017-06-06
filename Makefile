
all: examples analyses test

build:
	@cd examples && $(MAKE) ableC.jar

examples:
	@cd examples && $(MAKE) examples

analyses: mda mwda

mda:
	@cd modular_analyses && $(MAKE) mda

mwda:
	@cd modular_analyses && $(MAKE) mwda

test:
	@cd test && $(MAKE) -ij

clean:
	rm -f *~ 
	@cd examples && $(MAKE) clean
	@cd modular_analyses && $(MAKE) clean
	@cd test && $(MAKE) clean

.PHONY: all examples analyses mda mwda test clean
