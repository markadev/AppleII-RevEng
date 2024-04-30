---
layout: subpage
title: Precision Software FingerPrint GSi Card
---
This is an expansion card for the Apple IIgs to print screen captures of any program without needing
program modifications. There is an external "fingerprint" switch that triggers the screen capture
when pressed.

The card contains a 65C02 CPU onboard along with some ROM and RAM.  My card was populated with 48KiB
of ROM and 8KiB of SRAM but the card could hold up to 128KiB of ROM and 32KiB of SRAM using banking.
It does not contain a printer interface of its own, instead printing to either one of the onboard IIgs
ports or a companion FingerPrint printer interface card.

The components on the card are not labeled so I [took the liberty of defining some](front_annotated.jpg)
so that the board can be cross-referenced with the schematic.

The majority of the logic is contained in two PAL devices labelled "FINGERPRINT 1" and "FINGERPRINT 2".
They are purely combinatorial logic so it was possible to easily dump each of their truth tables which
are included:
 * [FINGERPRINT1 truth tables](PAL10L8_FINGERPRINT1_U11_tables.md)
 * [FINGERPRINT2 truth tables](PAL10L8_FINGERPRINT2_U10_tables.md)

[Schematic](Schematic.pdf) | [KiCad Project & all artifacts]({{ site.github.repository_url }}/tree/main{{ page.dir }})


### Front Image

![front](front.jpg)

### Back Image

![back](back.jpg)


### Internal memory map

Based on the address decoding, the card ROMs and RAM are not accessible by the Apple II's main CPU. The
internal memory map for the card's 65C02 processor looks something like:

| Range           | Description
| -----           | -----------
| `$0000 - $01ff` | SRAM for zeropage and stack (also decoded at `$a000 - $a1ff`)
| `$0200 - $02ff` | `/REG_BANK_SEL` (access to internal I/O register bank)
| `$0300 - $9fff` | When `/BUS_HELD` is asserted then reads and writes will go to the Apple system memory. Accesses to `$0c00 - $0cff` will trigger an NMI on the host.
| `$a000 - $bfff` | SRAM
| `$e000 - $ffff` | ROM

Page $02 holds the addresses of local on-card I/O registers that are only accessible by the
on-card CPU.

#### Register $0200 (read)

This register allows reading the configuration DIP switches.

| bit(s) | Description
| ------ | -----------
|  7:1   | DIP switch 1 - 7 state
|   0    | The current value of the `/DATAREAD_IN` signal

#### Register $0200 (write)

Writing any value to this register will end the card's DMA takeover of the Apple bus.

#### Register $0201 (write)

Writing any value to this register enables ROM 2 and disables ROM 1.

#### Register $0202 (write)

Writing any value to this register enables ROM 1 and disables ROM 2. ROM 1 is the selected
ROM after a RESET.

#### Register $0203 (write)

This register controls RAM/ROM banking and enabling of the screen capture IRQ.

| bit(s) | Description
| ------ | -----------
|   7    | *unused*
|   6    | Controls the ROM A15 address bit.
|   5    | *unused*
|   4    | Setting to 1 enables screen captures when running in native IIgs mode.
|   3    | Controls the SRAM A14 address bit.
|   2    | Controls the SRAM A13 address bit.
|   1    | Controls the ROM A14 address bit.
|   0    | Controls the ROM A13 address bit.
