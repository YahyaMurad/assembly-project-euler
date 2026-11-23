global _start
section .bss
total resb 21 
section .text
_start:
    mov r8, 600851475143       ; dividend (n)
    mov rcx, 2                 ; initial divisor (d)

.while:
    mov rax, rcx               ; mov the divisor to rax to use imul or square it
    imul rax, rax              ; square the divisor
    cmp rax, r8                ; compare square of divisor (d * d) by dividend (n) (d * d, n)
    ja .done                   ; jump if above, we reached the limit of sqrt(n)

    mov rax, r8                ; move the dividend into rax to use div
    xor rdx, rdx               ; zero out rdx because div uses rdx:rax as one continuous 128-bit register
    div rcx                    ; div rax by rcx (n / d)
    test rdx, rdx              ; test the remainder
    jnz .finish                ; if it isn't zero means it does not divide so not a factor (n % d != 0)

    mov r8, rax                ; this runs if and only if (n % d == 0), rax stores the result of the division (n / d)
    jmp .while                 ; loop back

.finish:
    inc rcx                    ; divisor is not a factor, so increment it
    jmp .while                 ; loop back

.done:
    mov rax, r8                ; store the final result in rax to convert (final result is the largest prime factor)

    lea rsi, [total + 20]      ; point rsi to end of buffer - 1, because we add newline next
    mov byte [rsi], 10         ; add newline
    mov r9, 10                 ; put divisor in register to use for conversion

.convert:
    xor rdx, rdx               ; zero out rdx because div uses rdx:rax as one continuous 128-bit register
    div r9                     ; divide the result stored in rax by 10
    add rdx, '0'               ; remainder in rdx, convert to ASCII
    dec rsi                    ; move pointer back to empty byte
    mov [rsi], dl              ; mov the remainder in rdx, which is the last digit into rsi
    test rax, rax              ; check if rax still has digits
    jnz .convert               ; if not jump back to convert

    lea rdx, [total + 21]      ; point rdx to end of buffer
    sub rdx, rsi               ; point rdx to the start of result
    mov rax, 1                 ; say we want to write
    mov rdi, 1                 ; say we want stdout
    syscall

    mov rax, 60                ; exit
    xor rdi, rdi               ; exit code 0
    syscall