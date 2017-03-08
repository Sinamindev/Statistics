runme: passing-driver.cpp outputdatarray.cpp variance.cpp   harmonicmean.cpp passing.o inputqarray.o mean.o sum.o reciprocals.o debug.o
	g++ passing-driver.cpp outputdatarray.cpp variance.cpp   harmonicmean.cpp passing.o inputqarray.o mean.o sum.o reciprocals.o debug.o -o runme

passing.o: passing.asm 
	nasm -f elf64 passing.asm -o passing.o

mean.o: mean.asm
	nasm -f elf64 mean.asm -o mean.o

inputqarray.o: inputqarray.asm 
	nasm -f elf64 inputqarray.asm -o inputqarray.o

sum.o: sum.asm 
	nasm -f elf64 sum.asm -o sum.o 

reciprocals.o: reciprocals.asm 
	nasm -f elf64 reciprocals.asm -o reciprocals.o 



