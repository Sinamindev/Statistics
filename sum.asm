;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;Author information
;  Author name: Sina Amini	
;  Author email: sinamindev@gmail.com
;Project information
;  Project title: Statistics
;  Purpose: To better learn about calling subprograms and how arrays are passed to subprograms
;  Status: No known errors
;  Project files: passing-driver.cpp, passing.asm, outputdataarray.cpp, sum.asm, inputqarray.asm
;	        harmonicmean.cpp, reciprocals.asm, variance.asm, mean.asm
;Module information
;  This module's call name: sum
;  Language: X86-64
;  Syntax: Intel
;  Date last modified: 2014-Nov-30
;  Purpose: This module will compute the sum of a data set in an array
;  File name: sum.asm
;  Status: This module functions as expected.
;  Future enhancements: None planned
;Translator information
;  Linux: nasm -f elf64 -l passing.lis -o passing.o passing.asm 
;References and credits
;  Seyfarth
;  Professor Holliday public domain programs
;Format information
;  Page width: 172 columns
;  Begin comments: 61
;  Optimal print specification: Landscape, 7 points or smaller, monospace, 8½x11 paper

global sum

extern printf                                               ;External C++ function for writing to standard output device

extern scanf                                                ;External C++ function for reading from the standard input device

%include "debug.inc"										;allows the debugger to be used in this asm

segment .data                                               ;Place initialized data here

stringformat 		db "%s", 0                    			;general string format

eight_byte_format 	db "%lf", 0                         	;general 8-byte float format

segment .bss                                                ;Place un-initialized data here.

align 64                                                    ;Insure that the inext data declaration starts on a 64-byte boundar.

backuparea resb 832                                         ;Create an array for backup storage having 832 bytes.

localbackuparea resb 832									;reserve space for backup

segment .text												;Place executable instructions in this segment.

;==========================================================================================================================================================================
sum: ;===== Begin the application here: calculate sum of array ============================================================================================================
;==========================================================================================================================================================================

mov r15, 0						;count
mov r13, rdi					;holds data array
mov r14, rsi					;holds size of array

;==== Begin while loop ====================================================================================================================================================

topofloop:					;starting point of the loop			

movsd xmm1, [r13+r15*8]				;move a value from data array into xmm1
addpd xmm0, xmm1					;add xmm0 and xmm1 together to find sum

inc r15						;incrament the amount of elements added so far
cmp r14, r15					;checks current amount of elements added with the total amount of elements to be added

je outofloop					;jumps out if the number of items added and number of elements in the array are equal
jmp topofloop					;jumps to the top of the loop if the number of items added is less than the number of elemetns in the array

outofloop:					;jumps out of loop here

ret						;return to caller

;==========================================================================================================================================================================
;End of sum: ; ============================================================================================================================================================
;==========================================================================================================================================================================

