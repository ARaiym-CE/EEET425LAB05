%EEET 425 LAB05Q1

N = 31;
M = N;
n = 0:N;

w = 0.5 - 0.5 * cos(2 * pi * n / M);
figure;
freqz(w, 1);