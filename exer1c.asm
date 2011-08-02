; Joseph Randell L. Benavidez
; 2001-49967
; CMSC 131 W-3L
; This programs gets three keys as input but does not display the keyboard characters
; that are being pressed until the last three characters has been typed-in

.MODEL small
.STACK 0
.DATA
        msg db 0ah, 0dh, "Please press three keys on the keyboard: $"
	char1 db ?	
	char2 db ?
		; char1, char2, char3 will be used to store the characters pressed
.CODE
	mov ax, @DATA
	mov ds, ax
                ; ds points to the start of the data segment

        mov dx, offset msg      ; displays msg
	mov ah, 9
	int 21h
	
        mov ah, 7       ; reads char without echo
	int 21h

        mov dl, al      ; reads 3 characters pressed
        int 21h
	mov char1, al
	int 21h
	mov char2, al

	mov ah, 2
        int 21h
	mov dl, char1
	int 21h
	mov dl, char2
	int 21h

	mov ah, 4ch
	int 21h
END	
