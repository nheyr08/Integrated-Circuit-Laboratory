# Integrated Circuit Laboratory (Fall 2023)
I took this course as the only international student, and I found it particularly challenging.
However, I persevered and am sharing my codes here for reference.


This repository contains 13 labs, Midterm project and Final project during the IC lab class.
Each lab requires students to write their own pattern and testbenches in order to verify their own design in Verilog/Systemverilog.

--- 
## FINAL Project (16-BIT RISC CPU) 
### Pipelined RISC Processor in Verilog with Post-Synthesis Simulations:

During the final of Ic lab, I Developed a 16-bit Reduced Instruction Set Computing (RISC) processor using Verilog, featuring pipeline stages for efficient instruction execution.
Conducted post-synthesis simulations to validate the functionality and performance of the processor after the synthesis process.
The CPU supports instructions such as Addition, Subtraction, Set-less-Than, Branch on Equal, Multiplication, and Jump.

### Three-Level Cache (SRAM, DRAM, Core Registers):
The system performance is enhanced by reducing the average memory access time and mitigating the performance
for that, a three-level cache hierarchy to leverage locality property in the CPU is integrated, incorporating SRAM for high-speed access, Dynamic RAM (DRAM) for larger storage capacity, and core registers for quick data access by the processor.

### Jasper Tools and System Verilog Assertion for Testability:

Employed Jasper tools and System Verilog Assertion (SVA) techniques to address and mitigate potential testability issues in the design, ensuring thorough and effective testing.
### Full Custom Design from RTL to GDSII:

This custom design process covers the entire flow from the Register Transfer Level (RTL) description to the final Graphic Data System II (GDSII) layout for chip manufacturing.

### Clock Tree Optimization with Minimized Clock Buffers:

Optimized the clock tree structure, reducing the number of clock buffers to enhance overall system efficiency and minimize clock-related issues.
### Area report in Synopsys Design Compiler:
<img width="254" alt="image" src="https://github.com/nheyr08/Integrated-Circuit-Laboratory/assets/64657102/417fb8ea-e9d3-425c-9363-596745798635">

### Timing Report in Synopsys Design Compiler:
<img width="263" alt="image" src="https://github.com/nheyr08/Integrated-Circuit-Laboratory/assets/64657102/eff331c6-2706-49bb-bf94-20fb7d16c490">

### Physical design layout in Innovus:
<img width="822" alt="Screen Shot 2024-02-29 at 10 47 04 PM" src="https://github.com/nheyr08/Integrated-Circuit-Laboratory/assets/64657102/af7068e3-c1c0-4754-a37c-0c4980c764b3">

## Lab1 -> Supper MOSFET Calculator(SMC)
---
In this lab the focus is on Boolean circuits (Combinational).

Given 6 Mosfets Operation region perform the calculations for their ID(current) or Gm calculation

Then Sort the values found for the 6 Mosfets, and Output the Max or Min value based on Input mode.

![image](https://github.com/nheyr08/Integrated-Circuit-Laboratory/assets/64657102/76841a98-e16c-4525-af32-942f7863f1b0)


## Lab2 -> Calculation on Coordinates
---

In this lab the focus is on sequential circuits, The Exercise is to Design a module that performs three modes of operation.

**Trapezoidal rendering**: Given a trapezoid coordinates, find the points or pixels that line within the area covered by the geometric figure.

**Circle Line relationship**: Find out whether a line is (1) Tangent, (2) Intersecting, (3) non-intersecting to a circle given a point on the Circle and its center as well
as two points on the line.

**Area Computing**: Given four points compute the area in between them to a certain accuracy. 

![image](https://github.com/nheyr08/Integrated-Circuit-Laboratory/assets/64657102/79d4d957-ab05-44c6-99a1-9018562ef3ff)


## Lab3 -> AXI-SPI Data Bridge
---
In this lab, the task is to Write my own PATTERN and develop a pseudo SD card by referencing 
the provided design specifications and the SD card protocol. 

Both encrypted versions of correct and incorrect designs were provided to guide and assist in this process.

Additionally, a pseudoDRAM that not only simulates the behavior of actual DRAM but also verifies its specifications was provided.

Once the PATTERN and pseudo SD card were complete,I had to design a bridge module connecting the 
DRAM and the SD card.

![image](https://github.com/nheyr08/Integrated-Circuit-Laboratory/assets/64657102/f7638475-d53c-4934-a97e-9243a07af0fd)
## Lab4 -> Sianamese Neural Network accelarator
---
The Siamese neural network is a type of neural network architecture designed for similarity
learning and feature extraction tasks. It is called "Siamese" because the network consists of two
identical subnetworks, known as twin networks, which share the same architecture and parameters.
These twin networks are used to process two different input samples.
The primary application of Siamese neural network is in tasks that involve determining
similarity or dissimilarity between two input samples. For example, Siamese networks are commonly
used in tasks like face recognition, signature verification, one-shot learning, and similarity-based
recommender systems. In this lab such a Neural Network is implemented using the specifications.
* In this lab, I used several IEEE floating point number IP from Designware.

![image](https://github.com/nheyr08/Integrated-Circuit-Laboratory/assets/64657102/18bdd338-83d5-4bb7-adad-54a1ed636bc2)

**Maximum spec Cell area->** 5 500 000

**My Total cell area--------->** 2 299 825
## Lab5 -> Matrix convolution, max pooling and transposed convolution With SRAM cache
---

The input image matrix size are 8x8, 16x16 or 32x32. The input kernel matrix size is set to
5x5. And needs to perform 2x2 max pooling after the convolution.

### There are two modes for this lab. 
mode = 1’b0 → Convolution + 2x2 Max Pooling

mode = 1’b1 → Transposed Convolution

32 matrices are continuously sent (16 image matrices and 16 kernel
matrices) at the beginning of each pattern in raster's code.

 Output is also given in raster scan order with serial out format.
 
 In this lab, how to generate memory is taught. The number of words and the bits
per each word is defined by myself for the design.
Memory usage can be checked it at CAD.area in 02_SYN/Report/ folder.

All numbers are signed integers and expressed in 2’s complement format. 


![image](https://github.com/nheyr08/Integrated-Circuit-Laboratory/assets/64657102/e3b02e5b-321c-4d04-a007-89d85c3f0e78)

## Lab6 
Sort IP | Tool Command Language (TCL)
## Lab7 
ramdom number genarator | FIFO design | (Cross Clock Domain)
## Lab8
Low Power design, Or Clock gated | Circuit Optimization
## Midterm 
Maze Routing Accelarator | (BFS-modified)-> Lee's Algorithm
## Lab9 
SystemVerilog, Interfacing | Constrained Random Stimulus Generation | DRAM interaction
## Lab10
System Verilog Assertion (SVA) | Coverage | Checkers
## Lab11
Formal Verification -1 (JasperGold)
## Lab12
Formal Verification -2 (JasperGold)
## Lab13
APR flow and IR drop optimization (Innovus)

---
[![Top Langs](https://github-readme-stats-git-masterrstaa-rickstaa.vercel.app/api/top-langs/?username=nheyr08)](https://github.com/anuraghazra/github-readme-stats)

Thanks for reading~
