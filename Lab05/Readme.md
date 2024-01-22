 ## Matrix convolution, max pooling and transposed convolution With SRAM

 

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
