; Joseph Randell L. Benavidez
; 2001-49967
; CMSC 131 W-3L
; SEptember 2, 2003

; This program is a modification of exer5c.asm, but now, uses a procedure

; This program is an implementation of exer5b.asm.  The program writes a the
;   factorial of any valid input.

extrn writenum: near
public num

.model small
.stack 0

.data
  ask_input db 0ah, 0dh, "Please enter a number [max: 8]: $"
  error_msg db 0ah, 0dh, "**Error**: You can only enter numbers 0 to 8.$"
  talk      db 0ah, 0dh, "The factorial of your input is: $"
  num       dw 0
  nlcr      db 0ah, 0dh, "$"

.code
main proc near
  mov ax, @data
  mov ds, ax

  mov dx, offset ask_input  ; asks an input from the user
  mov ah, 9
  int 21h

  mov ah, 1                 ; reads character with echo
  int 21h

  cmp al, 30h               ; checks if input is valid
  jl wrong_input

  cmp al, 39h               ; checks if input is valid
  jg wrong_input

  sub al, 30h               ; manipuilates input for succeeding operations
  mov ah, 0
  mov num, ax

  mov ch, 0                 ; ireinitializes registers to be used
  mov cl, 0
  mov cx, num
  mov ah, 0
  mov al, 1

  fact:                     ; computes the factorial of the input
    cmp cx, 1h
    jl print_result

    mul cx

    dec cx
    jmp fact

  print_result:             ; prints the result of the computations
    push ax
    mov dx, offset talk
    mov ah, 9
    int 21h
    pop ax

    push ax
    call printNum
    jmp exit

  wrong_input:              ; prints an error message of input is invalid
    mov dx, offset error_msg
    mov ah, 9
    int 21h

  exit:                     ; terminates the program
    mov ah, 4ch
    int 21h
main endp

printNum proc near          ; prints the number
  push bp
  mov bp, sp
  push num
  push ax

  mov ax, [bp+4]
  mov num, ax
  call writenum

  pop ax
  pop num
  pop bp
  ret 2
printNum endp

end
