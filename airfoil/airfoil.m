%% Clear Workspace

clear; clc; close all;

%% Import Data

raw = readmatrix("ASEN2802_InfiniteWing_FullRange.csv");

%% Testing coefficient of pressure

p_M = raw(:, 15:end);
q_inf = raw(:, 5);
aoa = raw(:, 8);

c_P = c_P_calculator(p_M, q_inf,aoa);

c_p_plot = transpose(c_P(490, 1:15));




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

figure();
plot(port_data(1:15, 3)./3.5, c_p_plot);
set(gca, 'YDir','reverse')

%% Functions

function [c_P] = c_P_calculator(p_M, q_inf, aoa)
    [p_M_rows p_M_cols] = size(p_M);

    c_P = zeros([p_M_rows p_M_cols + 1]);

    for i = 1:p_M_cols
        c_P(:,i) = p_M(:, i) ./ q_inf;
    end

    c_P(:,p_M_cols + 1)  = aoa;
end