% final test

clc;
clear;
close all;

% Define the parameters
target_freq = 173e3; 
amplitude = 1;  % Amplitude of the sine wave
N = 137;   % Number of Samples
sampling_rate = 7.4e6; % Sampling rate of 1 MHz

t = 0:1/sampling_rate:(N-1)/sampling_rate; % Time vector

frequencies = [173e3 170e3 176e3 5e3 200e3 2e6];

for i=1:5
    % For Sine waves
    signal = (sin(2*pi*frequencies(i)*t)+1)*(2^13-1);

    % For Triangle waves
    % signal = (sawtooth(2*pi*frequencies(i)*t)+1)*(2^13-1);

    % For Rectangular waves
    % signal = (square(2*pi*frequencies(i)*t)+1)*(2^13-1);

    magnitude = goertzel_algortihm(signal, target_freq, sampling_rate);

    disp(['Magnitude at ', num2str(target_freq), ' Hz: ', num2str(magnitude)]);
    figure('Name', sprintf('Magnitude at %d Hz', frequencies(i))); % <-- Window title
    stem(target_freq, magnitude, 'filled');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    title(sprintf("%d",frequencies(i)));
    grid on;
    % Save the signal to a text file
    
    
    figure('Name', sprintf('Signal at %d Hz', frequencies(i))); % <-- Window title
    plot(signal);
    title(sprintf("%d",frequencies(i)));
    xlabel('Time');
    ylabel('Magnitude');

end
