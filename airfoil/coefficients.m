% This is to rewrite the code because the other ones didn't work!


%% Clear Workspace

clear; clc; close all;

%% Import Data

% ALL RAW DATA GOES HERE!

% Raw pressures
raw.collected = readmatrix("ASEN2802_InfiniteWing_FullRange.csv");

% Port position data
raw.ports = readmatrix("ClarkY14_PortLocations.xlsx");

% NACA coefficient data
raw.naca = readmatrix("ClarkY14_NACA_TR628.xlsx");

%% Step 1 - Getting Constants

%%% COLLECTED %%%

% Pressure matrix
data.c.p_M = raw.collected(:, 15:end);

% Atmospheric pressure
data.c.pressure_atm = raw.collected(:, 2);

% Density
data.c.rho = raw.collected(:, 3);

% Airspeed
data.c.airspeed = raw.collected(:, 4);

% Dynamic pressure
data.c.q_inf = raw.collected(:, 5);

% Angles of attack
data.c.aoa = raw.collected(:, 8);

% UNIQUE angles of attack
data.c.unique_aoa = unique(data.c.aoa);

% Number of ports
data.c.num_ports = 16;

%%% PORTS %%%

% NUMBER %
data.p.num          = raw.ports(:, 1);
data.p.num_ports    = data.p.num(~isnan(data.p.num));

% X-POSITION %
data.p.x            = raw.ports(:, 2);
data.p.x_ports      = data.p.x(~isnan(data.p.num));

% Y-POSITION %
data.p.y            = raw.ports(:, 3);
data.p.y_ports      = data.p.y(~isnan(data.p.num));

% Modified for plotting with coef at AoA = 9
data.p.y_mod = data.p.y;
data.p.y_mod(end + 1) = 0;

% Z-POSITION
data.p.z            = raw.ports(:, 4);
data.p.z_ports      = data.p.z(~isnan(data.p.num));

%%% NACA %%%

% Angle of attack
data.n.aoa = raw.naca(:, 1);

% Coefficient of lift
data.n.coefL = raw.naca(:, 2);

% Coefficient of drag
data.n.coefD = raw.naca(:, 3);

%% Step 2 - Coefficients of Pressure

% Making new matrix of correct size
[misc.p_M_rows, misc.p_M_cols] = size(data.c.p_M);
coef.pressure_full = zeros([misc.p_M_rows misc.p_M_cols]);

% Calculating each value of coefficients of pressure
for i = 1 : misc.p_M_cols

    % Pressure matrix divided by dynamic pressure
    coef.pressure_full(:, i) = data.c.p_M(:, i) ./ ...
                                (data.c.q_inf);

end

%% Step 3 - Average the Pressure

% Create matrix of coefficients of pressure
coef.pressure = zeros([length(data.c.unique_aoa) data.c.num_ports]);

% Calculate coefficients of pressure
for i = 1:length(data.c.unique_aoa)

    % Get the indices where the angle of attack matches the current angle
    idx = (data.c.aoa == data.c.unique_aoa(i));
    
    % Average the pressure data for those indices
    coef.pressure(i, :) = mean(coef.pressure_full(idx, :), 1);

end

%% Step 4 - Plot Ports for AoA = 9

% Collect pressures for AoA = 9
coef.pressure_aoa9 = coef.pressure(data.c.unique_aoa == 9, :);

% Redefining some values for sake of graph
coef.pressure_aoa9(end + 1) = 0;
coef.pressure_aoa9(end + 1) = coef.pressure_aoa9(1);

% Plot over y
figure();
plot(data.p.y_mod, coef.pressure_aoa9);

% Plot metadata
xlabel('Normalized Chord Position');
ylabel('Average Coefficient of Pressure (C_P)');
title('Average C_P Distribution for AoA of 9 degrees');

% Flip plot
set(gca, 'YDir', 'reverse');

%% Step 5 - Calculating C_L and C_D

data.c.cord_length = max(data.p.y);

for i = 1 : data.c.num_ports
    coef.pressure_avg(i) = mean(coef.pressure(:, i));
end

coef.normal = - (1 / data.c.cord_length) * trapz(data.p.y_ports, coef.pressure_avg);
coef.axial = (1 / data.c.cord_length) * trapz(data.p.z_ports, coef.pressure_avg);

for i = 1 : length(data.c.unique_aoa)
    misc.curr_aoa = data.c.unique_aoa(i);

    coef.lift(i) = (coef.normal * cosd(misc.curr_aoa)) ...
                    - (coef.axial * sind(misc.curr_aoa));
    coef.drag(i) = (coef.normal * sind(misc.curr_aoa)) ...
                    + (coef.axial * cosd(misc.curr_aoa));
end

%% Step 6 - Plotting C_L and C_D

figure();
plot(data.c.unique_aoa, coef.lift);
hold on;
plot(data.n.aoa, data.n.coefL);
hold off;

legend("Calculated", "NACA");

figure();
plot(data.c.unique_aoa, coef.drag);
hold on;
plot(data.n.aoa, data.n.coefD);
hold off;

legend("Calculated", "NACA");