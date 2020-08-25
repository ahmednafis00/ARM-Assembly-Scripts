@ This program:
      @ prompts user to enter 5 symbols (letters, digit, etc.) that will be stored in an array
      @ then displays the symbols in reverse order
      @ ONLY displays those symbols that were typed in before an asterisk (*) was entered 
      @ BONUS: incorporated code to print all letters (if any) in uppercase

@ Sample run (1):       Sample run (2):
@ >>>abcde              >>>abcd*     
@ <<<EDCBA              <<<DCBA

@ Sample run (3):       Sample run (4):
@ >>>ab*12              >>>[{ab*     
@ <<<BA                 <<<BA{[

.equ  maxValues, 5
.equ	stdin,	0
.equ	stdout, 1
.equ	stderr, 2
.equ	SWI_Write,  0x05
.equ	SWI_Read,   0x06
.equ	SWI_Exit,   0x18
.equ	SWI_Angel,  0x123456
@ *************** Data Area ***************
      .data
block:          @ I/O block
      .word	0   @ stdin/stdout
      .word	0   @ address where to store what is read or where to get data to output
      .word	0   @ number of bytes to read or write
@chars:
@      .word 0,1,2,3,4
cnt:  .word 0   @ number of symbols before star
@ symbols read from keyboard
arr:  .skip   maxValues 
prompt1:
      .ascii  "\n>>>"
prompt2:
      .ascii  "\n<<<"
@ *************** Code Area ***************
      .text
_start:
      @prints prompt1
      ldr r1, =block
      mov r0, #stdout
      str r0, [r1]
      ldr r0, =prompt1
      str r0, [r1, #4]
      mov r0, #4
      str r0, [r1, #8]
      mov r0, #SWI_Write
      swi SWI_Angel

      @prompts the user for input string
      ldr r1, =block
      mov r0, #stdin
      str r0, [r1]
      ldr r0, =arr
      str r0, [r1, #4]
      mov r0, #maxValues
      str r0, [r1, #8]
      mov r0, #SWI_Read
      swi SWI_Angel


      mov r0, #0
      ldr r4, =arr
      ldr r5, =cnt

find:
      cmp r0, #maxValues
      beq symNotFound   @ no '*' in input string
      bne symFound      @ check for '*' in string

isLetter:   @identifies if the character is a letter
      cmp r6, #'a'
      addge r7, r7, #1 
      cmp r6, #'z'
      addle r7,r7, #1
      cmp r7, #2  @ if character is a letter, r7 == 2
      subeq r6, r6, #32 @ converts lowercase to uppercase
      streqb r6,[r4,#-1] @ stores uppercase letter 
      mov r7, #0
      b find

symNotFound: 
      ldr r3, = arr + 4 @ r3 contains memory location of last character in input string
      streq r0, [r5]    @ store the number of characters before '*' i.e. 5
      ldr r2, [r5]      @ r2 contains the number of characters before '*' i.e. 5
      ldr r1, =block    @ prints all the characters backwards
      mov r0, #stdout
      str r0, [r1]
      ldr r0, =prompt2
      str r0, [r1, #4]
      mov r0, #4
      str r0, [r1, #8]
      mov r0, #SWI_Write
      swi SWI_Angel
      b loop

symFound:
      ldrb r6, [r4]     @ load one character from input string
      cmp r6, #'*' 
      addne r0, r0, #1  @ if not '*', increment number of characters before '*'
      addne r4, r4, #1  @ if not '*', go to the next character
      bne isLetter
      streq r0, [r5]    @ if '*' found, store the number of characters before '*'
      ldr r2, [r5]      @ if '*' found, r2 contains the number of characters before '*'
      addeq r3, r4, #-1 @ if '*' found, r3 contains the memory location of the last character before '*'


      @prints prompt2
      ldr r1, =block
      mov r0, #stdout
      str r0, [r1]
      ldr r0, =prompt2
      str r0, [r1, #4]
      mov r0, #4
      str r0, [r1, #8]
      mov r0, #SWI_Write
      swi SWI_Angel
      beq loop

loop: @prints the characters before '*' backwards
      cmp r2, #0
      beq exit
      ldr r1, =block
      mov r0, #stdout
      str r0, [r1]
      str r3,[r1, #4]
      mov r0, #1
      str r0, [r1, #8]
      mov r0, #SWI_Write
      swi SWI_Angel
      sub r2, r2, #1
      sub r3, r3, #1
      bne loop

exit: mov     r0, #SWI_Exit
      swi     SWI_Angel
      .end
