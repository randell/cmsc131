; Joseph Randell L. Benavidez
; 2001-49967
; CMSC 131 W-3L
; lets the user enter 2-digit numbers then outputs the absolute difference

.MODEL small
.STACK 0
.DATA
	msg1  db 0ah, 0dh, "Please enter a two-digit number: $"
   	msg2  db 0ah, 0dh, "Please enter another 2-digit number: $"
   	msg3  db 0ah, 0dh, "The difference is : $"
   	char1 db ?
   	char2 db ?
	char3 db ? 
.CODE
   	mov  ax, @DATA
   	mov  ds, ax
		; ds points to the start of the data segment

   	lea dx, msg1	; shows msg1
   	mov ah, 9
   	int 21h

   	mov ah, 1	; gets the first digit of the first number
	int 21h		
   	mov char1, al	
   	mov dl, 10	
   	sub char1, 30h
   	mov al, char1	
   	mul dl
   	mov char1, al

   	mov ah, 1	; gets the second digit of the first number
   	int 21h
   	mov char2, al
   	sub char2, 30h
   	mov al, char2

   	add char1, al	; stores the number in char1

   	lea dx, msg2	; shows msg2
   	mov ah, 9
   	int 21h

   	mov ah, 1	; gets the first digit of the second number
   	int 21h
   	mov char2, al
   	mov al, 10
   	sub char2, 30h
   	mul char2
   	mov char2, al

   	mov ah, 1	; gets the sedcond digit of the second number
   	int 21h
   	mov char3, al
   	sub char3, 30h
	mov al, char3

   	add al, char2	; stores the second number in al

   	cmp char1, al	; compares the 2 numbers
   	jl lesser	; jumps to 'lesser' if value in char1 is less than the value in al

	sub char1, al	; if the number in char1 is greater than that in al, chat - al
	jmp finish	

   	lesser:		; al - char1
   	sub al, char1
   	mov char1, al
   	jmp finish

   	finish:		
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

   	mov dl, char1	; outputs the number
   	mov ah, 2
   	int 21h     
   	mov dl, char2
   	mov ah, 2            
   	int 21h  
	
   	mov ah, 4ch	; terminate the exe file
   	int 21h     	
END
