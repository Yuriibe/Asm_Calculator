; Calculator
;
;By me

global _start ; Need to set a start for assembly
section .bss
    result resb 3  ; Reserve 1 byte for the result
    tmp resb 2;
section .data ;section to store static variables
    welcome db 0dh, 0ah,0dh, 0ah, " =================================== Hello and Welcome to this calculator ===================================", 0dh, 0ah, 0dh, 0ah ; db = for data byte | 0dh, 0ah = end of line and go to next line
    welcome_length equ $-welcome
    choice db "Please make your Choice: ", 0dh, 0ah
    choice_length equ $-choice
    operator db "1. Add", 0dh, 0ah, "2. Subtract", 0dh, 0ah, "3. Multiply", 0dh, 0ah , "4. Divide", 0dh, 0ah, "5. Exit",10
    operator_length equ $-operator
    
    first_number db "Please enter your first number: ", 0dh, 0ah
    first_number_length equ $-first_number

    second_number db "Please enter your second number: ", 0dh, 0ah
    second_number_length equ $-second_number

    answer db "Answer of: "
    answer_length equ $-answer

    plus  db " + "
    plus_length equ $-plus

    minus db " - "
    minus_length equ $-minus

    equals db  " = "
    equals_length equ $-equals

   
    first_temp: db 0,0;
    second_temp: db 0,0;
section .text ; actual code

_start: ; starting point of Assembly

LOOP: ; create a loop to keep using the Calculator
    call welcome_message
    call get_choice
    call operators
    call get_input
    call compare_input

    
welcome_message:
    mov rax, 0x1            ; set sys_call to write 
    mov rdi, 1              ; 1 = stdout | 0 = read, 1 = write and 2 = error
    mov rsi, welcome        ; copies the address of the welcome string into rsi
    mov rdx, welcome_length ; reserve bits for welcome message
    syscall
    ret

compare_input:
    

    cmp byte[rsi], '1'
    je add

    cmp byte[rsi], '2'
    je substract

    cmp byte[rsi], '3'
    je multiply

    cmp byte[rsi], '4'
    ; je divide

    cmp byte[rsi], '5'
    je exit

get_choice:
    mov rax, 0x1
    mov rdi, 1
    mov rsi, choice
    mov rdx, choice_length
    syscall
    ret

operators:
    mov rax, 0x1
    mov rdi, 1
    mov rsi, operator
    mov rdx, operator_length
    syscall
    ret

get_input:
    mov rax, 0           ; syscall: read
    mov rdi, 0           ; stdin
    lea rsi, [tmp]       ; Buffer for input
    mov rdx, 2           ; Read 2 bytes (number + newline)
    syscall
    mov al, byte [tmp]   ; Load the first byte (actual input)
    mov byte [tmp+1], 0  ; Clear newline
    ret


add:
    mov rax, 0x1 ; syscall: write
    mov rdi, 1   ; stdout
    mov rsi, first_number ; Gets address of the "first number" prompt string
    mov rdx, first_number_length ; Reserve bits for length of Number
    syscall ; invoke the write syscall

    mov rax, 0 ; syscall: read
    mov rdi, 0 ; 0 = stdin
    mov rsi, first_temp ; address to store user input
    mov rdx, 2 ; maximum number of bytes to read
    syscall ; invoke the read syscall

    mov r8, first_temp

    mov rax, 0x1
    mov rdi, 1
    mov rsi, second_number
    mov rdx, second_number_length
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, second_temp
    mov rdx, 2
    syscall

    mov r9, second_temp

    push r8 ; push r8 onto the stack
    push r9 ; push r8 onto the stack

    mov r8, [first_temp] ; Load first number into r8
    mov r9, [second_temp] ; Load second number into r9

    sub r8, 48 ; Convert the ASCII value in r8 to its numeric equivalent
    sub r9, 48 ; Convert the ASCII value in r8 to its numeric equivalent

    mov r10, r8 ; Move r8 into r10
    add r10, r9 ; Add r9 to r10 and store the result in r10

    pop r9 ; First remove r9 From the top of the stack
    pop r8 ; after that r8 is now on top of the stack so we can remove from there

    add r10, 48 ; Convert the numeric result back to its ASCII representation
    mov byte [result], r10b

    mov rax, 0x1
    mov rdi, 1
    mov rsi, answer
    mov rdx, answer_length
    syscall

    mov rax, 0x1 ; syscall: write
    mov rdi, 1 ; stdout
    mov rsi, r8
    mov rdx, 1
    syscall

    mov rax, 0x1 
    mov rdi, 1
    mov rsi, plus
    mov rdx, plus_length
    syscall

    mov rax, 0x1 ;syscall: write
    mov rdi, 1 ;stdout
    mov rsi, r9
    mov rdx, 1
    syscall

    mov rax, 0x1 
    mov rdi, 1
    mov rsi, equals
    mov rdx, equals_length
    syscall

    mov rax, 0x1 ;syscall: write
    mov rdi, 1 ;stdout
    lea rsi, [result]   ; Address of the result
    mov rdx, 1
    syscall

    jmp LOOP

