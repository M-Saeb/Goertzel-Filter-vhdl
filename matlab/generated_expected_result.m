
Fs = 7.4e6; % Sampling frequency in Hz (must match generate_sine.m)
N = 137; % number of samples
% Read the hexadecimal values from the text file
fileID = fopen('matlab/signal_files/sine_phase_digital.txt', 'r');
hex_values = textscan(fileID, '%s');
fclose(fileID);
% Convert hex values to decimal
decimal_values = hex2dec(hex_values{1});
% Define the target frequency
target_freq = 173e3;
% Goertzel parameters
k = round(N * target_freq / Fs);
w = (2 * pi * k) / N;
sine = sin(w);
cosine = cos(w);
coeff = 2 * cosine;

% Print Q14 coefficients for VHDL
Q14 = 2^14;
fprintf('Q14 coefficients for VHDL:\n');
fprintf('cosine: %d\n', round(cosine * Q14));
fprintf('sine:   %d\n', round(sine * Q14));
fprintf('coeff:  %d\n', round(coeff * Q14));

% Initialize variables
Q0 = 0;
Q1 = 0;
Q2 = 0;
% Apply the Goertzel algorithm
for n = 1:N
    Q0 = round(coeff * Q1 - Q2 + double(decimal_values(n)));
    Q2 = Q1;
    Q1 = Q0;
end
% Compute the magnitude squared of the frequency component
real_part = (Q1 - Q2 * cosine);
imag_part = (Q2 * sine);
magnitude_squared = real_part^2 + imag_part^2;
% Display the result
fprintf('Magnitude squared at %d Hz: %f\n', target_freq, magnitude_squared);
fprintf('Real and Img at %f: %f\n', real_part, imag_part);