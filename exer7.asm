;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                       ;;
;; prog4.asm | author: mmmbm | date: 9-18-03                             ;;
;;                                                                       ;;
;; modified by: Joseph Randell L. Benavidez                              ;;
;; 2001-49967                                                            ;;
;; CMSC 131 W-3L                                                         ;;
;; October 10, 2003                                                      ;;
;; chai356@yahoo.com                                                     ;;
;;                                                                       ;;
;; This program demonstrates assembly implementation of arrays, records, ;;
;;   and sets.                                                           ;;
;;                                                                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; import subroutines from kit.obj
extrn  readnum:near
extrn  writenum:near

public num

.286
.model small 
.stack 0

.data
 num         dw 0
 numb        db 0

 msgMenu     db 10, 13
             db 10, 13, '-----menu------'
             db 10, 13, '[A] enter  data'
             db 10, 13, '[B] view   data'
             db 10, 13, '[C] delete record(s)'
             db 10, 13, '[D] edit record(s)'
             db 10, 13, '[E] quit'
             db 10, 13
             db 10, 13, 'Enter your choice: $'

 msgColors   db 10, 13
             db 10, 13, 'Enter favorite colors w/ format:'
             db 10, 13, ' colorNumber[,colorNumber]<ENTER>'
             db 10, 13, 'ex: 1,2,5<press ENTER>'
             db 10, 13, ' Note: You may enter a color '
             db 10, 13, ' number more than once, in case'
             db 10, 13, ' you really love that particular'
             db 10, 13, ' color.. =P', 10,13
             db 10, 13, '[1] BLUE'
             db 10, 13, '[2] RED'
             db 10, 13, '[3] GREEN'
             db 10, 13, '[4] YELLOW'
             db 10, 13, '[5] PURPLE', 10,13
             db 10, 13, 'OK? Now enter colorNumber(s): $'
                        
 msgDisplay  db 10, 13,'Favorite colors: $'

 BLUE        equ 00000001b
 RED         equ 00000010b
 GREEN       equ 00000100b
 YELLOW      equ 00001000b
 PURPLE      equ 00010000b

 strBlue     db 10, 13, '*blue$'
 strRed      db 10, 13, '*red$'
 strGreen    db 10, 13, '*green$'
 strYellow   db 10, 13, '*yellow$'
 strPurple   db 10, 13, '*purple$'
 noColors    db 'No color in the set$', 10, 13
 colorsInput db 11 dup(?)

 theRecords  db 10, 13, 10, 13, 'Data in record:$'
 strFull     db 10, 13, 'No more storage space$'
 noRecord    db 10, 13, 'No record to display$'
 msgPressKey db 10, 13, 'Press any key to continue...$'
 newline     db 10, 13, '$'
 msgName     db 10, 13, 'Enter name: $'
 msgYearBrth db 10, 13, 'Year of birth: $'
 askDel      db 10, 13, 'Delete this record? Press Y if' 
             db 10, 13, ' YES, any other key if No. $'
 askEdt      db 10, 13, 'Edit this record? [Y/N] : $'
 delResult   db 10, 13, 'Data deleted successfully! =P $'
 edtResult   db 10, 13, 'Data edited successfully! =P $'
 line        db 10, 13, '--------------------------$'
 msgNoSuch   db 10, 13, 'No such age!$'

 yearOfBirth equ 21
 faveColors  equ 23
 recSize     equ 24
 arSize      equ 10
 arRecs      db  arSize*recSize dup(?)

.CODE
;;;;; prints a string passed to the parameter "string"
printStr macro string
  push dx             

  lea  dx, string      
  mov  ah, 9
  int  21h

  pop  dx
endm
;;;;;;;;;;;;;;;;;;;;

;;;;; gets a character w/o echo
getChNoEcho macro
  mov ah, 7
  int 21h
endm
;;;;;;;;;;;;;;;;;;;;

;;;;; initializes the array of records
initializeArray proc near
  mov cx, arSize            ; cx := arSize; arSize = 10

  initialize:
    mov  bx, cx              ; bx := cx;
    dec  bx                  ; bx--;
    mov  ax, recSize         ; ax := recSize; recSize = 24
    mul  bl                  ; al := al * bl;
    mov  bx, ax              ; bx := ax;
    mov  arRecs[bx], '$'     ; arSize[10..1] * recSize[24] = '$'
    loop initialize         ; if cx <> 0 jmp initialize + c--;

  ret
