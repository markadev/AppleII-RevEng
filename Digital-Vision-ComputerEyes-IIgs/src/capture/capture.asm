.include "apple2.inc"
.feature STRING_ESCAPES

; This is a sample program to capture a video frame from a ComputerEyes IIgs
; on any Apple II+ or IIe. Only captures a black & white image and displays it
; in hires mode. It's not great but better than nothing when you don't have
; a IIgs available to try out the card. Run using a monochrome display to avoid
; the composite color artifacts.

WARM_START  = $03D0
HGR2        = $4000     ; hires Page 2
HOME        = $FC58     ; clear screen and home the cursor
COUT        = $FDED     ; routine to output a character
DEVIO_BASE0 = $C080
DEVIO_BASE1 = $C081

KEY_0   = $30
KEY_1   = $31
KEY_7   = $37
KEY_8   = $38
KEY_ESC = $1B

; define some common zero page pseudo-registers
tmp1 := $f8     ; 1 byte  | temporary value | preserved by caller
tmp2 := $f9     ; 1 byte  | temporary value | preserved by caller 
tmp3 := $fa     ; 1 byte  | temporary value | preserved by caller 
tmp4 := $fb     ; 1 byte  | temporary value | preserved by caller 
ptr1 := $fc     ; 2 bytes | pointer         | preserved by caller
ptr2 := $fe     ; 2 bytes | pointer         | preserved by caller


.rodata

; Build a lookup table for the start of every screen row
hires_rowL:
    .repeat $C0, Row
        .byte Row & $08 << 4 | Row & $C0 >> 1 | Row & $C0 >> 3
    .endrep
hires_rowH:
    .repeat $C0, Row
        .byte >HGR2 | Row & $07 << 2 | Row & $30 >> 4
    .endrep
threshold_mapping:
    ; these can be bit patterns so that a solid gray color would result in
    ; a stipple pattern.
    .byte $00,$00,$04,$08,$22,$44,$11,$29,$52,$29,$2d,$2d,$5d,$5d,$5d,$7d
    .byte $7d,$7d,$7d,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f


.data

CARD_IO_OFFSET: .byte 0
horizontal_adjustment: .byte 0
vertical_adjustment: .byte 0


.code
.proc main
    jsr HOME

    lda #$78
    sta horizontal_adjustment   ; increase to shift left

    lda #$1c
    sta vertical_adjustment     ; increase to shift up

get_slot:
    jsr emprint
    .asciiz "ENTER SLOT NUMBER: "
:
    jsr waitkey
    cmp #KEY_ESC
    bne not_exit
    jmp exit
not_exit:
    sec
    sbc #KEY_0
    beq :-                  ; branch if A == 0
    bmi :-                  ; branch if A < 0
    cmp #8
    bpl :-                  ; branch if A >= 8
    asl A
    asl A
    asl A
    asl A
    sta CARD_IO_OFFSET      ; save slot register offset

    jsr emprint
    .asciiz "\rCHECKING FOR CAPTURE CARD... "
    jsr detect_card
    bcc found_card

    jsr emprint
    .asciiz "FAIL\r"
    jmp exit

found_card:
    jsr emprint
    .asciiz "OK\r"

    jsr emprint
    .asciiz "CHECKING FOR VIDEO SYNC... "
    jsr detect_video
    bcc found_video

    jsr emprint
    .asciiz "FAIL\r"
    jmp exit

found_video:
    jsr emprint
    .asciiz "OK\r"

    ; Enable HIRES page 2
    bit TXTCLR          ; Display Graphics, Text Off
    bit MIXCLR          ; Turn off the bottom 4 lines of text
    bit HISCR           ; Page 2
    bit HIRES           ; Hires Graphics

    jsr clear_hires
    jsr capture_hires
    jsr waitkey

    ; Set back to TEXT page 1
    bit TXTSET          ; turn text mode back on
    bit LOWSCR          ; Page 1 memory active

exit:
    jmp WARM_START
.endproc


.proc waitkey
    sta KBDSTRB         ; clear the keyboard strobe bit (bit 7 in KBD)
wait_for_key:
    lda KBD             ; get a key
    bpl wait_for_key    ; loop till bit 7 is set, meaning there's a new key
    sta KBDSTRB         ; clear the keyboard strobe bit
    and #$7f
    rts                 ; key returned in A
.endproc


; This function unpops the stack to find the embedded string. It outputs one
; character at a time until a $00 marker is found and then it jumps back to
; the calling program just beyond the string.
.proc emprint
    XSAV := tmp1
    YSAV := tmp2
    ASAV := tmp3
    STRP := ptr1

    stx XSAV        ; save registers
    sty YSAV
    sta ASAV

    pla             ; get pointer low and save
    sta STRP
    pla             ; get pointer high and save
    sta STRP+1

    ldy #0
_nextchar:
    inc STRP        ; increment 16-bit address
    bne :+
    inc STRP+1
:

    lda (STRP),Y    ; get character
    beq _end        ; check for zero marker
    ora #$80
    jsr COUT        ; print character
    clc             ; branch always
    bcc _nextchar

_end:
    lda STRP+1      ; restore PC low
    pha
    lda STRP        ; restore PC high
    pha
    ldx XSAV        ; restore registers
    ldy YSAV
    lda ASAV
    rts
.endproc


; Clobbers:
;   X
.proc clear_hires
    lda #0                      ; 0 is all pixels off
    tax                         ; start the index at 0
:
    .repeat $20, B              ; $20 * $100 = $2000 - one whole HGR buffer
        sta HGR2+(B*256),X      ; write 0's to page 2
    .endrep

    dex                         ; do for all 256 
    bne :-                      ; when x is 0 again, done

    rts
.endproc


