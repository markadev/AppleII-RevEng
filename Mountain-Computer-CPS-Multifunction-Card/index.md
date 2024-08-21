---
layout: subpage
title: Mountain Computer CPS Multifunction Card
---
This is a multifunction card that contains a clock, a parallel port, and a serial port. There is also 256 bytes of
battery-backed SRAM that stores the card configuration. The manual is nice in that it describes all the registers
and how to use the card's hardware directly.

This card has the ability to make the I/O devices appear as "phantom" devices in any slot. It does this by decoding
the full address bus (instead of just using `/IOSEL`) and `U25`, configured by the host CPU, decides if the slot
being accessed should be handled by the card. The manual describes that pin header `J6` is also used with a companion
board that replaces an IC on the main logic board to help with this "phantom slot" feature. I don't have this board
so I'm not able to capture its schematic.

It's not clear what the SRAM chips being used are but they appear to be mostly pin-compatible with 2114 SRAM chips.

[Schematic](Schematic.pdf) | [KiCad Project & all artifacts]({{ site.github.repository_url }}/tree/main{{ page.dir }})


### Front Image

![front](front.jpg)

### Back Image

Note: There is supposed to be a 2xAA battery holder attached to the back but mine had broken off so this photo shows
just the PCB.

![back](back.jpg)
