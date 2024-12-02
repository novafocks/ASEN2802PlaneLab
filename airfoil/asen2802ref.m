clear;
clc;
close all;
data = readmatrix('ASEN2802_InfiniteWing_FullRange.csv');
time = data(2:end,1);
pressure = data(2:end,2);
critTime = 5633.4;

%% Bernoulli’s Equation
R_air = 287; % J/kgK
T_atm = 295.15; % K
errorT = 0.05; % K
P_atm = 84558.125; % Pa
errorP = 50; % Pa
errorDeltaP = 49.76; % Pa
rho = P_atm/(R_air)*(T_atm); % kg/m^3
% Calculating velocity
for i = 1:length(pressure)
velocity(i) = sqrt(abs((pressure(i)))/((0.5)*rho));
end
% Find maximum velocity
maxV = max(velocity);
% Plot max velocity and corresponding error
figure();
plot(time,velocity);
xlabel('Time (s)');
ylabel('Velocity (m/s)');
title('Velocity versus Time');

%% Calculating Error in airspeed
% Partial derivatives
partial_deltaPressure = sqrt(2)*sqrt(R_air*T_atm*(abs(pressure)/P_atm))/(2*pressure);
partial_Tatm = sqrt(2)*sqrt(R_air*T_atm*(abs(pressure)/P_atm))/(2*T_atm);
partial_Patm = sqrt(2)*sqrt(R_air*T_atm*(abs(pressure)/P_atm))/(2*P_atm);
% Calculating error in max airspeed
errorAirspeed = sqrt((partial_deltaPressure*errorDeltaP).^2+(partial_Patm*errorP).^2+(partial_Tatm*errorT).^2);
errorMaxAirspeed = errorAirspeed(find(velocity == maxV));
errorMaxAirspeed = errorMaxAirspeed(1);

%% Calculating CP
% Reading in Port Locations
cleanData = readmatrix('ClarkY14_PortLocations.xlsx');
% Creating plot of airfoil
figure();
plot(cleanData(:,3),cleanData(:,4),'o-','LineWidth',1.5)
xlabel('Y axis (in)');
ylabel('z axis (in)');
title('Clark Y-14 Airfoil');
grid on;
axis equal;
% Reading in Full Dataset
fulldata = readmatrix('ASEN2802_InfiniteWing_FullRange.csv');
v_inf = mean(fulldata(:, 4));
rho_inf = mean(fulldata(:, 3));
q_inf = mean(fulldata(:, 5));
% Reading in all scan data
scanData = fulldata(:,15:end);
rowsPerBlock = 20;
numPorts = size(scanData, 2);
numAngles = floor(size(scanData, 1) / rowsPerBlock);
% Preallocating vector for the mean
meanValues = zeros(numAngles, numPorts);
block = cell(numAngles, 1);
%meanValues = cell(numAngles,1);
% Loop through each angle of attack
for i = 1:numAngles
% Extract the block of rows for the current angle of attack
startRow = (i - 1) * rowsPerBlock + 1;
endRow = i * rowsPerBlock;
block{i} = scanData(startRow:endRow, :);
% Compute the mean for each column (pressure port)
meanValues(i,:) = mean(block{i}, 1);
end
Cp_all = meanValues./ q_inf;
% Calculating Cps for all AoA
%Cp_all(i) = meanValues./ q_inf;
% Plotting CP for all Cp
figure();
plot(cleanData(1:16,3),Cp_all);
xlabel('Port Positions (in)');
ylabel('All Cp Values');
title('Cp Values of 16 Ports for all Angles of Attack');
% Setting chord length
chordLength = 10;
% Interpolating current data to find missing tailend Cp
CpUpper_all = interp1(cleanData(8:9,3),Cp_all(8:9),cleanData(10,3),"spline");
CpLower_all = interp1(cleanData(11:12,3),Cp_all(11:12),cleanData(10,3),"spline");
CpTailEnd_all = (CpUpper_all+CpLower_all)/2;
Cp_all = cat(2,Cp_all(1:9),CpTailEnd_all,Cp_all(10:end));
% Calculating Cn and Ca using trapz function
for i = 1:513
thinglength = length(cleanData(:, 3));
Cp_all_i = zeros(thinglength, 1) + Cp_all(i);

Cn_all(i) = -1/chordLength*trapz(cleanData(:,3),Cp_all_i);
Ca_all(i) = 1/chordLength*trapz(cleanData(:,4),Cp_all_i);
% Calculating Cl
Cl_all(i) = Cn_all(i)*cosd(10)-Ca_all(i)*sind(10);
% Calculating Cd
Cd_all(i) = Cn_all(i)*sind(10)+Ca_all(i)*cosd(10);
end
% Function to calculate Cp
c_p_all =@(p,p_inf,rho_inf,v_inf) (p - p_inf)/(.5*rho_inf*v_inf^2);
% Reading data for angle of attack = 10
angleTenCps = fulldata(502:521,15:30);
for i = 1:16
scandi(i) = mean(angleTenCps(:,i));
end
% Calculating Cps for all AoA
%Cp = meanValues./ q_inf;
% Calculating Cp for angle of attack = 10
Cps = scandi./q_inf;
% Plotting CP curve for angle of attack = 10
figure();
plot(cleanData(1:16,3),Cps);
xlabel('Port Positions (in)');
ylabel('Cp Values');
title('Cp Values of 16 ports for anlge of attack 10');
% Setting chord length
chordLength = 10;
% Interpolating current data to find missing tailend Cp
CpUpper = interp1(cleanData(8:9,3),Cps(8:9),cleanData(10,3),"spline");
CpLower = interp1(cleanData(11:12,3),Cps(11:12),cleanData(10,3),"spline");
CpTailEnd = (CpUpper+CpLower)/2;
Cps = cat(2,Cps(1:9),CpTailEnd,Cps(10:end));
% Calculating Cn and Ca using trapz function
Cn = -1/chordLength*trapz(cleanData(:,3),Cps);
Ca = 1/chordLength*trapz(cleanData(:,4),Cps);
% Calculating Cl
Cl = Cn*cosd(10)-Ca*sind(10);
% Calculating Cd
Cd = Cn*sind(10)+Ca*cosd(10);
% Function to calculate Cp
c_p =@(p,p_inf,rho_inf,v_inf) (p - p_inf)/(.5*rho_inf*v_inf^2);