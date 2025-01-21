# Simple Memory Test for the PCPI 88Card

This is a simple memory test to test the 64K onboard memory of the PCPI 88Card for Apple II computers.
It consists of two parts:
 1. A loader (loader65) that is written in 6502 assembly to run on the Apple II's CPU. This runs first to set up the
    8088 reset vector and then switch on the 8088 CPU.
 2. The test program itself (simplemem) that is written in 8088 assembly to run on the 8088 CPU.

If you build this entire disk image (loader & test program) then the output will look something like:

    ENTER SLOT NUMBER:
    SWITCH TO 8088
    
    
    
    SIMPLEMEM 8088
    SSSSSSSSSS DONE

Each 'S' indicates one successful test (will be 'F' on failure) and DONE is output once all tests have run


**Build Requirements**
 - A bootable disk image for DOS 3.3 (create with `INIT HELLO` from an existing DOS 3.3 disk)
 - `cc65`, for building the 6502 code 
 - `nasm`, for building the 8088 code
 - [AppleCommander](https://applecommander.github.io/), for assembling the disk image
