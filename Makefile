compile: aoc-lib $(day)/sol.scm
	csc aoc-lib.o -uses aoc-lib $(day)/sol.scm -o out
aoc-lib: aoc-lib.sld
	csc -c -J aoc-lib.sld -unit aoc-lib
clean:
	rm -f *.o
	rm -f out
	rm -f result
	rm -f *.link
	rm -f *.import.scm
	rm -f *.c
