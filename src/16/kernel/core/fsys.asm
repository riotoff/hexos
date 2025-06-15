; hexos/src/16/kernel/core/fsys.asm

FILE_TABLE equ 0x5000
FILE_DATA equ 0x6000
MAX_FILES equ 256
FILENAME_LEN equ 12
FILE_ENTRY_SIZE equ 16

init_fs:
    pusha
    mov di, FILE_TABLE
    mov cx, MAX_FILES * FILE_ENTRY_SIZE
    xor al, al
    rep stosb
    popa
    ret

file_exists:
    pusha
    mov di, FILE_TABLE
    mov cx, MAX_FILES
.check_loop:
    push si
    push di
    push cx
    mov cx, FILENAME_LEN
    repe cmpsb
    pop cx
    pop di
    pop si
    je .found
    add di, FILE_ENTRY_SIZE
    loop .check_loop
    clc
    jmp .done
.found:
    stc
.done:
    popa
    ret

find_file:
    pusha
    mov di, FILE_TABLE
    mov cx, MAX_FILES
    xor bx, bx
.search_loop:
    push si
    push di
    push cx
    mov cx, FILENAME_LEN
    repe cmpsb
    pop cx
    pop di
    pop si
    je .found
    inc bx
    add di, FILE_ENTRY_SIZE
    loop .search_loop
    clc
    jmp .done
.found:
    mov [.tmp_index], bx
    stc
.done:
    popa
    mov ax, [.tmp_index]
    ret
.tmp_index dw 0

create_file:
    pusha
    call file_exists
    jc .error
    
    mov di, FILE_TABLE
    mov cx, MAX_FILES
.find_free:
    cmp byte [di], 0
    je .found_free
    add di, FILE_ENTRY_SIZE
    loop .find_free
    jmp .error
    
.found_free:
    push di
    mov cx, FILENAME_LEN
.copy_name:
    lodsb
    test al, al
    jz .name_done
    stosb
    loop .copy_name
.name_done:
    pop di
    
    mov word [di+12], 0
    
    stc
    jmp .done
.error:
    clc
.done:
    popa
    ret

delete_file:
    pusha
    call find_file
    jnc .error
    
    mov bx, FILE_ENTRY_SIZE
    mul bx
    mov di, FILE_TABLE
    add di, ax
    
    xor al, al
    mov cx, FILE_ENTRY_SIZE
    rep stosb
    
    stc
    jmp .done
.error:
    clc
.done:
    popa
    ret

list_files:
    pusha
    mov si, FILE_TABLE
    mov cx, MAX_FILES
.list_loop:
    cmp byte [si], 0
    je .next
    
    push si
    push cx
    mov cx, FILENAME_LEN
.print_name:
    lodsb
    test al, al
    jz .name_printed
    mov ah, 0x0E
    int 0x10
    loop .print_name
.name_printed:
    call new_line
    pop cx
    pop si
    
.next:
    add si, FILE_ENTRY_SIZE
    loop .list_loop
    
    popa
    ret
