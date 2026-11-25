global _start
section .bss
res resb 21
section .text
_start:
    mov rcx, 380               ; dividend
    mov r8, 1                  ; divisor

.inner:
    mov rax, rcx               ; mov dividend into rax for division
    xor rdx, rdx               ; zero out rdx
    div r8                     ; divide by the current divisor
    test rdx, rdx              ; test if it divides with no remainder
    jnz .not_divisible         ; if it divides with no remainder increment

.divisible:
    cmp r8, 20                 ; check if the divisor reached 20
    jge .done                  ; this means we reached the point where the current num in rcx is divisible by 1 through 20
    inc r8                     ; increment the divisor
    jmp .inner                 ; jump back to inner

.not_divisible:
    add rcx, 380               ; increment dividend
    mov r8, 1                  ; reset divisor
    jmp .inner                 ; jump back

.done:
    mov rax, rcx               ; mov into rax to convert
    lea rsi, [res + 20]        ; point rsi to end of buffer - 1, because we add newline next
    mov byte [rsi], 10         ; add newline
    mov r9, 10                 ; put 10 as divisor in register to use for conversion

.convert:
    xor rdx, rdx               ; zero out rdx to use for remainder
    div r9                     ; divide by 10
    add rdx, '0'               ; convert to ASCII
    dec rsi                    ; move back rsi
    mov [rsi], dl              ; put remainder in rsi
    test rax, rax              ; check if nothing remains rax is zero
    jnz .convert               ; if not loop back

    lea rdx, [res + 21]        ; point rdx to end of buffer
    sub rdx, rsi               ; point rdx to the start of result
    mov rax, 1                 ; say we want to write
    mov rdi, 1                 ; say we want stdout
    syscall

    mov rax, 60                ; exit
    xor rdi, rdi               ; exit code 0
    syscall