; Check if the ComputerEyes card is present
; Inputs:
;  * CARD_IO_OFFSET - The offset of the card's device registers relative to $C080
; Outputs:
;   The C flag indicates if the card was detected. C=0 means present, C=1 means the card was
;   not found.
; Clobbers:
;   X
.proc detect_card
    ldx CARD_IO_OFFSET

    lda #$01
    sta DEVIO_BASE0,X           ; write with bit 4 clear (also reset the horizontal sweep)
    lda DEVIO_BASE0,X           ; read back
    and #$40
    bne card_not_found          ; branch if bit 6 is not clear

    lda #$11
    sta DEVIO_BASE0,X           ; write with bit 4 set
    lda DEVIO_BASE0,X           ; read back
    and #$40
    beq card_not_found          ; branch if bit 6 is not set

    lda #$01
    sta DEVIO_BASE0,X           ; write with bit 4 clear
    lda DEVIO_BASE0,X           ; read back
    and #$40
    bne card_not_found          ; branch if bit 6 is not clear

    clc
    rts

card_not_found:
    sec
    rts
.endproc


; Returns:
;   C=1 means sync not detected
.proc detect_video
    counter := tmp1

    ldx CARD_IO_OFFSET
    lda #0
    sta counter
loop1:
    inc counter
    beq timeout
    lda DEVIO_BASE0,X
    and #$80
    beq loop1

    lda #0
    sta counter
loop2:
    inc counter
    beq timeout
    lda DEVIO_BASE0,X
    and #$80
    bne loop2

    clc
    rts

timeout:
    sec
    rts
.endproc


; Capture an image to the hires screen
.proc capture_hires
    hires_bit := tmp1
    hires_line_byte := tmp2
    hires_ptr := ptr1

    jsr detect_video

    ldx CARD_IO_OFFSET
    lda #$0c
    sta DEVIO_BASE0,X                   ;bring the horizontal sweep out of reset to begin the scan

    ldy horizontal_adjustment           ;skip a number of columns for horizontal alignment
skip_left_side_column:
    jsr wait_for_vsync
    dey
    bne skip_left_side_column

    ; setup outer loop variables to iterate over each column
    lda #$01
    sta hires_bit                       ;hires_bit = $01
    lda #0
    sta hires_line_byte                 ;hires_line_byte = 0

    ldx CARD_IO_OFFSET
    lda #$8c
    sta DEVIO_BASE0,X                   ;set up to sample the blue channel for the monochrome data

capture_next_column:
    jsr wait_for_vsync

    ldx #0                              ;X = 0, X holds the line number

; each loop should be machine 65 cycles
capture_pixel_loop:
    ldy CARD_IO_OFFSET                  ;[3] Y = CARD_IO_OFFSET
    sta DEVIO_BASE1,Y                   ;[5] trigger sampling of the video data

    lda hires_rowL,X                    ;[4] hires_ptr = hires_row[line]
    sta hires_ptr                       ;[3]
    lda hires_rowH,X                    ;[4]
    sta hires_ptr+1                     ;[3]

    lda DEVIO_BASE0,Y                   ;[4] read the sampled video value at least 9us after it was triggered

    and #$3f                            ;[2] convert the analog value to a bit
    tay                                 ;[2]
    lda threshold_mapping,Y             ;[4]
    and hires_bit                       ;[3]

    ldy hires_line_byte                 ;[3] hires_ptr[hires_line_byte] |= A
    ora (hires_ptr),Y                   ;[5]
    sta (hires_ptr),Y                   ;[6]

    nop                                 ;[2] pad out the loop to 65 cycles
    nop                                 ;[2]
    ldy hires_line_byte                 ;[3]

    inx                                 ;[2]
    cpx #192                            ;[2]
    bne capture_pixel_loop              ;[3]

    ; rotate to the next hires memory bit
    asl hires_bit
    bpl :+
    lda #$01
    sta hires_bit                       ;rotate around from bit 6 to bit 0
    inc hires_line_byte                 ;hires_line_byte++
:
    lda hires_line_byte
    cmp #40
    beq capture_done

    jmp capture_next_column

capture_done:
    ldx CARD_IO_OFFSET
    lda #$01
    sta DEVIO_BASE0,X                   ;reset capture card
    bit KBDSTRB                         ;clear any key that was pressed
    rts
.endproc


; Post-conditions:
;  * X=CARD_IO_OFFSET
;  * Clobbers: A
.proc wait_for_vsync
    ldx CARD_IO_OFFSET
loop:
    lda DEVIO_BASE0,X
    bmi loop                ; loop until video is in a blanking period

    pha
    pla
    nop
    nop                     ; 10.76us delay

    lda DEVIO_BASE0,X
    bmi loop                ; loop if video is still not in the blanking period

    ; at this point we're in the vertical blanking period, which is longer than the
    ; horizontal blanking period (10.9us)

    lda vertical_adjustment
    jsr precise_delay
    rts
.endproc


; pre-loop: 2 cycles
; post-loop: 6 cycles
; loop:
;   A=1: 15 cycles -> 22.5us
;   A=2: 21+15 = 36 cycles -> 43us
;   A=3: 26+21+15 = 62 cycles -> 68.4us
;   A=4: 31+26+21+15 = 93 cycles -> 98.8us
;   A=5: 36+31+26+21+15 = 129 cycles -> 134us
; Clobbers: A
.proc precise_delay
    sec                 ; [2]
outer_loop:
    pha                 ; [3]
inner_loop:
    sbc #1              ; [2]
    bne inner_loop      ; [2+t]
    pla                 ; [4]
    sbc #1              ; [2]
    bne outer_loop      ; [2+t]
    rts                 ; [6]
.endproc


; vim:set ts=4 sw=4 expandtab:
