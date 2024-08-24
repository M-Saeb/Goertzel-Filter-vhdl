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

## Project Overview

The Goertzel Algorithm is implemented with the following specifications:
- Number of samples (N): 135
- Input data: 12-bit unsigned (offset binary numbers)
- Internal data: 20-bit signed (2’s complement numbers)
- Sample frequency: 4 MHz
- Signal frequency to detect: 150 kHz
- Output: 20-bit signed level indication


## Getting Started
There are 2 folder :
 1. Goertzel filter matlab :
     signal waveform generated and goertzel filter verified in matlab. 
 3. vhdl :- code of goertzel filter implementation in vhdl.

### Prerequisites
- VHDL Simulator (e.g., ModelSim, Vivado)
- FPGA Development Board (optional for synthesis and real-world testing)

### Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/MR-Khan0099/goertzel-vhdl.git
   cd goertzel-vhdl
