global _start
section .bss
total resb 21
section .text
_start:
    mov rcx, 1                ; start counter at 1
    xor r8, r8                ; zero out storage register

.sum_of_squares:
    mov rax, rcx              ; mov into a new register to square
    imul rax, rax             ; square register
    add r8, rax               ; add to result register

    inc rcx                   ; increment counter
    cmp rcx, 100              ; check if it reached the limit
    jle .sum_of_squares       ; if not loop back

    mov r9, r8                ; store the result of sum of squares to a new register
    mov rcx, 1                ; start counter at 1
    xor r8, r8                ; zero out storage register

.square_of_sums:
    add r8, rcx               ; add counter to result register

    inc rcx                   ; increment counter
    cmp rcx, 100              ; check if it reached the limit
    jle .square_of_sums       ; if not loop back

    imul r8, r8               ; square result (square of sums)
    sub r8, r9                ; subtract sum of squares from square of sums

    mov rax, r8               ; mov to rax for printing
    lea rsi, [total + 20]     ; point rsi to the end of buffer
    mov byte [rsi], 10        ; add new line
    mov r9, 10                ; save divisor for conversion

.convert:
    xor rdx, rdx              ; zero out remainder
    div r9                    ; divide by 10
    add rdx, '0'              ; convert to ASCII
    dec rsi                   ; decrement rsi
    mov [rsi], dl             ; add remainder to rsi
    test rax, rax             ; check if nothing is left
    jnz .convert              ; if not zero continue converting

    lea rdx, [res + 21]       ; point rdx to end of buffer
    sub rdx, rsi              ; length of the result (end - start)

    mov rax, 1                ; saying we want to write
    mov rdi, 1                ; saying we want stdout
    syscall

    mov rax, 60               ; exit
    xor rdi, rdi              ; exit code 0
    syscall