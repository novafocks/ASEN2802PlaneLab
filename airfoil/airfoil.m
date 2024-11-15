%% Clear Workspace

clear; clc; close all;

%% Import Data

raw = readmatrix("ASEN2802_InfiniteWing_FullRange.csv");

%% Testing coefficient of pressure

p_M = raw(:, 15:end);
q_inf = raw(:, 5);
aoa = raw(:, 8);

c_P = c_P_calculator(p_M, q_inf,aoa);
c_p_plot = transpose(c_P(490, 1:16));
c_p_plot(18) = c_p_plot(1);


unique_aoa = unique(aoa);
num_ports = 17;
avg_c_P = zeros(length(unique_aoa), num_ports);

for i = 1:length(unique_aoa)
    aoa_idx = aoa == unique_aoa(i);
    avg_c_P(i, :) = mean(c_P(aoa_idx, 1:num_ports), 1);
end

act_c_P = avg_c_P(25,:)';
act_c_P(17) = (0);
act_c_P(18) = act_c_P(1);

%% CHAT GPT

% Define port coordinates in inches
port_data = [
    1, 0, 0, 0;
    2, 0.03937, 0.1672, 0.1905;
    3, 0.07874, 0.339, 0.27;
    4, 0.11811, 0.6856, 0.358;
    5, 0.15748, 1.0347, 0.3872;
    6, 0.19685, 1.3348, 0.3902;
    7, 0.23622, 1.6357, 0.3754;
    8, 0.27559, 2.2394, 0.3006;
    9, 0.23622, 2.845, 0.1785;
    10, 0, 3.5031, 0;
    11, 0.31496, 2.8536, -0.0272;
    12, 0.27559, 2.2542, -0.0523;
    13, 0.23622, 1.6547, -0.0774;
    14, 0.15748, 1.0552, -0.1026;
    15, 0.11811, 0.7055, -0.1172;
    16, 0.07874, 0.3551, -0.1151;
    17, 0.03937, 0.1794, -0.1022;
    18, 0, 0, 0;
];

hold on
plot(port_data(1:18, 3)./3.5, act_c_P);
set(gca, 'YDir','reverse')
xlabel('Normalized Chord Position');
ylabel('Average Coefficient of Pressure (Cp)');
title('Average C_P Distribution for AoA of 9 degrees');
hold off

% Plot averaged Cp values for each angle of attack
figure();
hold on
num_ports = 16;
x_coords = port_data(1:num_ports, 3)./3.5;

for i = 1:length(unique_aoa)
    cp_values = avg_c_P(i, 1:num_ports); % Cp values for each port at current AoA
    plot(x_coords, cp_values, '-o', 'DisplayName', sprintf('AoA %.2f', unique_aoa(i)));
end

xlabel('Normalized Chord Position');
ylabel('Average Coefficient of Pressure (Cp)');
title('Average C_P Distribution along Chord Length');
set(gca, 'YDir', 'reverse');
hold off;

c_n = -trapz(port_data(1:18, 3)./3.5, act_c_P);
c_a = trapz(port_data(1:18, 4)./3.5, act_c_P);

c_l(unique_aoa,1) = c_n * cosd(unique_aoa) - c_a * sind(unique_aoa);
c_d(unique_aoa,1) = c_n * sind(unique_aoa) + c_a * cosd(unique_aoa);

figure()
plot(unique_aoa,c_l','MarkerSize',100)
%% Functions

function [c_P] = c_P_calculator(p_M, q_inf, aoa)
    [p_M_rows p_M_cols] = size(p_M);

    c_P = zeros([p_M_rows p_M_cols + 1]);

    for i = 1:p_M_cols
        c_P(:,i) = p_M(:, i) ./ q_inf;
    end

    c_P(:,p_M_cols + 1)  = aoa;
end