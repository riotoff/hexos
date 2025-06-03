; hexos/src/hexos/16/kernel/core/dbc/ls.asm

ls_cmd db "ls", 0

do_ls:
    pusha
    call list_files
    popa
    ret