substract:
    mov rax, 0x1 ; syscall: write
    mov rdi, 1   ; stdout
    mov rsi, first_number ; Gets address of the "first number" prompt string
    mov rdx, first_number_length ; Reserve bits for length of Number
    syscall ; invoke the write syscall

    mov rax, 0 ; syscall: read
    mov rdi, 0 ; 0 = stdin
    mov rsi, first_temp ; address to store user input
    mov rdx, 2 ; maximum number of bytes to read
    syscall ; invoke the read syscall
    
    mov r8, first_temp

    mov rax, 0x1
    mov rdi, 1
    mov rsi, second_number
    mov rdx, second_number_length
    syscall 

    mov rax, 0
    mov rdi, 0
    mov rsi, second_temp
    mov rdx, 2
    syscall

    mov r9, second_temp

    push r8
    push r9

    mov r8, [first_temp]
    mov r9, [second_temp]

    sub r8, 48 ; Convert the ASCII value in r8 to its numeric equivalent
    sub r9, 48 ; Convert the ASCII value in r to its numeric equivalent

    mov r10, r8 ; Move r8 into r10
    sub r10, r9

    pop r9
    pop r8

    add r10, 48
    mov byte [result], r10b

    mov rax, 0x1
    mov rdi, 1
    mov rsi, answer
    mov rdx, answer_length
    syscall

    mov rax, 0x1
    mov rdi, 1
    mov rsi, r8
    mov rdx, 1
    syscall

    mov rax, 0x1
    mov rdi, 1
    mov rsi, minus
    mov rdx, minus_length
    syscall

    mov rax, 0x1
    mov rdi, 1
    mov rsi, r9
    mov rdx, 1
    syscall

    mov rax, 0x1
    mov rdi, 1
    mov rsi, equals
    mov rdx, equals_length
    syscall

    mov rax, 0x1 ;syscall: write
    mov rdi, 1 ;stdout
    lea rsi, [result]   ; Address of the result
    mov rdx, 1
    syscall

    jmp LOOP



multiply:
    mov rax, 0x1
    mov rdi, 1
    mov rsi, first_number
    mov rdx, first_number_length
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, first_temp
    mov rdx, 2
    syscall

    mov r8, first_temp

    mov rax, 0x1
    mov rdi, 1
    mov rsi, second_number
    mov rdx, second_number_length
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, second_temp
    mov rdx, 2
    syscall

    mov r9, second_temp

    

    push r8
    push r9

    mov r8, [first_temp]
    mov r9, [second_temp]

    sub r8, 48
    sub r9, 48

    mov rax, r8            ; Load first number into RAX
    mul r9                 ; Multiply RAX by R9 (RAX = RAX * R9)

    add rax, 48
    mov [result], rax

    pop r9
    pop r8

    mov rax, 0x1 ; syscall: write
    mov rdi, 1 ; stdout
    lea rsi, [result]   ; Address of the result
    mov rdx, 1
    syscall

    jmp LOOP

exit:
    mov rax, 60             ; Syscall: exit
    xor rdi, rdi            ; Exit code: 0
    syscall                 ; Make the syscall