section .data
    newLine db 10
    input db "Input the size of array [1, 100]: ", 0
    err db "Wrong input", 0
    input_val_err db "The value must be greater or equal than last one", 0
    input_val db "Input value: ", 0
    max_size dq 100
    printf_format db "The number is: %d", 10, 0
    arr_format db "arr[%d] = %d", 10, 0
    scanf_format db "%d", 0
    input_target db "Input the target: ", 0
    target_found db "The target found: arr[%d] = %d", 10, 0
    target_not_found db "There is no target", 10, 0


section .bss
    size resq 1
    arr resq 100
    target resq 1

%macro PRINT_STRING 2
    mov rax, 1 ; sys_write
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

%macro NEWLINE 0
    mov rax, 1
    mov rdi, 1
    mov rsi, newLine
    mov rdx, 1
    syscall
%endmacro

%macro GET_INPUT 2
    xor rax, rax ; sys_read
    xor rdi, rdi
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

%macro PRINT_NUM 1
    push rbp
    mov rbp, rsp
    sub rsp, 16

    xor rax, rax
    mov rdi, printf_format
    mov rsi, %1
    call printf

    leave
    ; mov rsp, rbp
    ; pop rbp 
%endmacro

%macro GET_DIGIT 2
    push rbp
    mov rbp, rsp
    sub rsp, 16
    xor rax, rax
    mov rdi, %1
    lea rsi, qword[%2]
    call my_scanf

    leave
%endmacro

%macro PRINT_ARR 3 ; %3 is label name
    xor rbx, rbx
    push rbp
    mov rbp, rsp
    sub rsp, 16
%3:
    xor rax, rax
    mov rdi, arr_format
    mov rsi, rbx
    mov rdx, qword[%1 + rbx * 8]
    call printf
    inc rbx
    cmp rbx, [%2]
    jne %3
    leave
%endmacro

section .text
    extern printf
    extern my_scanf
    global main
; --------------------------------- main --------------------------

main:
    GET_DIGIT input, size
    mov rax, [size]
    cmp rax, [max_size]
    jg l_err
    cmp rax, 0
    jle l_err

    call f_get_arr
    call f_get_target
    call f_binary_search

    jmp l_end

l_err:
    PRINT_STRING err, 11
    NEWLINE
    jmp main
l_end:
    call f_exit

; -------------------------------- helpers --------------------------

f_get_target:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    GET_DIGIT input_target, target
    leave
    ret

f_exit:
    mov rax, 60 ; sys_exit
    xor rdi, rdi
    syscall

f_get_arr:
    xor rbx, rbx
    push rbp
    mov rbp, rsp
    sub rsp, 16
l_loop_start:
    
    GET_DIGIT input_val, arr + rbx * 8

    cmp rbx, 1 ; check if index > 1
    jl l_loop_inc
    
    mov r10, [arr + rbx * 8] ; getting arr[i]
    mov r11, [arr + (rbx - 1) * 8]

    cmp r10, r11 ; check if arr[i] > arr[i - 1]
    jge l_loop_inc
    PRINT_STRING input_val_err, 48
    NEWLINE
    jmp l_loop_start
l_loop_inc:
	inc rbx
	cmp rbx, [size]
	jne l_loop_start
    leave
    ret

f_binary_search:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    mov r9, 0 ; left = 0
    mov r10, [size] ; right = size - 1
    sub r10, 1
    xor rdx, rdx
    mov rbx, 2 ; for division
    mov r11, [target] ; getting the target
l_search:
    cmp r9, r10 ; while (left <= right)
    jg l_not_found
    mov rax, r9 ; mid = (left + right) / 2
    add rax, r10
    div rbx ; rax is mid

    cmp r11, qword[arr + rax * 8]
    je l_found
    jg l_upper_part
    jl l_lower_part
l_upper_part: ; low = mid + 1
    mov r9, rax
    add r9, 1
    jmp l_search
l_lower_part: ; right = mid - 1
    mov r10, rax
    sub r10, 1
    jmp l_search
l_found:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    mov rdi, target_found
    mov rsi, rax
    mov rdx, qword[arr + rax * 8]
    xor rax, rax
    call printf
    leave
    jmp l_search_end
l_not_found:
    PRINT_STRING target_not_found, 19
l_search_end:
    leave
    ret