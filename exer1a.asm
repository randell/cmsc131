; Joseph Randell L. Benavidez
; 2001-49967
; CMSC 131 W-3L
; lets the user enter a 2-digit number then outputs the ASCII character
; corresponding to the value.

.MODEL small
.STACK 0
.DATA
        msg db 0ah, 0dh, "Please enter a two-digit number: $"
        msg2 db 0ah, 0dh, "Its corresponding ASCII character is $"
        char1 db ?
        char2 db ?
                ; char1 & char2 will be used to stored characters pressed
.CODE
        mov ax, @DATA  
        mov ds, ax     
                ; ds points to the start of the segment

        mov dx, offset msg      ; dx:= address of the variable msg
                                ; in the data segment
        mov ah, 9       ; ah:= the int 21h service routine
        int 21h         ; display msg into screen

        mov ah, 1       ; read char with echo
        int 21h         ; execute read char with echo
                        ; and store ASCII code in AL
        mov char1, al   ; char1:=AL (the ASCII code of the key pressed)
        mov al, 10      ; AL:=10
        sub char1, 30h  ; char1:= char1 - 30h
        mul char1       ; char1 * AL
        mov char1, al   ; char:= AL
        
        mov ah, 1       ; same goes here
        int 21h         
        mov char2, al
        sub char2, 30h
        mov al, char2
        
        add char1, al

        lea dx, msg2    ; display msg2
        mov ah, 9
        int 21h

        mov ah, 2       ; displays output
        mov dl, char1
        int 21h

        mov ah, 4ch
        int 21h
END