initializeArray endp
;;;;;;;;;;;;;;;;;;;;

;;;;; gets user's choice from the menu
getChoice proc near
  mov ah, 7

  getCh:
    int 21h
    and al, 11011111b ; toUpper(al);

    cmp al, 'A'       ; checks if the input is valid
    jl  getCh
    cmp al, 'E'
    jle choiceOK
    jmp getCh

  choiceOK:           ; valid choice is printed
    mov dl, al
    mov ah, 2
    int 21h
    ret
getChoice endp
;;;;;;;;;;;;;;;;;;;;

;;;;; gets data from the user
getDataInput proc near
  printStr  newLine ; prints a new line and returns the
                    ;   carriage to the left

  call  findVacant  ; searches for the next vacant record

  mov   bx, ax          ; bx := arRecs[si];
  cmp   bx, 0       ; checks if there are still any vacant records
  jz    recordsFull

  printStr msgName  ; prompts "Enter Name: "
  push  bx          ; stores arRecs[si] into the stack
  push 20               ; used for counter later
  call getStr           ; gets name from the user

  printStr msgYearBrth                  ; prompts "Year of Birth: "
  call readNum                          ; gets the user input
  mov  ax, num                          ; ax := year of birth
  mov  word ptr [bx][yearOfBirth], ax   ; arRecs[si + 21] := year of birth;

  printStr msgColors        ; prompts the user to enter his favorite colors 
  lea  bx, [bx][faveColors] ; bx := offset of arcRecs[si + 23];
  push bx                   ; push bx into stack
  call getColorsInput
  jmp  getDataRet

  recordsFull:        ; there are no vacant records
    printStr strFull  ; informs the user that there are no vacant records

  getDataRet:
    ret
getDataInput endp
;;;;;;;;;;;;;;;;;;;;

;;;;; searches for the next vacant record
findVacant proc near
  mov cx, arSize  ; cx := arSize; arSize = 10
  mov bx, 0       ; bx := 0;

  find:
    mov  ax, recSize      ; ax := recSize; recSize = 24
    mul  bl               ; ax := bl * al = [0..9] * 24;
    mov  si, ax           ; si := ax;
    cmp  arRecs[si], '$'  ; checks if the current record
                          ;   is occupied or not
    je   found            ; eureka!
    inc  bx               ; bx++;
    loop find             ; if (cx <> 0) jmp find + c--;

  ; there's no vacant record
  mov  ax, 0              ; reinitializes ax 
  jmp  findVacantFinished  

  ; vacant record is found and its index is stored in si
  found:
    lea ax, arRecs[si] 

  findVacantFinished:     ; ax has the value of arRecs[si]
    ret
findVacant endp
;;;;;;;;;;;;;;;;;;;;

;;;;; gets string of characters from the user until 0dh is entered
getStr proc near
  mov  bp, sp     ; bp := sp;
  push bx         

  mov  bx, [bp+4] ; bx := 20;
  mov  ah, 1      ; read char with echo
  mov  cx, [bp+2] ; cx := msgYearBrth

  loopGets:       
    int  21h
    cmp  al, 0dh  ; check if finished with entering the name
    je   endOfStr

  mov  [bx], al   ; adds the input to the string
  inc  bx         ; increments the index of arRecs[si]
  loop loopGets   ; ends if user presses enter

  endOfStr:
    mov byte ptr[bx], '$' ; ends the string with a '$'
    pop  bx               ; bx := arRecs[si]
    ret  4                ; IP := call msgYearBrth
                          ; pops the stack 3 times
getStr endp
;;;;;;;;;;;;;;;;;;;;

