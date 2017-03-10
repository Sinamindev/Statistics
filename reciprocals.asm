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
;  This module's call name: reciprocals
;  Language: X86-64
;  Syntax: Intel
;  Date last modified: 2014-Nov-30
;  Purpose: This module will initialize an array of reciprcals of a data array 
;  File name: reciprocals.asm
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

global reciprocals											;This makes passing callable by functions outside of this file.

extern printf                                               ;External C++ function for writing to standard output device

extern scanf                                                ;External C++ function for reading from the standard input device

%include "debug.inc"										;Allow the debugger to be called by this asm file. 

segment .data                                               ;Place initialized data here

segment .bss                                                ;Place un-initialized data here.

align 64                                                    ;Insure that the inext data declaration starts on a 64-byte boundar.

backuparea resb 832                                         ;Create an array for backup storage having 832 bytes.

localbackuparea resb 832									;reserve space for backup

segment .text												;Place executable instructions in this segment.

;==========================================================================================================================================================================
reciprocals: ;===== Begin the application here: initializing the pointer array ============================================================================================
;==========================================================================================================================================================================
mov r15, 0					;move zero into r15 to keep track of loop count

mov r12, rdi					;holds data array
mov r13, rsi					;size
mov r14, rdx					;reciprocals array

topofloop:					;start of loop
						
mov r8,0x3ff0000000000000				;move 1 into r8 for division
movq xmm0, r8
movsd xmm1, [r12+8*r15]				;move addres of a location in data array into rax
divsd xmm0,xmm1						;divide one by the value in data array to find reciprocal
movsd [r14+8*r15], xmm0					;set the reciprocal array rdx to the value of the reciprocal of data array

inc r15						;incremant the count of elements being enter
cmp r13, r15					;checks the current number of elemetns with the total elements of data array

je outofloop					;jumps out of loop if both array sizes are equal
jmp topofloop					;jumps to the top of the loop if the pointer array size is less than the data array size

outofloop:					;position to jump out of loop

;movsd      xmm0, [rdx]                                      ;That pointer array is copied to xmm0[63-0]

;ret						;return to caller

;==========================================================================================================================================================================
;End of reciprocals: ; ====================================================================================================================================================
;==========================================================================================================================================================================




