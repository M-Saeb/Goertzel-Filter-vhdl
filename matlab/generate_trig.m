% Parameters
Fs = 7.4e6; % Sampling frequency in Hz
T = 0.001; % Duration in seconds
% Frequencies of the sine waves in Hz
frequencies = [173e3, 170e3, 176e3, 5e3, 200e3, 2e6]; 
A = 1; % Amplitude of the analog signal
nBits = 14; % Number of bits for quantization (14-bit ADC)
outputFile = 'matlab/signal_files/trig_phase_digital.txt'; % Output file name

% Generate the analog signal 
t = 0:1/Fs:T-(1/Fs); % Time vector
analogSignal = zeros(size(t));

for i = 1:length(frequencies)
    % Convert phase to radians
    phaseRad = deg2rad(0);
    analogSignal = analogSignal + generate_signal(frequencies(i), t, 'triangle');
end

% Normalize the amplitude
analogSignal = analogSignal / length(frequencies); 

% Quantization
% Maximum positive value for a signed 14-bit number
maxVal = 2^(nBits-1) - 1;

% Minimum negative value for a signed 14-bit number
minVal = -2^(nBits-1); 

% Normalize and quantize the signal - Convcert to 14-bit digital signal
digitalSignal = round((analogSignal / max(abs(analogSignal))) * maxVal); 

% Clip the values to the range of the ADC
digitalSignal(digitalSignal > maxVal) = maxVal;
digitalSignal(digitalSignal < minVal) = minVal;

% Convert to hexadecimal
% Adjust to unsigned and convert to hex, 3 digits for 14-bit
hexSignal = dec2hex(digitalSignal + 2^(nBits-1), 3); 

% Save the hexadecimal values to a file
fid = fopen(outputFile, 'w');
for i = 1:length(hexSignal)
    fprintf(fid, '%s\n', hexSignal(i, :));
end
fclose(fid);