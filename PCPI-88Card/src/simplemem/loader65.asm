.include "apple2.inc"
.feature STRING_ESCAPES

WARM_START  = $03D0
HOME        = $FC58     ; clear screen and home the cursor
COUT        = $FDED     ; routine to output a character

KEY_0   = $30
KEY_ESC = $1B


; define zero page vars
CARD_IO_BASE := $f6  ; 2 bytes

; define some common zero page pseudo-registers
tmp1 := $f8     ; 1 byte  | temporary value | preserved by caller
tmp2 := $f9     ; 1 byte  | temporary value | preserved by caller 
tmp3 := $fa     ; 1 byte  | temporary value | preserved by caller 
tmp4 := $fb     ; 1 byte  | temporary value | preserved by caller 
ptr1 := $fc     ; 2 bytes | pointer         | preserved by caller
ptr2 := $fe     ; 2 bytes | pointer         | preserved by caller


.code
.proc main
    jsr HOME

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
    adc #$c0                ; CARD_IO_BASE = $Cn00, with n = slot number
    sta CARD_IO_BASE+1
    lda #0
    sta CARD_IO_BASE

    ; Set up the 8088 reset vector (8088 address $FFFF0) at the address it maps to
    ; in the Apple II memory ($0FF0).
    ;
    ; The 8088 code should be loaded into the Apple II memory at address $1000 which
    ; is accessible by the 8088 at segment:offset $1000:0000. The reset vector will
    ; be set up to long-jump to this address.

    lda #$f0                ; set ptr1 = $0ff0
    sta ptr1
    lda #$0f
    sta ptr1+1

    lda #0
    tay

    lda #$ea                ; store jmp instruction
    sta (ptr1),Y
    iny
    lda #0                  ; store offset (0x0000)
    sta (ptr1),Y
    iny
    sta (ptr1),Y
    iny
    sta (ptr1),Y            ; store segment (0x1000)
    iny
    lda #$10
    sta (ptr1),Y

    jsr emprint
    .asciiz "\rSWITCH TO 8088\r"

    ldy #0
    sta (CARD_IO_BASE),Y

    jsr emprint
    .asciiz "ERROR: SWITCH TO 8088 DID NOT HAPPEN\r"

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


; vim:set ts=4 sw=4 expandtab:
