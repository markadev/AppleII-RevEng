# Spies Laboratories NicePrint Card

Apple II printer card

## Notes

This card has 3 EPROMs (documented also in the manual). U4 is the traditional Apple expansion card ROM
and U5 & U7 are optional font ROMs. Dumps of all three ROMs from the card I have are included. The
stickers on the font ROMs I have don't look official so I'm not sure if they contain original or
customized fonts.

Compared to some other printer cards, this card design has some bizarre design elements that may be
partially explained if the firmware was disassembled.

 * There's a 1024x4 bit SRAM that can be addressed by the CPU.
 * The ROM decoding logic behaves differently depending on if the card is installed in slots 1-3 or
   slots 4-7, based on the value of the A10 line. The manual states that the card can be installed in
   any slot so I assume the firmware works around this quirkiness.
 * The ROM banking looks it will swap out the entire `$C800-$CFFF` and `$Cn00-$CnFF` regions, so driver
   code will either need to be running from system RAM or be duplicated in the ROM.
 * Based on the way the ROM's A11 line is handled, I'm not sure all the ROM space is addressable.
 * R1 looks like a superfluous pull-up resistor on the ROM A11 signals.
 * R2 is a set of pull-down resistors on the Apple's data bus, maybe related to the 4-bit wide SRAM.
