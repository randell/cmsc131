; Joseph Randell L. Benavidez
; 2001-49967
; chai356@yahoo.com
; CMSC 131 W-3L
; This program asks the user to enter a single digit number.  If the input is
; not a digit, the program must terminate at once.  If digit, the program
; would output: "less than 5 :-)" if the digit is less than 5, else (if
; greater than or equal to 5), the output would be: "The digit __ minus 5 =
; __".  The first blank must be the digit; The second blank must be the
; difference (digit - 5).

.MODEL small
.STACK 0
.DATA
 msg1 db 0ah, 0dh, "Please enter a single digit number: $"
 msg2 db 0ah, 0dh, "less than 5 :-)$"
 msg3 db 0ah, 0dh, "The digit $"
 msg4 db " minus 5 = $"
.CODE
 mov ax,@DATA
 mov ds,ax

 mov dx, offset msg1    ; shows the first message
 mov ah,9
 int 21h

 mov ah,1               ; accepts the input from the user
 int 21h

 sub al,30h              ; al:=al-30
 mov cl,al

 cmp al,0h               ; checks if it is a digit
 jge digitsya1
 jmp fin

 digitsya1:             ; checks if it is a digit
 cmp al,9h
 jle digitsya2
 jmp fin

 digitsya2:             ; checks whether the input is below 5 or
 cmp al,5h               ; greater than or equal to 5
 jl belowfive
 jge abovefive

 belowfive:             ; if the number is less than five
 mov dx, offset msg2
 mov ah,9
 int 21h
 jmp fin

 abovefive:             ; if the number is greater than five
 mov dx, offset msg3    ; shows "The digit "
 mov ah,9
 int 21h
 
 add cl,30h

 mov ah,2               ; shows the number
 mov dl,al
 int 21h

 mov dx, offset msg4    ; shows "minus 5 = "
 mov ah,9
 int 21h

 sub cl,5

 mov ah,2               ; shows the number minus 5
 mov dl,cl
 int 21h

 fin:
 mov ah, 4ch
 int 21h
END
