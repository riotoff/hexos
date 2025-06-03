; hexos/src/os/16/kernel/core/handlers.asm

process_command:
    pusha
    mov si, input_buffer
    
.skip_spaces:
    lodsb
    cmp al, ' '
    je .skip_spaces
    dec si
    
    cmp byte [si], 0
    je .done
    
    mov di, command_buffer
.copy_command:
    lodsb
    cmp al, ' '
    je .command_copied
    cmp al, 0
    je .command_copied
    mov [di], al
    inc di
    jmp .copy_command
.command_copied:
    mov byte [di], 0
    
    mov si, command_buffer
    
    mov di, clear_cmd
    call strcmp
    jc .do_clear
    
    mov di, exit_cmd
    call strcmp
    jc .do_exit
    
    mov di, help_cmd
    call strcmp
    jc .do_help
    
    mov di, hexfetch_cmd
    call strcmp
    jc .do_hexfetch
    
    mov di, panic_cmd
    call strcmp
    jc .do_panic

    mov di, touch_cmd
    call strcmp
    jc .do_touch
    
    mov di, ls_cmd
    call strcmp
    jc .do_ls
    
    mov di, rm_cmd
    call strcmp
    jc .do_rm

    mov si, unknown_cmd
    call print_string
    mov si, available_cmds2
    call print_string
    jmp .done
    
.do_clear:
    call clear_screen
    jmp .done
.do_exit:
    call do_exit
    jmp .done
.do_help:
    call show_help
    jmp .done
.do_hexfetch:
    call hexfetch
    jmp .done
.do_panic:
    call kernel_panic
.do_touch:
    call do_touch
    jmp .done
.do_ls:
    call do_ls
    jmp .done
.do_rm:
    call do_rm
    jmp .done
.done:
    popa
    ret

welcome_msg db "HexOS 16-bit", 0x0D, 0x0A, 0
available_cmds db "Type 'help' for available commands", 0x0D, 0x0A, 0x0A, 0
available_cmds2 db "Type 'help' for available commands", 0x0D, 0x0A, 0
prompt db "# ", 0
unknown_cmd db "Unknown command...", 0x0D, 0x0A, 0
input_buffer times 64 db 0
command_buffer times 16 db 0
