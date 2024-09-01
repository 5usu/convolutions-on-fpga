

## Introduction

Welcome to our exciting journey into the world of FPGAs and image processing! Our project, "Convolution on FPGA," aims to bridge the gap between theoretical computer vision and practical hardware implementation. We're exploring how to perform complex image convolutions using Field-Programmable Gate Arrays (FPGAs), a venture that combines the flexibility of software with the speed of hardware.

Why FPGAs for convolution? In an era where image processing is ubiquitous - from smartphone cameras to autonomous vehicles - the need for fast, efficient computation is paramount. FPGAs offer a unique solution: they provide the speed of dedicated hardware while maintaining the adaptability of reprogrammable circuits. This makes them ideal for implementing convolution operations, which are fundamental to many image processing and machine learning tasks.

Our project isn't just about implementing convolutions; it's about understanding the intricate dance between digital design, hardware constraints, and algorithmic efficiency. As we progress, we're not only learning about FPGAs and Verilog but also gaining insights into the challenges and opportunities in hardware-accelerated image processing.

Join us as we navigate through the complexities of digital electronics, dive deep into Verilog programming, and ultimately work towards implementing convolutional neural networks on FPGAs. Whether you're a seasoned hardware engineer or a curious beginner, we hope our journey inspires and informs your own explorations in this fascinating field.

## Our Progress

### 1. Learning Git and GitHub
- Mastered Git and GitHub for project management
- Successfully pushed notes, research papers, and documents

### 2. Exploring Digital Electronics
- Delved into adders, multiplexers, flip-flops, gates, and more

### 3. Researching FPGA and the Project
- Conducted in-depth research on FPGAs alongside our digital electronics studies

### 4. Learning Verilog Language
- Watched YouTube video lectures for basic understanding
- Solved problems on "HDLbits" ranging from basic concepts to FSMs
- Gained solid understanding of Verilog code
- Explored testbenches and waveforms
- Utilized Icarus Verilog, GTKWave, and EDA Playground

### 5. Assignments and Mentorship
- Completed mentor-assigned questions
- Engaged in problem-solving discussions

### 6. Learning Vivado
- Downloaded and began exploring Vivado

## Problems We Faced

Our journey wasn't without its challenges. Here are some of the key obstacles we encountered:

1. **Iteration Process in Verilog**: Implementing the convolution algorithm in Verilog proved challenging, particularly in managing the iteration process efficiently.

2. **Image Storage**: Finding an effective method to store and manipulate large image data within the FPGA's memory constraints was a significant hurdle.

3. **Vivado Installation on Linux**: The process of installing Vivado on Linux systems presented unexpected difficulties, requiring additional time and troubleshooting.

4. **FPGA Resource Management**: Balancing the computational requirements of convolution with the available FPGA resources demanded careful planning and optimization.

5. **Testbench Creation**: Developing comprehensive testbenches to verify our Verilog implementations was more complex than anticipated.

## Future Tasks: Convolutions

Our next big challenge is implementing convolutions. Here's our approach:

- We'll work with a 64x64 2D Array and a 3x3 Kernel
- Convert the 2D array into a 1D array (4096 elements), called signal-A
- Apply the same to the 3x3 kernel, resulting in a 9-element 1D array
- Perform convolution on these two 1D arrays

![Convolution Framework](https://github.com/user-attachments/assets/bbbbb0ae-95ab-4f56-a4de-d44316ab3c69)

Our Verilog framework will include:
- Multiplexers to flip signals
- Binary multiplier for value multiplication
- Demux for storing values in registers
- Iterative process with value forwarding
- Full adders (8 single-bit adders) for final addition

## Kernels: The Heart of Convolution

Kernels, also known as "masks", determine the type of convolution applied to an image. Let's explore some standard kernels:

### 1. Gaussian Blur

![Gaussian Kernels](https://github.com/user-attachments/assets/bb5a2ef8-5a4e-4b9a-bf85-82994316b759)
![Gaussian Blur Effect](https://github.com/user-attachments/assets/2712dc49-de14-45f0-8535-14292598bcb2)

- Higher values towards the center of the matrix

### 2. Sobel Operator

#### Sobel Edge Operator
![Sobel Edge Operator](https://github.com/user-attachments/assets/29024ada-0e70-4607-a79f-b8969bf1a175)
![Sobel Edge Effect](https://github.com/user-attachments/assets/b9a8cc70-6537-4a7f-b815-dfe2ce62667b)

#### Sobel Sharpening Operator
![Sobel Sharpening Operator](https://github.com/user-attachments/assets/4c985fe2-0862-42fc-8372-bcd353ad016c)
![Sobel Sharpening Effect](https://github.com/user-attachments/assets/150c136c-c485-4ecd-ae91-9e086bb4d660)


