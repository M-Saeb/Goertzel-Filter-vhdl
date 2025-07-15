% For generating analog signal of the goertzel algorithm

function magnitude = goertzel_algorithm(signal, target_freq, sampling_rate)
    % Parameters
    N = length(signal); %Length of the signal
    k = round(0.5 + (N * target_freq/sampling_rate));
    w = (2 * pi * k) / N; % Angular frequency
    cosine = cos(w);
    fprintf("%.20f\n",cosine);
    disp(cosine);

    sine = sin(w);
    fprintf("%.20f\n",sine);
    disp(sine);

    coeff = 2 * cos(w); % Coefficient used in the algorithm
    fprintf("%.20f\n",coeff);
    disp(coeff);

    % Initialize variables
    Q1 = 0;
    Q2 = 0;
    
    % Apply the Goertzel algorithm
    for n = 1:N
        Q0 = signal(n) + coeff * Q1 - Q2;
        Q2 = Q1;
        Q1 = Q0;
    end
    
    % Calculate the magnitude   
    real_part = Q1 - Q2 * cosine;
    imag_part = Q2 * sine;
    magnitude = sqrt(real_part^2 + imag_part^2);

end
