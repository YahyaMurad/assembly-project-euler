global _start
section .bss
res resb 21
section .text
_start:
    mov r8, 100                 ; starting multiplicant (x = 100)
    xor r10, r10                ; zeroing out storage for number (z = 0)

.outer:
    mov r9, r8                  ; set second multiplicant equal to the first

.inner:
    mov rax, r8                 ; store first multiplicant in rax for multiplication
    mul r9                      ; multiply by second multiplicant (x * y)
    mov r11, rax                ; store product in empty register
    cmp r11, r10                ; check if it is greater, then only check if it is a palindrome
    jle .next_inner             ; if not greater, then skip palindrome check

.palindrome:
    mov rax, r11                ; copy product result stored in r11, into rax
    mov r12, 10                 ; divisor to peel off digits
    xor r13, r13                ; zeroing out r13 to store reverse

.loop:
    xor rdx, rdx                ; zeroing out rdx for division
    div r12                     ; dividing result which was in r11 and now in rax by 10

    imul r13, r12               ; shift digits in r13 by one place, multiplying by 10
    add r13, rdx                ; add remainder digit from rdx

    test rax, rax               ; check original number if it is zero
    jnz .loop                   ; while it isn't zero loop back

    cmp r13, r11                ; check if the reverse of r11 (r13) is equal to r11
    jne .next_inner             ; if not then continue the loop, skipping the next line
    mov r10, r11                ; if it was not skipped overwrite the result, r10

.next_inner:
    inc r9                      ; increment second multiplicant
    cmp r9, 999                 ; check if we went out of bounds
    jle .inner                  ; loop back

.next_outer:
    inc r8                      ; increment first multiplicant
    cmp r8, 999                 ; check if we went out of bounds
    jle .outer                  ; loop back

    mov rax, r10                ; store the final result in rax to convert
    lea rsi, [res + 20]         ; point rsi to end of buffer - 1, because we add newline next
    mov byte [rsi], 10          ; add newline
    mov r12, 10                 ; this is not needed, but added for readability

.convert:
    xor rdx, rdx                ; zero out rdx because div uses rdx:rax as one continuous 128-bit register
    div r12                     ; divide the result stored in rax by 10
    add dl, '0'                 ; remainder in rdx, convert to ASCII
    dec rsi                     ; move pointer back to empty byte
    mov [rsi], dl               ; mov the remainder, which is the last digit, into the buffer
    test rax, rax               ; check if rax still has digits
    jnz .convert                ; if so, jump back to convert

    lea rdx, [res + 21]         ; point rdx to end of buffer
    sub rdx, rsi                ; length of the result (end - start)
    mov rax, 1                  ; say we want to write
    mov rdi, 1                  ; say we want stdout
    syscall

    mov rax, 60                 ; exit
    xor rdi, rdi                ; exit code 0
    syscall