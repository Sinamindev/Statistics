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
//  This module's call name: variance
//  Language: C++
//  Date last modified: 2014-Nov-30
//  Purpose: Computes variance of a data set in an array
//  File name: variance.cpp
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
#include <cmath>
#include <iostream>
using namespace std;

extern "C" double* variance(double* , long);
extern "C" double mean(double*, long);
extern "C" double sum(double*, long);

double* variance(double datarray[], long rsi)
{
  double* twonumbers = new double[2];
  double average;
  double summation;
  double* sqdiff=new double[rsi];
  double tempDiff;

  average=mean(datarray, rsi);
 
  for(int i=0; i < rsi; i++)
  {
    tempDiff = average-datarray[i];
    sqdiff[i]=tempDiff*tempDiff;
  }
  summation = sum(sqdiff,rsi);

  twonumbers[0] = average;
  twonumbers[1] = summation/(rsi);

  return twonumbers;
}