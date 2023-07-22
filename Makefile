calc: lex.yy.o mfcalc.tab.o calc.o
	gcc -o calc mfcalc.tab.o lex.yy.o calc.o -lm -ll
calc.o: calc.c
	gcc -c calc.c
mfcalc.tab.o: mfcalc.tab.c
	gcc -c mfcalc.tab.c
lex.yy.o: lex.yy.c
	gcc -c lex.yy.c
mfcalc.tab.c: mfcalc.y
	bison -d mfcalc.y
lex.yy.c: mfcalc.l mfcalc.tab.c calc.h
	flex mfcalc.l
