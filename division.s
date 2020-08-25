@ This program compute how many times a number N1 (strictly positive) 
@ goes into another number N2 (strictly positive)

.equ  swiExit, 0x18
    .data
N1: .word   0x9    @ input divisor 
N2: .word   0x4    @ input dividend
Q:  .word   0	   @ quotient
R:  .word   0	   @ remainder      
    .text
_start:
    ldr     r0, =N1
    ldr     r0, [r0]
    ldr     r1, =N2
    ldr     r1, [r1]
    ldr     r4, =Q		
    ldr     r5, =R		
loop:
    cmp     r1, r0		
    addge   r2, #1		@ if N2 > N1, increase Q
    subge   r1, r0		@ if N2 > N1, decrease N2
    movlt   r3, r1		@ if N2 < N1, remainder = N2
    bge     loop			
    str     r2, [r4]		
    str     r3, [r5]        
    mov     r0, #swiExit
    swi     0x123456
