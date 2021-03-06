; Joseph Randell L. Benavidez
; 2001-49967
; CMSC 131 W-3L
; September 2, 2003

; This program is a modified version of exer5b.asm.  This time, the factorial
;   of any input number is computed.  Due to the limitation of the
;   acceptable values of num, the results would only be accurate for up
;   to the factorial of 8.

extrn writenum: near
public num

; cl here is used as a counter to check if there are already five digits.

.model small
.stack 0

.data
  ask_input db 0ah, 0dh, "Please enter a number [0..65535]: $"
  talk      db 0ah, 0dh, "The number you just entered is  : $"
  talk2     db 0ah, 0dh, "The factorial of this number is : $"
  num       dw 0      ; variable used to store the unputted number
  flag      db 0      ; variable used to make sure that the inputted number
                      ;   does not exceed 65535
  nlcr      db 0ah, 0dh, "$"

.code
  mov ax, @data
  mov ds, ax

  mov dx, offset ask_input  ; asks user to input a number with a 
  mov ah, 9                 ;   maximum of five digits
  int 21h

  mov cl, 0                 ; initializes the digit counter to zero
  
  get_input:                ; get input from the user
    cmp cl, 5               ; checks if the number has already 5 digits
    je print_num

    mov ah, 7               ; reads character without echo
    int 21h
  
    cmp al, 0dh             ; checks if the user pressed the enter key
    je print_num
    cmp al, 30h             ; checks if the user input is a digit
    jl get_input
    cmp al, 39h             ; checks if the user input is a digit
    jg get_input

    check_num:              ; makes sure that the user does not exceed
      cmp flag, 2           
      je proceed            ; proceeds if the first digit is less than 6
      cmp flag, 1
      je proceed            ; proceeds with 1 less digit from the number
      
      cmp cl, 0             ; checks the digit for every pressed digit
      je check1             ; if inputted digit exceeds the allowed
      cmp cl, 1             ;   value, the number of digits allowed is 
      je check2             ;   decreased by one.
      cmp cl, 2
      je check3
      cmp cl, 3
      je check4
      cmp cl, 4
      je check5
      jmp proceed

      check1:               ; checks the first digit if it exceeds 6
        cmp al, 36h
        jl flag_2
        je proceed
        jg flag_1

      check2:               ; checks the second digit if it exceeds 5
        cmp al, 35h
        jle proceed
        jg flag_1

      check3:               ; checks the third digit if it exceeds 5
        cmp al, 35h
        jle proceed
        jg flag_1

      check4:               ; checks the fourth digit if it exceeds 3
        cmp al, 33h
        jle proceed
        jg flag_1

      check5:               ; checks the last digit if it exceeds 5
        cmp al, 35h
        jle proceed
        jg get_input

    flag_1:                 ; decreases the number of allowed digits
      mov flag, 1
      inc cl
      jmp proceed

    flag_2:                 ; determines if the user my freely input any
      mov flag, 2           ;   value (numbers only) from the keyboard
      jmp proceed

    print_num:              ; connector
      jmp print_num_

    proceed:
      mov dl, al            ; prints out the last digit pressed
      mov ah, 2
      int 21h
	
      mov bh, 0             ; initializes the registers to be used
      mov ah, 0
      sub al, 30h           ; al := al - 30h;
      mov bl, al            ; bl := al;
      mov al, 10            ; al := 10;

      add num, bx           ; num := num + bx;
      mul num               ; ax := ax * num;

      mov num, ax           ; num := ax;
    
      inc cl                ; increments the digit counter
      jmp get_input

  print_num_:               ; prints the number inputted by the user
                            ; used for checking purposes
    push dx

    mov dx, offset talk     ; tells the user the number he entered
    mov ah, 9
    int 21h

    pop dx

    mov ax, num             ; prints the number using the kit
    mov num, 10
    div num
    mov num, ax
    call writenum

    mov ch, 0               ; reinitializes the values to be used
    mov cl, 0
    mov cx, num
    mov ah, 0
    mov al, 1

    fact:                   ; loop that computes the factorial
      cmp cx, 1h
      je print_result

      mul cx
    
      dec cx
      jmp fact

    print_result:           ; prints the result of the computations
      push dx
      push ax
      mov dx, offset talk2
      mov ah, 9
      int 21h
      pop ax
      pop dx
      
      mov num, ax
      call writenum

    mov dx, offset nlcr     ; adds a new line and returns the carriage
    mov ah, 9
    int 21h

  exit:                     ; terminates the program
    mov ah, 4ch
    int 21h

end
