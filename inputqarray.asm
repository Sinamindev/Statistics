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
;  This module's call name: inputqarray
;  Language: X86-64
;  Syntax: Intel
;  Date last modified: 2014-Nov-30
;  Purpose: This module will read information from user and store them into an array 
;  File name: inputqarray.asm
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

global inputqarray					;makes input array a callable function

extern printf						;External C++ function for writing to standard output device

extern scanf						;External C++ function for reading from the standard input device

extern getchar						;External C++ function for reading characters from standard input device

segment .data						;Place initialized data here

promptmessage1 		db "Do you have data to enter into the array (Y or N)? ", 0

promptmessage2 		db "Enter the next float number: ", 0

stringformat 		db "%s", 0                    	;general string format

eight_byte_format 	db "%lf", 0						;general 8-byte float format

segment .bss                                                ;Place un-initialized data here.
align 64                                                    ;Insure that the inext data declaration starts on a 64-byte boundar.
backuparea resb 832                                         ;Create an array for backup storage having 832 bytes.

localbackuparea resb 832				;reserve space for backup

segment .text					;Place executable instructions in this segment.

inputqarray:					;Entry point

;==========================================================================================================================================================================

mov r15, 0								;place 0 into r15 for count
mov r14, 0x0000000000000059				;places 'Y' into r14 for comparison 
mov r13, rdi							;moves data array into r13

;==== Begin while loop ====================================================================================================================================================
topofloop:					;Entry point for while loop

mov rdx, 0					;move 0 to prepare for backup
mov rax, 7					;machine supports avx registers to backup
xsave  [localbackuparea]			 	;backup registers to localbackuparea

mov qword  rax, 0                                           ;No data from SSE will be printed
mov        rdi, stringformat                                ;"%s"
mov        rsi, promptmessage1                              ;"Do you have data to enter into the array (Y or N)?  "
call       printf                                           ;Call a library function to make the output

mov rdx, 0					;prepare to restore
mov rax, 7					;machine should restore up to ymm registers
xrstor  [localbackuparea]			    	;restore backed up registers

call getchar					;gets char and store its ASCII value in rax

cmp r14, rax					;checks input with 'Y'
jne outofloop					;jumps out if not 'Y'

;==== Prompt for floating point number ====================================================================================================================================
mov rdx, 0					;move 0 to prepare for backup
mov rax, 7					;machine supports avx registers to backup
xsave  [localbackuparea]			 	;backup registers to localbackuparea

mov qword  rax, 0                                           ;No data from SSE will be printed
mov        rdi, stringformat                                ;"%s"
mov        rsi, promptmessage2                              ;"Enter the next float number: "
call       printf                                           ;Call a library function to make the output

mov rdx, 0					;prepare to restore
mov rax, 7					;machine should restore up to ymm registers
xrstor  [localbackuparea]			    	;restore backed up registers

;==== Writing data into array =============================================================================================================================================

mov rdi, eight_byte_format				;prepares rdi for input
push qword 0					;make room on the stack
mov rsi, rsp					;prepares rsi for output
mov rax, 0					;moves 0 into rax
call scanf					;call function to read information from user
mov r12, [rsp]					;move information for stack into r12
mov [r13+r15*8], r12				;move information from r12 into r13 locations for data array
pop rax						;reverse push from earlier

inc r15						;incrament r15 to track how many elements are int the array
call getchar					;fixes the issue with reading 'return' as a character value

jmp topofloop					;jumps to the top of the loop

;==== End while loop ======================================================================================================================================================
outofloop:					;exit point for the loop

mov rax, r15					;moves size of array into rax to be returned to the caller
ret 						;returns the size of the array to the caller

;==========================================================================================================================================================================
;End of inputqarray: ; ====================================================================================================================================================
;==========================================================================================================================================================================

