; hexos/src/16/kernel/core/sbin/list/hexfetch.asm

hexfetch_cmd db "hexfetch", 0

hexfetch_title db "    #   #     hexfetch", 0x0D, 0x0A, 0
hexfetch_separator db "  ########    --------", 0x0D, 0x0A, 0
hexfetch_host db "   #   #      Host: ?", 0x0D, 0x0A, 0
hexfetch_os db " ########     OS: HexOS 16-bit", 0x0D, 0x0A, 0
hexfetch_cpuu db "  #   #       CPU: ?", 0x0D, 0x0A, 0
hexfetch_memory db "              Memory: ?/? KiB", 0x0D, 0x0A, 0

hexfetch:
    pusha
    mov si, hexfetch_title
    call print_string
    mov si, hexfetch_separator
    call print_string
    mov si, hexfetch_host
    call print_string
    mov si, hexfetch_os
    call print_string
    mov si, hexfetch_cpuu
    call print_string
    mov si, hexfetch_memory
    call print_string
    popa
    ret

; Need to patch due to unknown host, cpu and mem...
