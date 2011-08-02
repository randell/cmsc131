; Joseph Randell L. Benavidez
; 2001-49967
; CMSC 131 W-3L
; August 27, 2003

; This program asks an input (a digit) from the user.  It then checks if
;       the input is a digit.  The output is a diamond consisting of the
;       numbers from 1 to the input and back.  The digits appears in
;       between spaces.  This program is implemented using loops.

; cl here is used as a storage for the value to be printed.
; ch here is used to count the number of space needed before printing a
;       digit in a line.

.model small
.stack 0

.data
  ask_input db 0ah, 0dh, "Please enter a 1-digit number: $"
  error_msg db 0ah, 0dh, "**Error**: You can only enter numbers 1 to 9.$"
  space     db " $"             ; used in adding spaces
  nlcr      db 0ah, 0dh, "$"    ; new line and carriage return
  num       db ?                ; variable used for input
  printcnt  db ?                ; counts the printed digit per line

.code
  mov ax, @data
  mov ds, ax

  mov dx, offset ask_input      ; asks for a valid input from the user
  mov ah, 9
  int 21h

  mov ah, 1                     ; gets the input and manipulates it
  int 21h                       ;       for the succeeding operations
  mov num, al
  sub num, 30h

  mov dx, offset nlcr           ; adds a new line and returns the carriage
  mov ah, 9                     ;       before the real output is shown
  int 21h

  cmp num, 1                    ; checks if input is a digit
  jl not_a_digit

  cmp num, 9                    ; checks if input is a digit
  jg not_a_digit

  mov cl, 1                     ; cl:=1;

  up_loop:                      ; prints digits from 1 to num
    cmp cl, num                 
    jg init                     ; proceeds to print the lower triangle if
                                ;       cl > num

    mov printcnt, cl            ; assigns the proper values to be manipulated
    mov ch, num
    sub ch, cl

    print_char:                 ; prints the current value of cl (digit)
      cmp printcnt, 1
      jl next_line              ; goes to print the next line if finished
                                ;       with the current line

      cmp printcnt, cl          ; checks if a space is needed between digits
      je print_space
      jl space_bet

      space_bet:                ; prints a space in between digits
        mov dx, offset space
        mov ah, 9
        int 21h

      print_space:              ; prints spaces before a digit is printed
        cmp ch, 1               ;       in a line
        jl go

        mov dx, offset space    ; prints a space
        mov ah, 9
        int 21h

        dec ch
        jmp print_space

      go:                       ; go means go signal for printing the digits
        mov dl, cl
        add dl, 30h
        mov ah, 2
        int 21h

      dec printcnt
      jmp print_char

    next_line:                  ; goes to the new line and returns the
      mov dx, offset nlcr       ;       carriage for the next digit
      mov ah, 9
      int 21h

      inc cl
      jmp up_loop

  not_a_digit:                  ; connector
    jmp not_a_digit_

  init:                         ; reinitializes the needed values
    mov cl, num
    sub cl, 1

  down_loop:                    ; prints the lower triangle
    cmp cl, 1
    jl finish                   ; proceeds to end the program when finished
                                ;       with the triangle

    mov printcnt, cl            ; assigns the right values for the variables
    mov ch, num                 ; to be used
    sub ch, cl

    print_char_:                ; prints the character to be printed
      cmp printcnt, 1
      jl next_line_

      cmp printcnt, cl          ; checks which space is neccessary
      je print_space_
      jl space_bet_

      space_bet_:               ; prints spaces in between digits in a line
        mov dx, offset space
        mov ah, 9
        int 21h

      print_space_:             ; prints spaces before a digit
        cmp ch, 1
        jl go_

        mov dx, offset space    ; prints a space
        mov ah, 9
        int 21h

        dec ch
        jmp print_space_

      go_:                      ; prints the digit in the line
        mov dl, cl
        add dl, 30h
        mov ah, 2
        int 21h

      dec printcnt
      jmp print_char_

    next_line_:                 ; proceeds to the next line
      mov dx, offset nlcr
      mov ah, 9
      int 21h

      dec cl
      jmp down_loop

  not_a_digit_:                 ; prints the error message if user inputs
    mov dx, offset error_msg    ;       an invalid value
    mov ah, 9
    int 21h

  finish:                       ; terminates the program
    mov ah, 4ch
    int 21h

end
