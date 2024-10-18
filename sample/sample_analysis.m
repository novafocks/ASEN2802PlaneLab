%{
    This is a sketch using the sample data provided in Canvas!

    Sample Data File: sample_data.csv
%}

%% Clean Workspace
clear; clc; close all;

%% Import Data and Clean
misc.pressThresh = 110;

data.raw = readmatrix("sample_data.csv");
data.clean = data.raw(data.raw(:, 2) >= misc.pressThresh, :);

misc.timeStart = data.clean(1, 1);
data.clean(:, 1) = data.clean(:, 1) - misc.timeStart;

% Putting into individual vectors for easy reference
data.times = data.clean(:, 1);
data.pressures = data.clean(:, 2);

%% Plot Data over Time
figure();
plot(data.times, data.pressures);
xlabel("Time (s)");
ylabel("Relative pressure (Pa)");
title("Relative pressure in wind tunnel over time");

%% Stats
stats.pressure_std = std(data.pressures);
stats.pressure_avg = mean(data.pressures);

%% Calculating Velocity

% Creating constants for velocity use
consts.pressATM = 84219.486;    % Pa
consts.pressATMErr = 50;        % Pa

consts.tempATM = 295.15;        % K
consts.tempATMErr = 0.05;       % K

consts.rConst = 287;            % J / kg * K
consts.rhoConst = (consts.rConst * consts.tempATM) ...
    / consts.pressATM;          % 1 / m^3

% Calculating velocity vector
data.velocities = sqrt(2 .* data.pressures .* consts.rhoConst);

%% Plotting Velocities over Time
figure();
plot(data.times, data.velocities);
xlabel("Time (s)");
ylabel("Airspeed (m/s)");
title("Airspeed in wind tunnel over time");