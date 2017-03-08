;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;Author information
;  Author name: Sina Amini	
;  Author email: sinamindev@gmail.com
;Project information
;  Project title: Statistics
;  Purpose: To better learn more about calling subprograms and how arrays are passed to subprograms
;  Status: No known errors
;  Project files: passing-driver.cpp, passing.asm, outputdataarray.cpp, sum.asm, inputqarray.asm
;	        harmonicmean.cpp, reciprocals.asm, variance.asm, mean.asm
;Module information
;  This module's call name: passing
;  Language: X86-64
;  Syntax: Intel
;  Date last modified: 2014-Nov-30
;  Purpose: This module will call submodules to read, add, sort, save, pass, and output floating point values.  
;  File name: passing.asm
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
;
;===== Begin code area ====================================================================================================================================================
extern printf                                               ;External C++ function for writing to standard output device

extern scanf                                                ;External C++ function for reading from the standard input device

extern getchar					;External C++ function for reading characters from standard input device

extern inputqarray					;External function for reading data into an array

extern outputdatarray				;External C++ function for outputting data in an array

extern mean					;External function for finding average of dat in an array

extern variance					;External C++ function for calculating variance of data in an array

extern harmonicmean					;External C++ function for calculating harmonic mean of dat an array

extern sum					;External function for calculating the sum of an array

global passing                                        	;This makes passing callable by functions outside of this file.

%include "debug.inc"				;Allows debug.inc to be used in this asm file

segment .data                                               ;Place initialized data here

;===== Declare some messages ==============================================================================================================================================

initialmessage          	db "Welcome to Array Processing", 10, 10, 0

echostart 		db 10, "Thank you this is the array: ", 10, 0

echoformat 		db 10, "The sum of the array is %.8lf", 10, 0

echomean 			db 10, "The mean of the array is %.8lf", 10, 0

echovariance 		db 10, "The variance of the array is %.8lf", 10, 0

echoharmonic 		db 10, "The harmonic mean of the array is %.8lf", 10, 0

echoreciprocals 		db 10, "The array pf reciprocals is ", 10, 0

goodbye 		db 10, "This assembly program will now terminate and send the harmonic mean to the driver. ",10, 10,0       		

xsavenotsupported.notsupportedmessage db "The xsave instruction and the xrstor instruction are not supported in this microprocessor.", 10
                                      db "However, processing will continue without backing up state component data", 10, 0

stringformat 		db "%s", 0                    ;general string format

xsavenotsupported.stringformat db "%s", 0

eight_byte_format 	db "%.8lf",10, 0                        ;general 8-byte float format

integer_format 		db "%ld",0		;general integer format

segment .bss                                                ;Place un-initialized data here.

align 64                                                    ;Insure that the inext data declaration starts on a 64-byte boundar.

backuparea resb 832                                         ;Create an array for backup storage having 832 bytes.
localbackuparea resb 832				;reserve space for backup

data resq 15					;create data array of size 15
pointer resq 15					;creata pointer array of size 15
reciprocals resq 15

segment .text 					;Place executable instructions in this segment.
mov rdx, 0					;prepare rdx
mov rax, 7					;machine supports avx
xsave  [localbackuparea]				;backup area

;===== Begin executable instructions here =================================================================================================================================

segment .text                                               ;Place executable instructions in this segment.

passing:                                              	;Entry point.  Execution begins here.

;=========== Back up all the GPRs whether used in this program or not =====================================================================================================

push       rbp                                              ;Save a copy of the stack base pointer
mov        rbp, rsp                                         ;We do this in order to be 100% compatible with C and C++.
push       rbx                                              ;Back up rbx
push       rcx                                              ;Back up rcx
push       rdx                                              ;Back up rdx
push       rsi                                              ;Back up rsi
push       rdi                                              ;Back up rdi
push       r8                                               ;Back up r8
push       r9                                               ;Back up r9
push       r10                                              ;Back up r10
push       r11                                              ;Back up r11
push       r12                                              ;Back up r12
push       r13                                              ;Back up r13
push       r14                                              ;Back up r14
push       r15                                              ;Back up r15
pushf                                                       ;Back up rflags

