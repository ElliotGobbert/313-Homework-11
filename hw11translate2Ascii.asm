section .data
    inputBuf db 0x83, 0x6A, 0x88, 0xDE, 0x9A, 0xC3, 0x54, 0x9A
    inputLen equ $ - inputBuf  ; Number of bytes in inputBuf

section .bss
    outputBuf resb 80          ; Output buffer with enough space

section .text
    global _start

_start:
    mov esi, inputBuf         ; Source pointer to input buffer
    mov edi, outputBuf        ; Destination pointer to output buffer
    mov ecx, inputLen         ; Number of bytes to process

convert_loop:
    lodsb                     ; Load byte from [ESI] into AL, advance ESI
    ; Call subroutine to convert AL to 2 hex ASCII characters
    call byte_to_hex

    ; Store high and low ASCII characters in output buffer
    mov [edi], ah             ; High nibble ASCII goes to output
    inc edi
    mov [edi], al             ; Low nibble ASCII goes next
    inc edi

    ; Add space separator after each byte
    mov byte [edi], ' '
    inc edi
    loop convert_loop         ; Repeat for all bytes

    dec edi                   ; Remove the trailing space
    mov byte [edi], 0x0A      ; Replace it with a newline
    inc edi

    ; Calculate length and print buffer
    mov eax, 4                ; syscall: sys_write
    mov ebx, 1                ; stdout
    mov ecx, outputBuf        ; Pointer to output
    sub edi, outputBuf        ; Length of string = edi - outputBuf
    mov edx, edi              ; Move length to EDX
    int 0x80                  ; Make syscall

    ; Exit the program
    mov eax, 1                ; syscall: sys_exit
    xor ebx, ebx              ; Exit code 0
    int 0x80

; ------------------------------
; Subroutine: byte_to_hex
; Converts a byte in AL to two ASCII hex characters.
; Output:
;   AH = high nibble ASCII ('0'-'9','A'-'F')
;   AL = low nibble ASCII
; ------------------------------
byte_to_hex:
    push ecx                  ; Save registers
    mov cl, al                ; Store original byte in CL

    shr al, 4                 ; Shift high nibble into AL
    call nibble_to_ascii      ; Convert high nibble
    mov ah, al                ; Save high nibble result in AH

    mov al, cl                ; Restore original byte
    and al, 0x0F              ; Mask to get low nibble
    call nibble_to_ascii      ; Convert low nibble
    pop ecx
    ret

; ------------------------------
; Subroutine: nibble_to_ascii
; Converts a 4-bit nibble (in AL) to its ASCII character.
; ------------------------------
nibble_to_ascii:
    cmp al, 9
    jbe .digit                ; If <= 9, it's a digit
    add al, 'A' - 10          ; Convert to 'A'–'F'
    ret
.digit:
    add al, '0'               ; Convert to '0'–'9'
    ret