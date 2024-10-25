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

%% Pressure Stats

stats.pressStd = std(data.pressures);
stats.pressAvg = mean(data.pressures);

%% Plot Data over Time

figure();
hold on;

% Data points/lines
plot(data.times, data.pressures);
yline(stats.pressAvg, LineWidth=2, Alpha=1.0);

% Figure labels
xlabel("Time (s)");
ylabel("Relative pressure (Pa)");
title("Relative pressure in wind tunnel over time");
legend("Pressure over time", "Mean pressure")

hold off;

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

%% Airspeed Stats

stats.velocitiesMax = max(data.velocities);
stats.velocitiesAvg = mean(data.velocities);

%% Calculating Error

consts.partialConst = sqrt((consts.rConst * consts.tempATM ...
    .* data.pressures) / consts.pressATM) / sqrt(2);

% Partial with pressures
partials(:, 1) = consts.partialConst ./ data.pressures;

% Partial with atmospheric temperature
partials(:, 2) = consts.partialConst / consts.tempATM;

% Partial with atmospheric pressure
partials(:, 3) = consts.partialConst / consts.pressATM;

errors = [stats.pressStd consts.tempATMErr consts.pressATMErr];

stats.velocityErr = transpose(calculateError(partials, errors));

%% Plotting Velocities over Time

figure();
hold on;

% Data points/lines
plot(data.times, data.velocities);
yline(stats.velocitiesAvg, LineWidth=2, Alpha=1.0);
plot(data.times, stats.velocitiesAvg + stats.velocityErr, '--r');
plot(data.times, stats.velocitiesAvg - stats.velocityErr, '--r');

% Figure labels
xlabel("Time (s)");
ylabel("Airspeed (m/s)");
title("Airspeed in wind tunnel over time");
legend("Airspeed over time", "Mean airspeed", "", "Mean airspeed \pm \sigma");

hold off;

%% Function

function error = calculateError(partials, errors)
    partErr = (partials .* errors) .^ 2;
    
    % WARNING: DOESN'T WORK PROPERLY WHEN # VARIABLES BELOW # POINTS
    for i = 1:length(partErr)
        error(i) = sqrt(sum(partErr(i, :)));
    end
end