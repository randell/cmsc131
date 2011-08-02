; Joseph Randell L. Benavidez
; 2001-49967
; CMSC 131 W-3L
; September 2,2003

; This program is a implements exer5b.asm.  This program asks an input from
;   the user and the output is an n x n addition table.

extrn writenum: near
public num

.model small
.stack 0

.data
  ask_input db 0ah, 0dh, "Please enter a number [1..9]: $"
  error_msg db 0ah, 0dh, "**Error**: you can only enter numbers 1 to 9. $"
  nlcr      db 0ah, 0dh, "$"
  num       dw 0
  cnt       dw 0

.code
main proc near
  mov ax, @data
  mov ds, ax

  mov dx, offset ask_input    ; asks an input from the user
  mov ah, 9
  int 21h

  mov ah, 1                   ; gets the input from the user
  int 21h

  cmp al, 30h                 ; checks if the input is valid
  jl wrong_input

  cmp al, 39h                 ; checks if the input is valid
  jg wrong_input

  push ax
  mov dx, offset nlcr         ; prints a new line and returns the carriage
  mov ah, 9
  int 21h
  pop ax

  sub al, 30h                 ; manipulates the input for succeeding operations
  mov ah, 0
  mov num, ax


  mov bx, num                 ; reinitializes registers to be used
  mov cnt, bx
  mov ch, 0
  mov cl, 0
  mov bl, 0
  mov ah, 0
  mov al, 0

  loop2:                      ; increments first column values
    cmp bx, cnt
    jg exit

    mov ax, bx

    loop1:                    ; increments row values by 1
      push ax
      call printNum

      push ax

      mov dl, 09h             ; prints a horizontal tab
      mov ah, 2
      int 21h
      pop ax

      inc ax
      inc cl
      cmp cx, cnt
      jle loop1

      mov cx, 0

    mov dx, offset nlcr       ; prints a new line and returns the carriage
    mov ah, 9
    int 21h

    inc bx
    jmp loop2

  wrong_input:                ; prints an error message for an invalid input
    mov dx, offset error_msg
    mov ah, 9
    int 21h

  exit:                       ; terminates the program
    mov ah, 4ch
    int 21h
main endp

printNum proc near
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
