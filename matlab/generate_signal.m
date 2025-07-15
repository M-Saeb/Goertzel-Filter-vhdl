function signal = generate_signal(frequencies, t, type)

    scaling_value = 2^14 - 1; % Scaling ths signal to fit in 14 bits

    % Generate the signal based on the specified type
    switch type
        case 'sine'
            signal = (sin(2 * pi * frequencies .* t) + 1) * scaling_value; % +1 to shift the signal to only positive values
        case 'triangle'
            signal = (sawtooth(2 * pi * frequencies .* t) + 1) * scaling_value; % +1 to shift the signal to only positive values
        case 'rectangular'
            signal = (square(2 * pi * frequencies .* t) + 1) * scaling_value; % +1 to shift the signal to only positive values
        otherwise
            error('Unsupported signal type');
    end
end
