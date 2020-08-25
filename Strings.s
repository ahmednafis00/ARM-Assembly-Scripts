@================
@ String library
@================
        .global     strlen
        .global     strcomp
        .global     strcpy
        .global     strcat
        .global     strstr
@ =====================
@ Get string length
@ Input : r0 = address of string
@ Output: r0 = length (bytes)
@ ======================
strlen:
        push {lr}
        mov r1, #0      @ records number of bytes
        loop:
                ldrb r2, [r0]
                cmp r2, #0
                addne r0, r0, #1
                addne r1, r1, #1
                bne loop
        mov r0, r1

_strlen:
        pop {pc}

@ =====================
@ Comp strings 
@ Input : r0 = address of string_1
@         r1 = address of string_2
@ Output: r0 = 0 if equals else -1
@ ======================
strcomp:
        push {lr}
        equalsLoop:  
        @ loop to compare each character from both the strings
                ldrb r2, [r0]
                ldrb r3, [r1]
                cmp r2,r3       @ compares each character
                movne r0, #-1   @ characters being compared are not same
                bne _strcomp
                add r0, r0, #1
                add r1, r1, #1
                cmp r2, #0      @ checks if all the characters have been compared 
                bne equalsLoop
        moveq r0, #0    @ both the strings are same 

_strcomp:
        pop {pc}

@ =====================
@ Copy string 
@ Input : r0 = address of dest
@         r1 = address of srce
@ Output: none
@ ======================
strcpy:
        push {lr}
        copyLoop:  
        @ keep copying until end of string
                ldrb r2, [r1]   @ loads character from source
                cmp r2, #0      @ checks if last character
                strb r2, [r0]   @ stores character in destination
                addne r1, r1, #1
                addne r0, r0, #1
                bne copyLoop

_strcpy:
        pop {pc}

@ =====================
@ Concatenate string 
@ Input : r0 = address of recept.
@         r1 = address of string to happen
@ Output: none
@ ======================
strcat:
        push {r4-r5,lr}
        mov r4, r0      @ save memory address of string 1
        mov r5, r1      @ save memory address of string 2
        bl strlen       @ get length of first string
        add r0, r0, r4  
        mov r1, r5
        bl strcpy       @ copy the second string to the end of first string

_strcat:
        pop {r4-r5,pc}

@ =====================
@ Find string in string 
@ Input : r0 = address of haystack
@         r1 = address of niddle
@ Output: -1 <=> not found
@         n <=> index in haystack
@ ======================
strstr:
        push {r4-r9, lr}
        mov r4, r0      @ save memory address of haystack         
        mov r6, r1      @ save memory address of needle
        mov r5, r0
        bl strlen       @ length of haystack
        mov r7, r0          
        mov r0, r6
        bl strlen       @ length of needle
        mov r8, r0   
    
        cmp r7, r8      @ checks if needle length is greater than haystack length
        blt containsNot        
  
        cmp r0, #0      @ checks if length of haystack is 0    
        beq containsNot
     
        mov r0, r5          
        mov r1, r6   

        containsLoop:   
        @ compares characters from haystack and needle
                ldrb r2, [r0]   @ character from haystack
                ldrb r3, [r1]   @ character from needle
                add r0, r0, #1
                add r1, r1, #1
                cmp r3, #0      @ checks if all the characters in the needle have been a match           
                beq contains        
                cmp r2, r3      @ checks if the two characters are equal
                beq containsLoop 

        diffChar: 
        @ the two characters checked in loop5 are not equal
                add r5, r5, #1 
                mov r0, r5          
                mov r1, r6
                sub r7, r7, #1
                cmp r7, #0      @ all the characters have been compared with no match 
                beq containsNot  
                b containsLoop     

        containsNot:
                mov r0, #-1
                b _strstr

        contains:                
                add r9, r4, r8  @ haystack address + needle length 
                add r9, r9, #1
                sub r0, r0, r9  @ index of first matching character
    
_strstr:
        pop {r4-r9, pc}
           .end
           