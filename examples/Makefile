# Top-level directory containing ableC repository and extensions folder
ABLEC_BASE?=../../../ableC
EXTS_BASE?=../../../extensions

# All directories containing grammars that may be included
GRAMMAR_DIRS=$(ABLEC_BASE) $(EXTS_BASE)/ableC-condition-tables/grammars

# All silver files in included grammars, to be included as dependancies
GRAMMAR_SOURCES=$(shell find $(GRAMMAR_DIRS) -name *.sv -print0 | xargs -0)


all: ableC.jar examples

ableC.jar: $(GRAMMAR_SOURCES)
	touch artifact/Artifact.sv
	silver -o $@ -I $(ABLEC_BASE) \
		     -I $(EXTS_BASE)/ableC-condition-tables/grammars \
		     artifact

examples: simple.out altitude_switch.out

simple.c: ableC.jar simple.xc
	java -jar ableC.jar simple.xc

simple.out: simple.c
	gcc simple.c -o simple.out

altitude_switch.c: ableC.jar altitude_switch.xc
	java -jar ableC.jar altitude_switch.xc

altitude_switch.out: altitude_switch.c
	gcc altitude_switch.c -o altitude_switch.out

type_error.c: ableC.jar type_error.xc
	java -jar ableC.jar type_error.xc

mismatched_rows.c: ableC.jar mismatched_rows.xc
	java -jar ableC.jar mismatched_rows.xc

clean:
	rm -f *~ *.i *.c *.o *.out *.test *.jar *.copperdump.html build.xml

.PHONY: all clean