;==========================================================================================================================================================================
;===== Begin State Component Backup =======================================================================================================================================
;==========================================================================================================================================================================
;========== Obtain the bitmap of state components =========================================================================================================================

;Preconditions
mov        rax, 0x000000000000000d                          ;Place 13 in rax.  This number is provided in the Intel manual
mov        rcx, 0                                           ;0 is parameter that requests the subfunction that creates the bitmap

;Call the function
cpuid                                                       ;cpuid is an essential function that returns information about the cpu

;Postconditions (There are 2 of these):

;1.  edx:eax is a bit map of state components managed by xsave.  At the time this was written (year 2014) there were exactly 3 state components.  Therefore, bits numbered
;    2, 1, and 0 are important for current cpu technology.
;2.  ecx holds the number of bytes required to store all the data of enabled state components. [Post condition 2 is not used in this program.]
;This program assumes that under current technology (year 2014) there are at most three state components having a maximum combined data storage requirement of 832 bytes.
;Therefore, the value in ecx will be less than or equal to 832.

;Precaution: As an insurance against a future time when there will be more than 3 state components in a processor of the X86 family the state component bitmap is masked to
;allow only 3 state components maximum.

and        rax, 0x0000000000000007                          ;Bits 63-3 become zeros.
xor        rdx, rdx                                         ;A register xored with itself becomes zero

;========== Save all the data of all the enabled state components; GPRs are excluded ======================================================================================

;The instruction xsave will save those state components with one bits in the bitmap.  At this point edx:eax continues to hold the state component bitmap.

;Precondition: edx:eax holds the state component bit map.  This condition has been met.
xsave      [backuparea]                                     ;All the data of state components as described in the bitmap have been written to backuparea.

;Since the start of this program two critical GPRs have changed values, namely: rcx and rdx.  These are critical because they are among the six registers used to pass 
;non-float data to subprograms like this one.  To be absolutely sure that the six data passing registers have their passed-in values all six will have original values 
;restored to them although only two were at risk of losing their passed-in values.

mov        rdi, [rsp+72]
mov        rsi, [rsp+80]
mov        rdx, [rsp+88]
mov        rcx, [rsp+96]
mov        r8,  [rsp+64]
mov        r9,  [rsp+56]

;==========================================================================================================================================================================
;===== End of State Component Backup ======================================================================================================================================
;==========================================================================================================================================================================

;==========================================================================================================================================================================
startapplication: ;===== Begin the application here: Amortization Schedule ================================================================================================
;==========================================================================================================================================================================

vzeroall						;place binary zeros in all components of all vector register in SSE

;==== Show the initial message ============================================================================================================================================
mov rdx, 0					;move 0 to prepare for backup
mov rax, 7					;machine supports avx registers to backup
xsave  [localbackuparea]			 	;backup registers to localbackuparea

mov qword  rax, 0                                           ;No data from SSE will be printed
mov        rdi, stringformat                                ;"%s"
mov        rsi, initialmessage                              ;"Welcome to Array Processing"
call       printf                                           ;Call a library function to make the output

mov rdx, 0					;prepare to restore
mov rax, 7					;machine should restore up to ymm registers
xrstor  [localbackuparea]			    	;restore backed up registers
;==== Calls inputqarray function ==========================================================================================================================================

mov rdi, data					;move data array into rdi for inputqarray
call inputqarray					;call inputqarray to recieve values from user
mov r15, rax					;move size of array from rax into r15
mov r9, 0						;set r9 equal to 0 for comparison
cmp r15, r9					;compare size of array with 0 to check if user entered anything into array
je Empty						;Jumps to empty if the array is empty

;==== Output array information ============================================================================================================================================

mov qword  rax, 0                                           ;No data from SSE will be printed
mov        rdi, stringformat                                ;"%s"
mov        rsi, echostart                                   ;"Thank you this is the array:   "
call       printf                                           ;Call a library function to make the output

mov rdi, data					;move data array into rdi for outputdatarray to recieve
mov rsi, r15					;move size of data array into rsi for outputdatarray to recieve
call outputdatarray					;call outputdatarray function to output the data in the array. 

;==== Output sum of array =================================================================================================================================================

