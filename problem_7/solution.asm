global _start
section .bss
res resb 21
section .text
_start:
    mov r8, 2                  ; starting prime is 2
    mov rcx, 0                 ; prime counter

.count:
    mov rdi, r8                ; mov candidate prime to rdi for function call
    call is_prime              ; call the is_prime function
    inc r8                     ; increase my prime
    cmp rax, 1                 ; check if the number is prime from the result returned by is_prime
    jne .check                 ; if not prime I go down to check bounds
    inc rcx                    ; otherwise it is a prime so increment my counter and check bounds

.check:
    cmp rcx, 10001             ; check if we reached bound
    jl .count                  ; if not loop again

    dec r8                     ; dec r8 because we always increment it so it will be off by one
    mov rax, r8                ; mov result from r8 to rax for conversion

    lea rsi, [total + 20]      ; point rsi to end of buffer - 1, because we add newline next
    mov byte [rsi], 10         ; add newline
    mov r9, 10                 ; put divisor in register to use for conversion

.convert:
    xor rdx, rdx               ; zero out remainder 
    div r9                     ; divide by 10
    add rdx, '0'               ; convert to ASCII
    dec rsi                    ; move back rsi
    mov [rsi], dl              ; mov digit to rsi
    test rax, rax              ; check if we reached zero
    jnz .convert               ; if not loop back

    lea rdx, [total + 21]      ; point rdx to end of buffer
    sub rdx, rsi               ; point rdx to the start of result
    mov rax, 1                 ; say we want to write
    mov rdi, 1                 ; say we want stdout
    syscall

    mov rax, 60                ; exit
    xor rdi, rdi               ; exit code 0
    syscall


is_prime:
    mov r9, 2                  ; start divisor from 2

.loop:
    mov rax, r9                ; mov divisor to rax
    imul rax, rax              ; multiply it by itself to check sqrt bound
    cmp rax, rdi               ; check if we reached the sqrt bound to original prime candidate
    ja .return_true            ; if we did it is a prime because we did not exit early

    mov rax, rdi               ; mov prime candidate to rax
    xor rdx, rdx               ; zero out rdx
    div r9                     ; divide by current divisor
    inc r9                     ; increment divisor
    test rdx, rdx              ; check remainder, divisible or not
    jnz .loop                  ; if not divisible loop back

.return_false:
    mov rax, 0                 ; mov 0 as in False to rax to use in original code
    ret                        ; stop the function

.return_true:
    mov rax, 1                 ; mov 1 as in True to rax to use in original code
    ret                        ; stop the function
    