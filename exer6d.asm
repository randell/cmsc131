; Joseph Randell L. Benavidez
; 2001-49967
; CMSC 131 W-3L
; September 2, 2003

; This program is a modified version of exer5d.asm, but now uses a procedure.

; This program asks an input from the user and the output
;   is an n x n multiplication table where n is the user input.

extrn writenum: near
public num

.model small
.stack 0
.data
  ask_input db 0ah, 0dh, "Please enter a number [1..9]: $"
  error_msg db 0ah, 0dh, "**Error**: You can onlye enter numbers 0 to 10: $"
  nlcr      db 0ah, 0dh, "$"  
  num       dw 0
  cnt       dw ?

.code
main proc near
  mov ax, @data
  mov ds, ax

  mov dx, offset ask_input  ; asks input from the user
  mov ah, 9
  int 21h

  mov ah, 1                 ; gets the input from the user
  int 21h

  cmp al, 30h               ; checks if the input is valid
  jl wrong_input

  cmp al, 39h               ; checks if the input is valid
  jg wrong_input

  push ax                   ; adds a new line and returns the carriage
  mov dx, offset nlcr
  mov ah, 9
  int 21h
  pop ax

  sub al, 30h               ; manipulates the input for succeeding opeartions
  mov ah, 0
  mov num, ax

  mov bx, num               ; reinitializes registers to be used
  mov cnt, bx
  mov ch, 0
  mov cl, 1
  mov bh, 0
  mov bl, 1

  loop2:                    ; serves as the row multiplier
    cmp bx, cnt
    jg exit

    loop1:                  ; increments the columns
      mov ax, cx
      mul bx

      push ax
      call printNum

      mov dl, 9h            ; adds a horizontal tab
      mov ah, 2
      int 21h

      inc cx
      cmp cx, cnt
      jle loop1

    mov cx, 1
    mov dx, offset nlcr     ; adds a new line and returns the carriage
    mov ah, 9
    int 21h

    inc bx
    jmp loop2

  wrong_input:              ; prints an error message if input is invalid
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
