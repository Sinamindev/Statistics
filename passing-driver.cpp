//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
//Author information
//  Author name: Sina Amini
//  Author email: sinamindev@gmail.com
//Project information
//  Project title: Statistics
//  Purpose: To better learn more about calling subprograms and how arrays are passed to subprograms
//  Status: Performs correctly on Linux 64-bit platforms with AVX
//  Project files: passing-driver.cpp, passing.asm, outputdataarray.cpp, sum.asm, inputqarray.asm
//	         harmonicmean.cpp, reciprocals.asm, variance.asm, mean.asm
//Module information
//  This module's call name: runme.out  This module is invoked by the user
//  Language: C++
//  Date last modified: 2014-Nov-30
//  Purpose: This module is the top level driver: it will call passing
//  File name: passing-driver.cpp
//  Status: In production.  No known errors.
//  Future enhancements: None planned
//Translator information
//  Gnu compiler: g++ -c -m64 -Wall -l passing.lis -o passing-driver.o passing-driver.cpp
//  Gnu linker:   g++ -m64 -o runme.out passing-driver.o passing.o 
//References and credits
//  Seyfarth
//  Professor Holliday public domain programs 
//  This module is standard C++
//Format information
//  Page width: 172 columns
//  Begin comments: 61
//  Optimal print specification: Landscape, 7 points or smaller, monospace, 8½x11 paper
//
//===== Begin code area ===================================================================================================================================================

#include <stdio.h>
#include <stdint.h>
#include <ctime>
#include <cstring>

extern "C" double passing();

int main(){
  double return_code = 9.99;
 
  printf("%s","\nThis driver program will start the main program developed by Sina Amini \n\n");
  return_code = passing();
  printf("%s%1.8f\n\n","The driver received this number: ", return_code);
  printf("%s\n","Have a nice day. The driver will return 0 to the operating system. Bye.");

  return 0;
}//End of main

//===== End of main =======================================================================================================================================================
