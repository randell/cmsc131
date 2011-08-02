; Joseph Randell L. Benavidez
; 2001-49967
; CMSC 131 W-3L
; lets the user enter 2-digit numbers then outputs the difference

.MODEL small
.STACK 0
.DATA
        msg1 db 0ah, 0dh, "Please enter a two-digit number: $"
        msg2 db 0ah, 0dh, "Please enter another 2-digit number: $"
        msg3 db 0ah, 0dh, "The difference is $"
        char1 db ?
        char2 db ?
        char3 db ?
.CODE
        mov ax, @DATA  
        mov ds, ax
                ; ds points to the start of the data segment

        lea dx, msg1    ; displays msg1
        mov ah, 9
        int 21h

        mov ah, 1       ; read char with echo 
        int 21h         ; execute read char with echo
        mov char1, al   ; char1:=AL
        mov al, 10      ; AL:=10
        sub char1, 30h  ; char1:= char1 - 30h
        mul char1       ; char1 * AL
        mov char1, al   ; char1:= AL
        
        mov ah, 1       ; same here
        int 21h
        mov char2, al
        sub char2, 30h
        mov al, char2
        
        add char1, al

        lea dx, msg2    ; displays msgs
        mov ah, 9
        int 21h

        mov ah, 1       ; same here
        int 21h
        mov char2, al
        mov al, 10
        sub char2, 30h
        mul char2
        mov char2, al

        mov ah, 1       ; same here
        int 21h
        mov char3, al
        sub char3, 30h
        mov al, char3

        add char2, al

        mov al, char2
        sub char1, al

        mov al, char1
        mov ah, 0
        mov dl, 10
        div dl

        add al, 30h
        mov char1, al

        add ah, 30h
        mov char2, ah

        lea dx, msg3
        mov ah, 9
        int 21h

        mov ah, 2      ; displays output
        mov dl, char1
        int 21h

        mov ah, 2
        mov dl, char2
        int 21h

        mov ah, 4ch
        int 21h
END
