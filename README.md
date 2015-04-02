# PSD
# Laboratory 1 - Simple Calculator

Create a simple arithmetic-logic calculator using VHDL and tools of automatic syntax and simulation.
There are 3 different blocks. 
* Control Unit - a finite state machine that controls the data unit based on the input of several pressure buttons.
* Data Unit - responsible for performing all calculations necessary.
* 7 segs Display - used to display the result of each operation.

Operations:
* ADDS (signed sum): R2 <- R2 + R1
* SUBS (signed subtraction): R2 <- R2 – R1
* MULS (signed multiplication): R2 <- R2 × R1
* LOGIC (logic operation): R2 <- R2 AND R1
* SHIFT-RIGHT Arithmetic: R2 <- R2 sra (R1%8)
* LOAD1: R1 <- ENT (input from switches)
* LOAD2: R2 <- ENT

# Laboratory 2 - Resource sharing and Operation scheduling 

Calculate the determinant of 100 matrixes.
The objective was to calculate the determinant of 100 matrixes using only 2 multipliers and 1 adder. To do this was necessary to break the computation of the determinant into simple operations like multiplication, sum and subtraction.

The determinant of a matrix A(3x3) is given by aei-afh-bdi+cdh+bfg-ceg.

# Laboratory 3 - Binary Image Processing 

Given a binary image there are several morphological operations that can be applied.
* Erosion 
* Dilation
* Closing
* Opening
* Boundary Extraction

The binary image was sent to a input BRAM on a FPGA through USB connection and the result image was extracted from an output BRAM via USB too. The maximum size allowed for the images was 128x128x1.

This projects were developed with Ricardo Vieira.
