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
;  This module's call name: mean
;  Language: X86-64
;  Syntax: Intel
;  Date last modified: 2014-Nov-30
;  Purpose: This module will calculate the mean of a data in an array
;  File name: mean.asm
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

;===== Begin code area ====================================================================================================================================================
global mean					;makes mean a callable function

extern printf					;External C++ function for writing to standard output device

extern sum					;External module for calculating the sum of an array

%include "debug.inc"				;Allows debug.inc to be used in this asm file

;========= segment .data ==================================================================================================================================================
segment .data                                               ;Place initialized data here

;========= segment .bss ==================================================================================================================================================                                                         ; Taken from example code provided by Prof. F. Holliday
segment .bss                                                ;Uninitialized data are declared in this segment

align 64                                                    ;Ask that the next data declaration start on a 64-byte boundary.
backuparea resb 832                                         ;Create an array for backup storage having 832 bytes.
returnValue resb 8					;reserve space for return value

;========= segment .text =================================================================================================================================================
segment .text					;Instructions are placed in this segment
                                                        
mean:                                                  	;Execution of this program will begin here.

vzeroall                                          	;clear/zero out AVX registers

call      sum                                     	;get sum of array into xmm0

cvtsi2sd  xmm1, rsi                               	;convert number of elements in array to double float and store in xmm1
divpd     xmm0, xmm1                              	;divide xmm0 by xmm1

push qword 0					;prepare space on the stack				
movlpd    [rsp], xmm0                            	 	;I think rsp has 3 x eight bytes of padding at the top
mov       r12, [rsp]                              	;copy values from stack to r12
pop qword rax					;space is free from the stack and r12  contains the return value 

setreturnvalarraysum: ;=========== Set the value to be returned to the caller =============================================================================================

push        r12					;push r12 onto the stack
movsd       xmm0, [rsp]				;move the value from the stack into xmm0 to be returned
pop         r12					;free up space on the stack

ret                                                         ;Pop the integer stack and resume execution at the address that was popped from the stack.

;==========================================================================================================================================================================
;End of mean: ; ===========================================================================================================================================================
;==========================================================================================================================================================================