mov rdi, data					;move data array into rdi for sum function to recieve
mov rsi, r15					;move size of data array into rsi for sum function to recieve
call sum						;call the sum module to calculate and output the sum of data array

;==== Output sum of array =================================================================================================================================================
mov rdx, 0					;move 0 to prepare for backup
mov rax, 7					;machine supports avx registers to backup
xsave  [localbackuparea]			 	;backup registers to localbackuparea

mov   rax, 1                                           	;No data from SSE will be printed
mov   rdi, echoformat                                  	;"The sum of the array is %.8lf  "
call  printf                                           	;Call a library function to make the output

mov rdx, 0					;prepare to restore
mov rax, 7					;machine should restore up to ymm registers
xrstor  [localbackuparea]			    	;restore backed up registers

;==== call variance function =================================================================================================================================================

mov rdi, data					;move data array into rdi for sum function to recieve
mov rsi, r15					;move size of data array into rsi for sum function to recieve

call variance					;call the variance module to calculate the variance of data array

movsd xmm0,[rax]					;store value of mean inside xmm0
movsd xmm1,[rax+8]					;store value of variance inside xmm1


;==== Output mean of array ================================================================================================================================================
mov rdx, 0					;move 0 to prepare for backup
mov rax, 7					;machine supports avx registers to backup
xsave  [localbackuparea]			 	;backup registers to localbackuparea

mov   rax,  1                                          	;One data from SSE will be printed
mov   rdi, echomean                                  	;"The mean of the array is %.8lf  "

call  printf                                           	;Call a library function to make the output

mov rdx, 0					;prepare to restore
mov rax, 7					;machine should restore up to ymm registers
xrstor  [localbackuparea]			    	;restore backed up registers

;==== Output variance of array ============================================================================================================================================
movsd xmm0,xmm1  					;move variance into xmm0 for prining

mov rdx, 0					;move 0 to prepare for backup
mov rax, 7					;machine supports avx registers to backup
xsave  [localbackuparea]			 	;backup registers to localbackuparea

mov   rax, 1                                           	;One data from SSE will be printed
mov   rdi, echovariance                                  	;"The variance of the array is %.8lf  "
call  printf                                           	;Call a library function to make the output

mov rdx, 0					;prepare to restore
mov rax, 7					;machine should restore up to ymm registers
xrstor  [localbackuparea]			    	;restore backed up registers

;=== Call function to compute Harmonic mean ===============================================================================================================================
mov rdi, data					;move the data array into rdi for harmonicmean to recieve
mov rsi, r15					;move the size of data array into rsi for harmonicmean to recieve
mov rdx, reciprocals				;move reciprocal array into rdx for harmonicmean to recieve
call harmonicmean					;call the harmonicmean module to calculate the harmonic mean of data array

;==== Output Harmonic mean of array =======================================================================================================================================
push qword 0					;prepare space on the stack	
movsd [rsp],xmm0					;move variance from xmm0 onto stack
mov r14,[rsp]					;move variance from stack into r14 to be returned to driver 
pop rax						;free space on the stack

mov rdx, 0					;move 0 to prepare for backup
mov rax, 7					;machine supports avx registers to backup
xsave  [localbackuparea]			 	;backup registers to localbackuparea

mov   rax, 1                                           	;One data from SSE will be printed
mov   rdi, echoharmonic                                  	;"The variance of the array is %.8lf  "
call  printf                                           	;Call a library function to make the output

mov rdx, 0					;prepare to restore
mov rax, 7					;machine should restore up to ymm registers
xrstor  [localbackuparea]			    	;restore backed up registers

;=== Output the array of reciprocals ======================================================================================================================================
mov rdx, 0					;move 0 to prepare for backup
mov rax, 7					;machine supports avx registers to backup
xsave  [localbackuparea]			 	;backup registers to localbackuparea

mov   rax, 1                                           	;One data from SSE will be printed
mov   rdi, echoreciprocals                                  ;"The array of reciprocals is"
call  printf                                           	;Call a library function to make the output

mov rdx, 0					;prepare to restore
mov rax, 7					;machine should restore up to ymm registers
xrstor  [localbackuparea]			    	;restore backed up registers

mov r12, 0					;move zero into r12 to keep track of loop count			

