# Download AppleCommander from https://applecommander.github.io/install/
AC ?= java -jar AppleCommander-ac-1.9.0.jar

capture.apple2: capture.asm
	cl65 -t apple2 -C apple2-asm.cfg -u __EXEHDR__ apple2.lib -l $@.lst -o $@ $^

test.dsk: capture.apple2
	cp DOS_3.3_boot.dsk $@~
	$(AC) -d $@~ startup
	$(AC) -as $@~ capture bin < capture.apple2 
	mv $@~ $@

clean:
	rm -f *.o *.lst *.apple2 test.dsk
