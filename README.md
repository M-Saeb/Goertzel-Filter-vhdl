# Goertzel-Filter-vhdl

This repository contains the VHDL implementation of the Goertzel Algorithm designed to detect a 150 kHz signal in a data set sampled at 4 MHz. The design is modular, synthesizable, and handles input and output data efficiently.


## Goertzel Algorithm
The Goertzel algorithm is a digital signal processing technique used to detect specific frequencies within a block of input data. It's particularly useful for applications like tone detection in telecommunication systems.

In simple terms:

#### Purpose: 
The Goertzel algorithm is designed to detect a specific frequency component within a block of input samples.
#### How it works: 
It transforms the input data into a frequency domain representation but is optimized to focus on one frequency of interest.
#### Advantages: 
It’s more efficient than performing a full Fast Fourier Transform (FFT) when you only need to detect a single frequency.

### Step-by-Step Equations

### Initialization
Set initial values:
- \( s[0] = 0 \)
- \( s[1] = 0 \)

### Processing each sample x[n]
1. Compute k, the index for the target frequency:
   - k = (N * f_target) / f_sample

2. Compute the coefficient:
   - omega = (2 * pi * k) / N
   - coeff = 2 * cos(omega)

3. Update state:
   - s[n] = x[n] + (coeff * s[n-1]) - s[n-2]

4. Shift the states:
   - s[n-2] = s[n-1]
   - s[n-1] = s[n]

### Final Calculation
Compute the magnitude of the target frequency component:
- real_part = s[N-1] - (s[N-2] * cos(omega))
- imag_part = s[N-2] * sin(omega)
- magnitude = sqrt(real_part^2 + imag_part^2)

### Summary
The Goertzel algorithm processes each input sample to update its internal state and finally computes the magnitude of the desired frequency component. *This method is efficient for detecting specific frequencies within a signal.*

## Shared Folder [Link](https://fhdoprod.sharepoint.com/:f:/r/sites/Stud-Microelectronic/Shared%20Documents/General?csf=1&web=1&e=UawF4C)
- Content
  - Milestone
  - Minute Meeting
  - Task Distribution
  - Design

## Project Overview

The Goertzel Algorithm is implemented with the following specifications:
- Number of samples (N): 135
- Input data: 12-bit unsigned (offset binary numbers)
- Internal data: 20-bit signed (2’s complement numbers)
- Sample frequency: 4 MHz
- Signal frequency to detect: 150 kHz
- Output: 20-bit signed level indication

## Modules

### Module A: The system
- **Function**: container for the modules
- **Tasks**:
- **Interface**:
  - rst
  - clk
  - 12-bit unsigned input samples.
  - N (number of sample: int)[generic]
  - frequency sample
  - output magnitude
  - output real number
  - output imaginary number
 
### Module B: Filler
- **Function**: Convert the 12-bit unsigned samples to 20-bit signed samples (2’s complement)
- **Tasks**:
  - Accept 12-bit unsigned input samples.
  - Convert the 12-bit unsigned samples to 20-bit signed samples (2’s complement).
  - Pass the converted samples to the Goertzel Module.
- **Interface**:
  - rst
  - clk
  - 12-bit unsigned input samples.
  - output 20-bit signed samples

### Module B: Goertzel Core Module
- **Function**: Implements the Goertzel algorithm to detect the presence and level of the 150 kHz signal within the input data.
- **Tasks**:
  - Initialize algorithm parameters.
  - Implement the Goertzel recurrence relation to process each sample.
  - Calculate the magnitude squared of the resulting complex number.
  - Pass the computed result to the Output and Scaling Module.

### Module C: Output and Scaling Module
- **Function**: Scales the Goertzel output to fit the desired output range and format, and provides the final signed output number.
- **Tasks**:
  - Accept the result from the Goertzel Core Module.
  - Apply necessary scaling to ensure the output fits within the 20-bit signed range.
  - Handle any overflow conditions.
  - Output the final 20-bit signed result.

### Module D: Control Unit Module
- **Function**: Coordinates the operation of the Input Interface, Goertzel Core, and Output and Scaling Modules, ensuring proper data flow and timing.
- **Tasks**:
  - Generate control signals for data sampling and processing.
  - Ensure proper sequencing of operations.
  - Manage the start and stop conditions for processing each data set.

### Module E: Testbench Module
- **Function**: Simulates the entire system to verify functionality and performance.
- **Tasks**:
  - Provide simulated input data to the Input Interface Module.
  - Capture and analyze the output from the Output and Scaling Module.
  - Verify the correctness of the overall design through various test scenarios.

## Getting Started

### Prerequisites
- VHDL Simulator (e.g., ModelSim, Vivado)
- FPGA Development Board (optional for synthesis and real-world testing)

### Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/goertzel-vhdl.git
   cd goertzel-vhdl
