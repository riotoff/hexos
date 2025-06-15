; hexos/src/16/kernel/main.asm

[BITS 16]
[ORG 0x0000]

start:
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0xFFFE

    call clear_screen
    mov si, welcome_msg
    mov bl, 0x02
    call print_string

    mov si, available_cmds
    call print_string

    xor bl, bl

%include "src/16/kernel/util/drivers.asm"
%include "src/16/kernel/util/handlers.asm"
%include "src/16/kernel/sbin/include.asm"
%include "src/16/kernel/util/fsys.asm"
