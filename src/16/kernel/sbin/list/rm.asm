; hexos/src/16/kernel/core/sbin/list/rm.asm

rm_cmd db "rm", 0

do_rm:
    pusha
    mov si, input_buffer
    add si, 3

    cmp byte [si], 0
    je .missing_arg
    
    call delete_file
    jc .success
    
    mov si, .error_msg
    call print_string
    jmp .done
    
.success:
    jmp .done
    
.missing_arg:
    mov si, .usage_msg
    call print_string
    
.done:
    popa
    ret
    
.usage_msg db "Usage: rm <filename>", 0x0D, 0x0A, 0
.error_msg db "Error: Could not delete file", 0x0D, 0x0A, 0
