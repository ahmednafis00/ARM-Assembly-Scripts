@ This program finds the largest number in a series of N integers (0 ≤ N < 256)

.equ  swiExit, 0x18
    .equ  elmtCnt, 0x10  @ size of array
    .data
arr:.word   1,-1,2,-2,3,-3,4,-4,5,-5 
max:.word   0x80000000;   @ smallest integer
    .text
_start:
    mov     r1, #elmtCnt 
    ldr     r0, =max
    ldr     r2, =arr
    ldr     r4, [r0]
loop:
    sub     r1, r1, #1
    ldr     r3, [r2], #4
    cmp     r4, r3
    movlt   r4, r3  @ gets the current max value
    cmp     r1, #0
    bne     loop
    str     r4, [r0]
exit:
    mov     r0, #swiExit
    swi     0x123456
