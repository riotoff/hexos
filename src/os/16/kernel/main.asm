; hexos/src/os/16/kernel/main.asm

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
    call print_string

    mov si, available_cmds
    call print_string

%include "src/os/16/kernel/core/drivers.asm"
%include "src/os/16/kernel/core/handlers.asm"
%include "src/os/16/kernel/core/include_dbc.asm"
%include "src/os/16/kernel/core/fsys.asm"
