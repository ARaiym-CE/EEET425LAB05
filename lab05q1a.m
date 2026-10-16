%EEET 425 LAB05Q1
N = 31;
M = N; %window length parameter, filter order
n = 0:N;

nminus1 = 0:199; %time index for the input signal
w = 0.5 - 0.5 * cos(2 * pi * n / M); %hann window


figure;
freqz(w, 1); %part a magnitude and phase response

num_pairs = (N + 1) / 2; %number of symmetric coefficient pairs, 16
b = w(1:num_pairs); %first half of the window, shared by each pair
x = cos((pi/6)*(nminus1)) + 3*sin((2*pi)*(nminus1)/3); %input signal
L = length(x); %signal length

x_zeros = [zeros(1, N), x, zeros(1, N)]; %zero padding, N zeros on each side
y_zeros = zeros(1, L); %preallocate zero padded output

for i = 1:L
    id = i + N; %index of x(i) inside the padded signal
    acc = 0; %reset accumulator for each output sample
    for k = 0:(num_pairs - 1)
        x_left = x_zeros(id - k); %delay k sample
        x_right = x_zeros(id - N + k); %delay N-k sample, the symmetric partner
        acc = acc + b(k + 1) * (x_left + x_right); %add the pair, one multiply
    end
    y_zeros(i) = acc; %no center tap since the window length is even
end

figure;
stem(nminus1, y_zeros, 'filled'); %zero padding output

x_left_pad  = fliplr(x(1:N)); %mirror of the start
x_right_pad = fliplr(x(L-N+1:L)); %mirror of the end
x_reflect = [x_left_pad, x, x_right_pad]; %reflective padding
y_reflect = zeros(1, L); %preallocate reflective output

for i = 1:L
    id = i + N; %index of x(i) inside the padded signal
    acc = 0;
    for k = 0:(num_pairs - 1)
        x_left = x_reflect(id - k);
        x_right = x_reflect(id - N + k);
        acc = acc + b(k + 1) * (x_left + x_right); %same pair structure as before
    end
    y_reflect(i) = acc;
end

figure;
stem(nminus1, y_reflect, 'filled'); %reflective padding output

x_rep = [x(1) * ones(1, N), x, x(L) * ones(1, N)]; %replicate padding, repeat edge values
y_rep = zeros(1, L); %preallocate replicate output

for i = 1:L
    id = i + N; %index of x(i) inside the padded signal
    acc = 0;
    for k = 0:(num_pairs - 1)
        x_left = x_rep(id - k);
        x_right = x_rep(id - N + k);
        acc = acc + b(k + 1) * (x_left + x_right); %same pair structure as before
    end
    y_rep(i) = acc;
end

figure;
stem(nminus1, y_rep, 'filled'); %replicate padding output