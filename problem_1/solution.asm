global _start
section .bss
total resb 21
section .text
_start:
    mov rcx, 1
    xor rbx, rbx

.loop:
    cmp rcx, 1000
    jge .done

    mov rax, rcx
    xor rdx, rdx
    mov r8, 3
    div r8
    test rdx, rdx
    jz .divisible_by_three

    mov rax, rcx
    xor rdx, rdx
    mov r8, 5
    div r8
    test rdx, rdx
    jz .divisible_by_five

    jmp .next

.divisible_by_three:
    add rbx, rcx
    jmp .next

.divisible_by_five:
    add rbx, rcx
    jmp .next

.next:
    inc rcx
    jmp .loop
.done:

    mov rax, rbx

    lea rsi, [total + 20]
    mov byte [rsi], 10
    mov r8, 10

.convert:
    xor rdx, rdx
    div r8
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
