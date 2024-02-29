# 16-BIT RISC CPU 
### Pipelined RISC Processor in Verilog with Post-Synthesis Simulations:

During the final of Ic lab, I Developed a 16-bit Reduced Instruction Set Computing (RISC) processor using Verilog, featuring pipeline stages for efficient instruction execution.
Conducted post-synthesis simulations to validate the functionality and performance of the processor after the synthesis process.
The CPU supports instructions such as Addition, Subtraction, Set-less-Than, Branch on Equal, Multiplication, and Jump.
### Metastability Prevention in SRAM:
After implementing the full design and doing APR (Auto Placement and Routing )steps with post-synthesis, my design started facing clock setup time violations. After debugging 
I was able to figure out that the SRAM output data where the source of the violation. Therefore I managed to use a double-flop synchronizer same as when solving multiclock design synchronization,
and it worked! 
## Three-Level Cache (SRAM, DRAM, Core Registers):
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