;;;;; gets user's favorite colors
getColorsInput proc near
  pop si

  call    getColors
  lea bx, colorsInput
  mov dl, 0

  storeColor:       ; stores the colors chosen
    mov al, [bx]
    cmp al, ','
    je  next
    cmp al, '$'
    je  finishStore
    cmp al,'1'
    je  storeBlue
    cmp al,'2'
    je  storeRed
    cmp al,'3'
    je  storeGreen
    cmp al,'4'
    je  storeYellow
    cmp al,'5'
    je  storePurple

  storeBlue:
    or dl, BLUE
    jmp next

  storeRed:
    or dl, RED
    jmp next

  storeGreen:
    or dl, GREEN
    jmp next

  storeYellow:
    or dl, YELLOW
    jmp next

  storePurple:
    or dl, PURPLE
    jmp next

  next:             ; goes to the nex character in the array
    inc bx
    jmp storeColor

  finishStore:
    pop bx
    mov [bx], dl
    push si
    ret
getColorsInput endp
;;;;;;;;;;;;;;;;;;;;

;;;;; gets the colors
getColors proc near
  lea bx, colorsInput   ; bx := offset of colorsInput;
  mov cx, 0ah           ; cx := new line;
  xor di, di            ; di := 'di';

  getTheInput:

    prompt:
      mov ah, 7         ; read char w/o echo
      int 21h
      cmp di, 0         ; checks what the user can input
      jz  d
      cmp al, ','
      je  comma
      cmp al, 0dh
      je  inputFinish
      jmp prompt

    d:                  ; checks if input is a valid number
      cmp al,'1'
      jl  prompt
      cmp al,'5'
      jg  prompt
      or  di, 1
      jmp inputOK

    comma:              ; di := di;
      xor di, di

    inputOK:            ; prints a valid input and adds it to the
                        ;   favorite colors then goes back to ask
                        ;  for another input
      mov   dl, al
      mov   ah, 2
      int   21h
      mov   [bx], al
      inc   bx
      loop  getTheInput

  inputFinish:
    mov al,   '$'       ; ends the favorite colors
    mov [bx], al        ; [bx] := the colors;
    ret
getColors endp
;;;;;;;;;;;;;;;;;;;;

;;;;; displays 1 record at a time
displayRecords proc near
  mov bp, sp
  mov dx, [bp+2]        ;
  printStr theRecords   ; "Data in record:"
  printStr line         ; "--------------------------"
  printStr newLine      ; a new line
  mov cx, arSize        ; cx := 10;
  mov bx, 0             ; bx := 0;
  mov di, 0             ; di := 0;

  initialize_loop:
    mov ax, recSize     ; ax := 24;
    mul bl              ; al := 24 * 0;
    mov si, ax          ; si := ax;
    cmp arRecs[si], '$' ; checks if no more records can be found
    je  nextRecord

    inc di              ; di++;

    ; prints name in the current record
    printStr arRecs[si]
    printStr newline   

    ; prints year of birth in the current record
    call printAge
    ; mov  num, ax
    ; call writenum       

    ; displays the favorite colors
    lea  ax, arRecs[si][faveColors]
    call displayFaveColors  

    cmp  dx, 2          ; checks if record is to be edited
    jne proceed

    lea  ax, arRecs[si] ; goes to the record to be edited
    push ax
    call edit_a_record

    proceed:
    cmp  dx, 0          ; checks if record should be deleted
    jne  continue

    lea  ax, arRecs[si] ; goes to the record to be deleted
    push ax
    call delete_a_record

  continue:
    printStr line         ; "--------------------------"
    printStr msgPressKey  ; "Press any key to continue..."
    getChNoEcho           ; gets key w/o echo
    printStr newLine      ; a new line                          

  nextRecord:             ; proceeds to the next record
    inc bx
    loop initialize_loop

  cmp di, 0
  jne finishDisplay
  printStr noRecord

  finishDisplay:
    ret 2
displayRecords endp
;;;;;;;;;;;;;;;;;;;;

;;;;; displays favorite colors
displayFaveColors proc near
  push bx
  push cx
  mov  bx, ax
  mov  bl, byte ptr[bx]
  printStr msgDisplay
  or    cx, 1
  test  bl, BLUE
  jz    checkRed
  xor   cx, cx
  printStr strBlue

  checkRed:
    test  bl, RED
    jz    checkGreen
    xor   cx, cx
    printStr strRed

  checkGreen:
    test  bl, GREEN
    jz    checkYellow
    xor   cx, cx
    printStr strGreen

  checkYellow:
    test  bl, YELLOW
    jz    checkPurple
    xor   cx, cx
    printStr strYellow

  checkPurple:
    test  bl, PURPLE
    jz    exitColorDisp
    xor   cx, cx
    printStr strPurple

  exitColorDisp:
    jcxz return
    printStr noColors
    return:
    pop  cx
    pop  bx
    ret
