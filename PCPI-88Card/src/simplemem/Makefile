# Download AppleCommander from https://applecommander.github.io/install/
AC ?= java -jar AppleCommander-ac-1.9.0.jar

NASM ?= nasm


simplemem.dsk: HELLO.bas loader65.apple2 simplemem.bin
	cp DOS_3.3_boot.dsk $@~
	$(AC) -d $@~ HELLO
	$(AC) -bas $@~ HELLO < HELLO.bas
	$(AC) -as $@~ LOADER65 bin < loader65.apple2 
	$(AC) -p $@~ SIMPLEMEM bin 0x1000 put stdin < simplemem.bin
	mv $@~ $@

loader65.apple2: loader65.asm
	cl65 -t apple2 -C apple2-asm.cfg -u __EXEHDR__ apple2.lib -l $@.lst -o $@ $<

simplemem.bin: simplemem.asm
	$(NASM) -o $@ -l $@.lst $<

clean:
	rm -f *.o *.bin *.lst *.apple2 simplemem.dsk
