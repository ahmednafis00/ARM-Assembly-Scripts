@ This program counts the number of 1's in a binary number

equ  swiExit, 0x18
    .data
value:
    .word   0xABCDEF01  @ input binary number  
    .text
_start:
    ldr     r0, =value
    ldr     r0, [r0]
    mov     r1, #0      @ counter
    mov     r3, #0x1    @ mask used
loop:
    ands    r2, r0, r3  @ isolate LSB
    addne   r1, r1, #1  @ increment counter if LSB = 1
    movs    r0, r0, lsr #1	@ shift value right 1 bit
    bne     loop    
    mov     r0, #swiExit
    swi     0x123456