displayFaveColors endp
;;;;;;;;;;;;;;;;;;;;

;;;;; deletes a record
delete_a_record proc near
  mov bp, sp
  push bx
  mov  bx, [bp+2]     ; bx := offset of arRecs[si]
  printStr askDel     ; asks if record should be deleted  
  mov ah, 1           ; get char w/ echo
  int 21h
  and al, 11011111b   ; toUpper(al);
  cmp al, 'Y'
  jne exitDel

  mov byte ptr[bx], '$' ; deletes current record
  printStr delResult    ; "Data deleted successfully =P"

  exitDel:
    pop bx
    ret 2
delete_a_record endp
;;;;;;;;;;;;;;;;;;;;

;;;;; displays a record to be deleted
deleteRec proc near
  push 0
  call displayRecords
  ret
deleteRec endp
;;;;;;;;;;;;;;;;;;;;

;;;;; displays a record to be deleted
editRec proc near
  push 2
  call displayRecords
  ret
editRec endp
;;;;;;;;;;;;;;;;;;;;

;;;;; edits a record
edit_a_record proc near
  mov bp, sp            ; bp := sp;
  push bx
  mov bx, [bp + 2]      ; bx := arcRecs[si]
  printStr askEdt       ; asks user if record is to be edited
  mov ah, 1
  int 21h
  and al, 11011111b     ; toUpper(al);
  cmp al, 'Y'
  jne exitEdt

  push dx

  ; edits name
  printStr msgName      
  push bx
  push 20
  call getStr

  ; edits year of birth
  printStr msgYearBrth
  call readnum
  mov ax, num
  mov word ptr [bx][yearOfBirth], ax

  ; edits favorite colors
  printStr msgColors    
  lea bx, [bx][faveColors]
  push bx
  call getColorsInput

  printStr edtResult

  pop dx

  exitEdt:
    pop bx
    ret 2
edit_a_record endp
;;;;;;;;;;;;;;;;;;;;

;;;;; computation for the age
printAge proc near
  push ax
  push bx
  push cx
  push dx

  mov ah, 2ah
  int 21h

  mov  ax, word ptr arRecs[si][yearOfBirth]
  sub  cx, ax

  cmp cx, 9
  jbe print1

  cmp cx, 99
  jbe print2

  jmp noSuch

  print2:         ; if the year gap is more than 9 years
    mov ax, cx
    mov bl, 10
    div bl
    mov numb, ah
    mov dl, al
    add dl, 30h
    mov ah, 2
    int 21h
    mov dl, numb
    add dl, 30h
    mov ah, 2
    int 21h
    jmp impo

  print1:         ; if the year gap is 1-digit
    mov dl, cl
    add dl, 30h
    mov ah, 2
    int 21h
    jmp impo

  noSuch:
    mov dx, offset msgNoSuch
    mov ah, 9
    int 21h

  impo:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
printAge endp
;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;  Main  ;;;;;;;;;;;;;;;;;;;;;
main:
  mov ax, @data
  mov ds, ax            ; points ds to the start of the data segment

  call initializeArray  ; initializes the array of records       
 
  showMenu:             ; shows menu 'til a valid option is entered
    printStr msgMenu    ; shows menu
    call getChoice      ; gets user's choice from the menu

    cmp al, 'A'         
    je getData          ; proceeds to get data from the user
    cmp al,'B'
    je showData         ; lets the user view the data
    cmp al,'C'
    je  deleteData      ; lets the user enter a data
    cmp al, 'D'
    je editData
    jmp quit            ; exits the program
 
  getData:              ; gets data from the user
    call getDataInput   
    jmp  showMenu
 
  showData:             ; shows all data
    push 1
    call displayRecords
    jmp  showMenu
 
  deleteData:           ; deletes a record
    call deleteRec
    jmp showMenu

  editData:             ; edits a record
    call editRec
    jmp showMenu
 
  quit:                 ; terminates program
    mov ah, 4ch
    int 21h
 
end main
;;;;;;;;;;;;;;;;;;  End of Main  ;;;;;;;;;;;;;;;;;

