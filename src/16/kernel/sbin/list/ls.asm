; hexos/src/16/kernel/sbin/list/ls.asm

ls_cmd db "ls", 0

do_ls:
    pusha
    call list_files
    popa
    ret
