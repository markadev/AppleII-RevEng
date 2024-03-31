---
layout: subpage
title: Digital Vision ComputerEyes IIgs
---
[Schematic](Schematic.pdf) | [KiCad Project & all artifacts]({{ site.github.repository_url }}/tree/main{{ page.dir }})

This card is a color video digitizer made for the Apple IIgs. It is basically just a simple NTSC-to-RGB converter
with an analog-to-digital converter that the CPU polls to read the video data. A full color scan is done one column
at a time and takes 6 seconds to complete. Chapter 6 of the manual contains a high level description of how a capture
is done.

The card itself has none of the components labeled so I took the liberty of [labeling them](front_annotated.jpg)
so the components can be linked to the schematic. There is an IC (labeled U7) that has the identifier sanded off
on all pictures of this card that I could find however I found that this IC appears to be a `TDA3330` "TV Color
Processor".


### Front Image

![front](front.jpg)


### Back Image

![back](back.jpg)


### Device Registers

The device has some I/O registers located at address `$c080 + $10*<slot>`.

#### Register 0 (read) - Data Read

This register returns the RGB data and some control bits.

| bit(s) | Description
| ------ | -----------
|   7    | Will be 0 when the video signal is in a blanking period
|   6    | SENSE. Will be the value that was stored at this register in bit 4.
|  5:0   | The 6-bit sampled value for the selected color

#### Register 0 (write) - Scan Control

This register is used to control the video scanner hardware.

| bit(s) | Description
| ------ | -----------
|   7    | Enable sampling of the blue color channel. Do not enable more than one color channel at a time.
|   6    | Enable sampling of the green color channel. Do not enable more than one color channel at a time.
|   5    | Enable sampling of the red color channel. Do not enable more than one color channel at a time.
|   4    | SENSE. Will be readable as bit 6.
|   3    | Disables color to capture a grayscale image
|   2    | Use "fast" horizontal scans (6 seconds)
|   1    | Switch the capturing input to the monitor output for preview
|   0    | Reset the horizontal scanner delay

#### Register 1 - Trigger ADC

**write-only**

This register is only used to trigger the analog-to-digital to perform a conversion. The value written to
the register doesn't matter.
