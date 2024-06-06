;=================================================
; Name: Andre Winkel
; Email: awink002@ucr.edu
; 
; Lab: lab 7, ex 2
; Lab section: 023
; TA: Cody Kurpanek
; 
;=================================================
.orig x3000
; Initialize the stack. Don't worry about what that means for now.
ld r6, top_stack_addr ; DO NOT MODIFY, AND DON'T USE R6, OTHER THAN FOR BACKUP/RESTORE

; your code goes here
LEA R1, CHAR_ARRAY
LD R2, SUB_GET_STRING
LD R3, SUB_ISPAL
JSRR R2
JSRR R3

LEA R0, BEGINNING
PUTS

LEA R0, CHAR_ARRAY
PUTS

ADD R4, R4, #0
BRp TRUE

LEA R0, TXT_FALSE
PUTS
BRnzp EOP

TRUE
LEA R0, TXT_TRUE
PUTS

EOP
HALT

; your local data goes here
SUB_GET_STRING  .FILL x3200
SUB_ISPAL       .FILL x3400
;SUB_TOUPPER     .FILL x3600
CHAR_ARRAY      .BLKW #100
BEGINNING       .STRINGZ "The string \""
TXT_TRUE        .STRINGZ "\" IS a palindrome"
TXT_FALSE       .STRINGZ "\" IS NOT a palindrome"


top_stack_addr  .fill xFE00 ; DO NOT MODIFY THIS LINE OF CODE
.end

; your subroutines go below here

;------------------------------------------------------------------------
; Subroutine: SUB_GET_STRING_3200
; Parameter (R1): The starting address of the character array
; Postcondition: The subroutine has prompted the user to input a string,
;	terminated by the [ENTER] key (the "sentinel"), and has stored 
;	the received characters in an array of characters starting at (R1).
;	the array is NULL-terminated; the sentinel character is NOT stored.
; Return Value (R5): The number of non-sentinel chars read from the user.
;	R1 contains the starting address of the array unchanged.
;-------------------------------------------------------------------------
.ORIG x3200
ADD R6, R6, #-1
STR R7, R6, #0
ADD R6, R6, #-1
STR R1, R6, #0

AND R5, R5, #0

GET_CHAR
    GETC
    OUT
    
    ADD R0, R0, x-A     ;check for newline
    BRz END_GET_CHAR    ;exit if sentinel value
    ADD R0, R0, xA      ;restore r0 to pre-check
    ADD R0, R0, x-8     ;check for backspace
    BRz BACKSPACE_CASE  ;do the thing if backspace
    ADD R0, R0, x8      ;restore r0 to pre-check
    
    STR R0, R1, #0      ;store values in r1
    ADD R5, R5, #1
    ADD R1, R1, #1
    BRnzp GET_CHAR      ;loop unconditionally
    
    BACKSPACE_CASE
    ADD R1, R1, #-1
    AND R0, R0, #0
    STR R0, R1, #0      ;replace with 0
    ADD R5, R5, #-1     ;decrement count by 1
    BRnzp GET_CHAR
END_GET_CHAR

LDR R1, R6, #0
ADD R6, R6, #1
LDR R7, R6, #0
ADD R6, R6, #1
RET
.END

;x8 is backspace

;-------------------------------------------------------------------------
; Subroutine: SUB_IS_PALINDROME_3400
; Parameter (R1): The starting address of a null-terminated string
; Parameter (R5): The number of characters in the array.
; Postcondition: The subroutine has determined whether the string at (R1)
;		 is a palindrome or not, and returned a flag to that effect.
; Return Value: R4 {1 if the string is a palindrome, 0 otherwise}
;-------------------------------------------------------------------------
.ORIG x3400
ADD R6, R6, #-1
STR R7, R6, #0
ADD R6, R6, #-1
STR R5, R6, #0
ADD R6, R6, #-1
STR R1, R6, #0

LD R3, SUB_TOUPPER
JSRR R3

ADD R2, R1, R5      ;end address
ADD R2, R2, #-1     ;count is different from index so subtract by 1

CHECK_PAL_LOOP
LDR R3, R1, #0      ;load begin value
LDR R4, R2, #0      ;load end value

NOT R4, R4          ;two's complement and check for zero
ADD R4, R4, #1
ADD R4, R4, R3
BRnp PAL_FALSE

ADD R1, R1, #1
ADD R2, R2, #-1
ADD R5, R5, #-2
BRp CHECK_PAL_LOOP  ;go to next check
BRnzp PAL_TRUE

PAL_TRUE
ADD R4, R4, #0
ADD R4, R4, #1
BRnzp END_CHECK_PAL_LOOP

PAL_FALSE
AND R4, R4, #0

END_CHECK_PAL_LOOP

LDR R1, R6, #0
ADD R6, R6, #1
LDR R5, R6, #0
ADD R6, R6, #1
LDR R7, R6, #0
ADD R6, R6, #1

RET
;local data
SUB_TOUPPER     .FILL x3600
.END

;-------------------------------------------------------------------------
; Subroutine: SUB_TO_UPPER_3600
; Parameter (R1): Starting address of a null-terminated string
; Postcondition: The subroutine has converted the string to upper-case
;     in-place i.e. the upper-case string has replaced the original string
; No return value, no output, but R1 still contains the array address, unchanged
;-------------------------------------------------------------------------
.ORIG x3600
ADD R6, R6, #-1
STR R7, R6, #0
ADD R6, R6, #-1
STR R5, R6, #0
ADD R6, R6, #-1
STR R1, R6, #0

LD R2, BITMASK

UPPERCASE_CONVERTER
LDR R0, R1, #0              ;load value at array into r0
ADD R0, R0, #0              ;last value check 
BRz END_UPPERCASE_CONVERTER

AND R0, R0, R2              ;masking
STR R0, R1, #0

ADD R1, R1, #1              ;pointer inc
BRnzp UPPERCASE_CONVERTER   ;continue loop unconditionally
END_UPPERCASE_CONVERTER

LDR R1, R6, #0
ADD R6, R6, #1
LDR R5, R6, #0
ADD R6, R6, #1
LDR R7, R6, #0
ADD R6, R6, #1

RET
BITMASK .FILL xDF
.END