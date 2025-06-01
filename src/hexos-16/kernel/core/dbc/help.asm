; hexos/src/hexos-16/kernel/core/dbc/help.asm

help_cmd db "help", 0

help_msg db "Available commands:", 0x0D, 0x0A, 0
help_clear db "  clear - Clear the screen", 0x0D, 0x0A, 0
help_exit db "  exit  - Shutdown the computer", 0x0D, 0x0A, 0
help_help db "  help  - Show this help message", 0x0D, 0x0A, 0
help_hexfetch db "  hexfetch - Show system info", 0x0D, 0x0A, 0
help_panic db "  panic - Trigger kernel panic (debug)", 0x0D, 0x0A, 0

show_help:
    pusha
    mov si, help_msg
    call print_string
    mov si, help_clear
    call print_string
    mov si, help_exit
    call print_string
    mov si, help_help
    call print_string
    mov si, help_hexfetch
    call print_string
    mov si, help_panic
    call print_string
    mov si, help_ls
    call print_string
    mov si, help_touch
    call print_string
    mov si, help_rm
    call print_string
    popa
    ret
