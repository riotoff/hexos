; hexos/src/16/kernel/core/sbin/list/touch.asm

touch_cmd db "touch", 0

do_touch:
    pusha
    mov si, input_buffer
    add si, 6

    cmp byte [si], 0
    je .missing_arg
    
    call create_file
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
    
.usage_msg db "Usage: touch <filename>", 0x0D, 0x0A, 0
.error_msg db "Error: Could not create file", 0x0D, 0x0A, 0
