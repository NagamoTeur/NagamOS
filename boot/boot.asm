; boot/boot.asm - boot sector (512 bytes)
; Assemble: nasm -f bin boot/boot.asm -o build/boot.bin
[org 0x7c00]
bits 16

start:
    cli                 ; désactive interruptions
    xor ax, ax
    mov ds, ax          ; DS = 0x0000
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00      ; stack sûr

    ; Affiche la chaîne via int 0x10 teletype (AH=0x0E)
    mov si, msg         ; SI pointe sur la chaîne (org=0x7c00)
.print_char:
    lodsb               ; AL = [DS:SI] ; SI++
    cmp al, 0
    je .done_print
    mov ah, 0x0E
    int 0x10
    jmp .print_char

.done_print:
    sti                 ; réactive interruptions
.hang:
    hlt
    jmp .hang

; message (terminé par 0)
msg db "Bienvenue sur NagamOS!", 0

; pad jusqu'à 510 octets, puis signature 0xAA55
times 510 - ($ - $$) db 0
dw 0xAA55
