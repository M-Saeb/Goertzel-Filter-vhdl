Fs = 173e3 ; % frequency of interest
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
k = round(target_freq * N / Fs);
omega = 2 * pi * k / N;
sine = 0.1946;%sin(omega);
cosine = 0.230;%cos(omega);
coeff = 0.973;%2 * cosine;
% Initialize variables
Q0 = 0;
Q1 = 0;
Q2 = 0;
% Apply the Goertzel algorithm
for n = 1:N
    Q0 = coeff * Q1 - Q2 + double(decimal_values(n));
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