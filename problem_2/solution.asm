global _start
section .bss
total resb 21
section .text
_start:

    mov r8, 1
    mov r9, 2
    xor r11, r11

.while:
    cmp r9, 4000000
    jg .done

    test r9, 1
    jnz .skip

    add r11, r9

.skip:
    mov r10, r8
    add r10, r9
    mov r8, r9
    mov r9, r10
    jmp .while

.done:
    mov rax, r11
    lea rsi, [total + 20]
    mov byte [rsi], 10
    mov r12, 10

.convert:
    xor rdx, rdx
    div r12
    add dl, '0'
    dec rsi
    mov [rsi], dl
    test rax, rax
    jnz .convert

    lea rdx, [total + 21]
    sub rdx, rsi
    mov rax, 1
    mov rdi, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall