; boot/pm.asm
; Passe en mode protégé et saute dans notre kernel 32-bit
[org 0x7c00]
bits 16

start:
    cli
    xor ax, ax
    mov ds, ax
    mov ss, ax
    mov sp, 0x7c00

    lgdt [gdt_descriptor]

    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp CODE_SEG:init_pm

; ---------------------------
; MODE PROTÉGÉ (32-bit)
; ---------------------------
bits 32
init_pm:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov esi, msg32
.loop:
    lodsb
    cmp al, 0
    je .done
    mov ah, 0x0E
    int 0x10
    jmp .loop
.done:
    hlt
    jmp $

; ---------------------------
; GDT (Global Descriptor Table)
; ---------------------------
gdt_start:
gdt_null: dq 0
gdt_code: dq 0x00CF9A000000FFFF
gdt_data: dq 0x00CF92000000FFFF
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

msg32 db "Mode protégé 32 bits activé sur NagamOS!", 0

times 510 - ($ - $$) db 0
dw 0xAA55
