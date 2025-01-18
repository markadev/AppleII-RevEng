cpu 8086
bits 16
org 0

; A very simple test of the 88Card's onboard memory. It runs directly out of
; the Apple's memory so can freely test all 64K of the card memory.


; Check the RAM by writing the byte value to all 64K bytes and
; reading it back.
;
; Will store a chacter with the result in ds:[bx] and increment bx
;  - normal 'S' on success
;  - flashing 'F' on failure
%macro memcheck 1
    mov al, %1

    ; store the byte value in all 64K of memory
    xor di, di              ; clear DI
    mov cx, 0xffff          ; set count to 65536
    rep stosb

    ; check the byte value in all 64K of memory
    xor di, di              ; clear DI
    mov cx, 0xffff          ; set count to 65536
    repz scasb

    mov [bx], byte 'F'      ; flashing 'F'
    jnz %%done
    mov [bx], byte 0xD3     ; normal 'S'
%%done:
    inc bx
%endmacro


entry:
    cli                     ; disable interrupts
    cld                     ; set to increment SI/DI after loads/stores

    mov ax, cs              ; set DS = CS (both pointing to Apple II memory)
    mov ds, ax
    xor ax, ax              ; set ES to access the card's local RAM
    mov es, ax

main:
    ; Write the start message to the screen
    mov si, start_message
    mov bx, 0xf628          ; BX = address of TEXT1 line 13
start_message_loop:
    lodsb
    cmp al, 0
    jz start_message_loop.done
    or al, 0x80
    mov [bx], al
    inc bx
    jmp start_message_loop
.done:

    mov bx, 0xf6a8          ; BX = address of TEXT1 line 14

    memcheck 0x00
    memcheck 0x01
    memcheck 0x02
    memcheck 0x04
    memcheck 0x08
    memcheck 0x10
    memcheck 0x20
    memcheck 0x40
    memcheck 0x80
    memcheck 0xff

    inc bx
    mov [bx], byte 'D'
    inc bx
    mov [bx], byte 'O'
    inc bx
    mov [bx], byte 'N'
    inc bx
    mov [bx], byte 'E'

    hlt


start_message:      db 'SIMPLEMEM 8088', 0


; vim:set ts=4 sw=4 expandtab:
