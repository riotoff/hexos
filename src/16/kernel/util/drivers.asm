; hexos/src/16/kernel/util/drivers.asm

main_loop:
    mov si, prompt
    call print_string
    
    mov di, input_buffer
    mov cx, 64
    xor al, al
    rep stosb
    
    mov di, input_buffer
    call read_line
    call process_command
    jmp main_loop

print_string:
    pusha
    mov ah, 0x0E
    xor bh, bh
.print_loop:
    lodsb
    test al, al
    jz .done

    cmp al, 0x0D
    je .handle_cr
    cmp al, 0x0A
    je .handle_lf

    test bl, bl
    jz .default_print

    pusha
    mov ah, 0x09
    mov bh, 0
    mov cx, 1
    int 0x10
    
    mov ah, 0x03
    int 0x10
    inc dl
    cmp dl, 80
    jb .update_cursor
    xor dl, dl
    inc dh
    cmp dh, 25
    jb .update_cursor
    call scroll_screen
    mov dh, 24
.update_cursor:
    mov ah, 0x02
    int 0x10
    popa
    jmp .print_loop

.default_print:
    int 0x10
    jmp .print_loop

.handle_cr:
    mov ah, 0x03
    int 0x10
    mov dl, 0
    mov ah, 0x02
    int 0x10
    jmp .print_loop

.handle_lf:
    mov ah, 0x03
    int 0x10
    inc dh
    cmp dh, 25
    jb .no_scroll
    call scroll_screen
    mov dh, 24
.no_scroll:
    mov dl, 0
    mov ah, 0x02
    int 0x10
    jmp .print_loop

.done:
    popa
    ret

scroll_screen:
    pusha
    mov ah, 0x06
    mov al, 1
    mov bh, 0x07
    mov ch, 0
    mov cl, 0
    mov dh, 24
    mov dl, 79
    int 0x10
    popa
    ret

read_line:
    pusha
    xor cx, cx
.input_loop:
    mov ah, 0x00
    int 0x16
    
    cmp al, 0x0D
    je .enter_pressed
    cmp al, 0x08
    je .backspace_pressed
    cmp al, 0x7F
    je .backspace_pressed
    
    cmp al, ' '
    jb .input_loop
    cmp al, '~'
    ja .input_loop
    cmp cx, 63
    jae .input_loop
    
    mov [di], al
    inc di
    inc cx
    mov ah, 0x0E
    int 0x10
    jmp .input_loop

.backspace_pressed:
    test cx, cx
    jz .input_loop
    dec di
    dec cx
    mov ah, 0x0E
    mov al, 0x08
    int 0x10
    mov al, ' '
    int 0x10
    mov al, 0x08
    int 0x10
    jmp .input_loop

.enter_pressed:
    mov byte [di], 0
    call new_line
    popa
    ret

new_line:
    push ax
    mov ah, 0x0E
    mov al, 0x0D
    int 0x10
    mov al, 0x0A
    int 0x10
    pop ax
    ret

strcmp:
    pusha
.compare:
    mov al, [si]
    cmp al, [di]
    jne .not_equal
    test al, al
    jz .equal
    inc si
    inc di
    jmp .compare
.not_equal:
    clc
    jmp .exit
.equal:
    stc
.exit:
    popa
    ret