topofloop:					;top of the loop to output reciprocals

movsd xmm0, [reciprocals+8*r12]			;move address of a location in reciprocals array into xmm0

mov rdx, 0					;move 0 to prepare for backup
mov rax, 7					;machine supports avx registers to backup
xsave  [localbackuparea]			 	;backup registers to localbackuparea

mov   rax, 1                                           	;One data from SSE will be printed
mov   rdi, eight_byte_format                                ;"%.8lf"
call  printf                                           	;Call a library function to make the output

mov rdx, 0					;prepare to restore
mov rax, 7					;machine should restore up to ymm registers
xrstor  [localbackuparea]			    	;restore backed up registers

inc r12						;incremant the count of elements being enter
cmp r15, r12					;checks the current number of elemetns with the total elements of data array

je outofloop					;jumps out of loop if both array sizes are equal
jmp topofloop					;jumps to the top of the loop if the pointer array size is less than the data array size

outofloop:					;position to jump out of loop

Empty:						;Jumps here if user decides not to enter anything into data array

;===== Conclusion message =================================================================================================================================================
mov rdx, 0					;move 0 to prepare for backup
mov rax, 7					;machine supports avx registers to backup
xsave  [localbackuparea]			 	;backup registers to localbackuparea

mov qword  rax, 0                                           ;No data from SSE will be printed
mov        rdi, stringformat                                ;"%s"
mov        rsi, goodbye                                     ;"This assembly program will now terminate and send the harmonic mean to the driver." 							 
call       printf                                           ;Call a llibrary function to do the hard work.

mov rdx, 0					;prepare to restore
mov rax, 7					;machine should restore up to ymm registers
xrstor  [localbackuparea]			    	;restore backed up registers

;Now the stack is in the same state as when the application area was entered.  It is safe to leave this application area.

;==========================================================================================================================================================================
;===== Begin State Component Restore ======================================================================================================================================
;==========================================================================================================================================================================

;Precondition: edx:eax must hold the state component bitmap.  Therefore, go get a new copy of that bitmap.

;Preconditions for obtaining the bitmap from the cpuid instruction
mov        rax, 0x000000000000000d                          ;Place 13 in rax.  This number is provided in the Intel manual
mov        rcx, 0                                           ;0 is parameter that requests the subfunction that creates the bitmap

;Call the function
cpuid                                                       ;cpuid is an essential function that returns information about the cpu

;Postcondition: The bitmap in now in edx:eax

;Future insurance: Make sure the bitmap is limited to a maximum of 3 state components since only 3 state components existed when this software was created.
and        rax, 0x0000000000000007                          ;Bits 63-3 become zeros.
xor        rdx, rdx                                         ;A register xored with itself becomes zero

xrstor     [backuparea]                                     ;The data of the state components as described in the bitmap have been copied from array backuparea to their
                                                            ;original locations. 
;==========================================================================================================================================================================
;===== End State Component Restore ========================================================================================================================================
;==========================================================================================================================================================================

setreturnvalue: ;=========== Set the value to be returned to the caller ===================================================================================================

push       r14                                              ;r14 contains the variance to be received by the driver
movsd      xmm0, [rsp]                                      ;The variance is copied to xmm0[63-0]
pop        rax                                              ;Reverse the push of two lines earlier.

;=========== Restore GPR values and return to the caller ==================================================================================================================

popf                                                        ;Restore rflags
pop        r15                                              ;Restore r15
pop        r14                                              ;Restore r14
pop        r13                                              ;Restore r13
pop        r12                                              ;Restore r12
pop        r11                                              ;Restore r11
pop        r10                                              ;Restore r10
pop        r9                                               ;Restore r9
pop        r8                                               ;Restore r8
pop        rdi                                              ;Restore rdi
pop        rsi                                              ;Restore rsi
pop        rdx                                              ;Restore rdx
pop        rcx                                              ;Restore rcx
pop        rbx                                              ;Restore rbx
pop        rbp                                              ;Restore rbp

ret                                                         ;No parameter with this instruction.  This instruction will pop 8 bytes from
                                                            ;the integer stack, and jump to the address found on the stack.
;========== End of program passing.asm ====================================================================================================================================
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**

