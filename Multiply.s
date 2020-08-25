@ Library to handle floating point multiplication. 
@ Handles only normalized numbers
@ Does NOT handle overflow/underflow.
@
        .global     getSign
        .global     getExpo
        .global     getMantissa
        .global     setFP
        .global     multFP

@
    .DATA
	.TEXT
@======================================================
@ Subroutine multFP. Multiply two FP numbers
@ Input parameters:
@   r0: address of operand1
@   r1: address of operand2
@ Output parameter:
@   r0: value of product
@=======================================================
multFP:
    push    {r4-r9, lr}
    mov r4, r0
    mov r5, r1    
    
    @ get exponents
    mov r1, r4
    bl  getExpo @ get expo1
    mov r6, r0
    mov r1, r5
    bl  getExpo @ get expo2
    mov r7, r0 
    
    @ get Mantissas
    mov r1, r4
    bl  getMantissa @ get Mantissa1
    mov r8, r0, lsr #10 @ we only need 12 bits for Mantissa
    mov r0, #1
    add r8, r8, r0, lsl #13 @ add hidden bit to Mantissa
    mov r1, r5
    bl  getMantissa @ get Mantissa2
    mov r9, r0, lsr #10 @ we only need 12 bits for Mantissa
    mov r0, #1
    add r9, r9, r0, lsl #13 @ add hidden bit to Mantissa

    @ r4 = address of operand1
    @ r5 = address of operand2
    @ r6 = expo1
    @ r7 = expo2
    @ r8 = Mantissa1 + hidden bit
    @ r9 = Mantissa2 + hidden bit

    @ calculating sign
    mov r1, r4
    bl getSign
    mov r4, r0
    mov r1, r5
    bl getSign
    mov r5, r0
    eor r2, r5, r4  @ perform Exclusive OR of sign bits to determine sign

    @ calculating exponent
    add r6, r7, r6  @ sum of exponents
    sub r6, r6, #127

    @ calculating Mantissa
    mul r8, r9, r8  @ multiplied Mantissa
    mov r0, r8, lsr #26 @ we need two leftmost bits

    cmp r0, #1  @ checks if two leftmost bits are 10 or 11    
    movne r8, r8, lsr #1  @ if two leftmost bits are 10 or 11, shift right one bit     
    addne r6, r6, #1  @ if two leftmost bits are 10 or 11, add one to exponent 
      
    mov r8, r8, lsl #6  @ remove hidden bit
    mov r8, r8, lsr #9  @ r8 contains the resulting Mantissa

    mov r1, r6  @ restore exponent
    mov r0, r8  @ restore mantissa
    bl  setFP
_multFP:
    pop {r4-r9, pc}

@======================================================
@ Subroutine getSign. Extract sign from FP value
@ Input parameter: r1 : address FP value
@ Output parameter: r0 : sign (0 or 1)
@=======================================================
getSign:
    push    {lr}
    ldr r0, [r1]        
    mov r0, r0, lsr #31 @ keep only sign bit
_getSign:
    pop {pc}

@======================================================
@ Subroutine getExpo. Extract exponent from FP value
@ Input parameter: r1 : address FP value
@ Output parameter: r0 : exponent aligned right
@=======================================================
getExpo:
    push    {lr}
    ldr r0, [r1]        
    mov r0, r0, lsl #1  @ remove sign
    mov r0, r0, lsr #24	@ keep only exponent bits
_getExpo:
    pop {pc}

@======================================================
@ Subroutine getMantissa. Extract mantissa part from FP value
@ Input parameter: r1 : address FP value
@ Output parameter: r0 : mantissa aligned right
@=======================================================
getMantissa:
    push    {lr}
    ldr r0, [r1]        
    mov r0, r0, lsl #9  @ remove sign and exponent bits
    mov r0, r0, lsr #9	@ properly align Mantissa bits
_getMantissa:
    pop {pc}

@======================================================
@ Subroutine setFP. Reassemble sign, exponent and
@ mantissa into a 32 bit floating point number.
@ Input parameters:
@   r0 : mantissa value (aligned right)
@   r1 : exponent value (aligned right)
@   r2 : sign value	(aligned right)
@ Output parameter: r0 : FP binary value
@=======================================================
setFP:
    push    {lr}
    mov r2, r2, lsl #31 @ properly align sign bit 
    mov r1, r1, lsl #23 @ properly align exponent bit
    add r0, r0, r2  @ get sign
    add r0, r0, r1  @ get exponent
_setFP:
    pop {pc}
	.END
