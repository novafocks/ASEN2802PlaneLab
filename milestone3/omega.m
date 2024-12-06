%% PROPERTY OF ASEN 2802 GROUP WHATEVER

%% Clear Workspace

clear; clc; close all;

%% Going in for extraction

% Raw pressures
raw.collected = readmatrix("FullSpanTest.csv");

% Port position data
raw.ports = readmatrix("ClarkY14_PortLocations.xlsx");

% ---

% Spanwise positions AND vector of UNIQUE spanwise positions
const.c.spanwise_positions = raw.collected(:, 9);
const.c.axis_cp = unique(const.c.spanwise_positions);

% Pressure matrix
const.c.p_M = raw.collected(:, 15:end-1);

% Atmospheric pressure
const.c.pressure_atm = raw.collected(:, 2);

% Density
const.c.rho = raw.collected(:, 3);

% Airspeed
const.c.airspeed = raw.collected(:, 4);

% Dynamic pressure
const.c.q_inf = raw.collected(:, 5);

% Angles of attack
const.c.aoa = raw.collected(:, 8);

% Number of ports
const.c.num_ports = 16;

%%% PORTS %%%

% NUMBER %
const.p.num          = raw.ports(:, 1);
const.p.num_ports    = const.p.num(~isnan(const.p.num));

% X-POSITION %
const.p.x            = raw.ports(:, 2);
const.p.x_ports      = const.p.x(~isnan(const.p.num));

% Y-POSITION %
const.p.y            = raw.ports(:, 3);
const.p.y_ports      = const.p.y(~isnan(const.p.num));

% Chord length definition
const.c.cord_length = max(const.p.y);

% Z-POSITION
const.p.z            = raw.ports(:, 4);
const.p.z_ports      = const.p.z(~isnan(const.p.num));

%% Calculating coefficient of presshdfs

for i = 1 : length(const.c.axis_cp)
    coef.pressure(i, :) = c_P_calc(const.c.axis_cp(i), const);
end

%% Step 3 - Calculating C_L and C_D

for i = 1 : length(const.c.axis_cp)
    % Defining current angle of attack and pressures
    misc.curr_pos       = const.c.axis_cp(i);
    misc.curr_pressure  = c_P_calc(misc.curr_pos, const);

    % Calculating coefficient of normal and axial force
    coef.normal() = - (1 / const.c.cord_length) * trapz(const.p.y, misc.curr_pressure);
    coef.axial(i) = (1 / const.c.cord_length) * trapz(const.p.z, misc.curr_pressure);

    % Calculating coefficients of lift and drag
    coef.lift(i) = (coef.normal(i) * cosd(misc.curr_pos)) ...
                    - (coef.axial(i) * sind(misc.curr_pos));
    coef.drag(i) = (coef.normal(i) * sind(misc.curr_pos)) ...
                    + (coef.axial(i) * cosd(misc.curr_pos));
end

clear i;

%% Appendix - C_P Function

function c_P = c_P_calc(pos, const)

    % Making new matrix of correct size
    [misc.p_M_rows, misc.p_M_cols] = size(const.c.p_M);
    coef.pressure_full = zeros([misc.p_M_rows misc.p_M_cols]);
    
    % Calculating each value of coefficients of pressure
    for i = 1 : misc.p_M_cols
    
        % Pressure matrix divided by dynamic pressure
        coef.pressure_full(:, i) = const.c.p_M(:, i) ./ ...
                                    (const.c.q_inf);
    
    end

    % Create matrix of coefficients of pressure
    coef.pressure = zeros([length(const.c.axis_cp) const.c.num_ports]);
    
    % Calculate coefficients of pressure
    for i = 1 : length(const.c.axis_cp)
    
        % Get the indices where the angle of attack matches the current angle
        idx = (const.c.spanwise_positions == const.c.axis_cp(i));
        
        % Average the pressure data for those indices
        coef.pressure(i, :) = mean(coef.pressure_full(idx, :), 1);
    
    end

    % Take coefficients of pressure for ports with specific AoA
    coef.pressure_pos = coef.pressure(const.c.axis_cp == pos, :);

    % Linear fit of pressure from ports 8 to 9 for estimation
    linfit.port8to9_slope       = (coef.pressure_pos(9) - coef.pressure_pos(8)) / ...
                                    (const.p.y_ports(9) - const.p.y_ports(8));
    linfit.port8to9_intercept   = coef.pressure_pos(8) - (linfit.port8to9_slope * const.p.y_ports(8));

    % Linear fit of pressure from ports 10 to 11 for estimation
    linfit.port10to11_slope     = (coef.pressure_pos(11) - coef.pressure_pos(10)) / ...
                                    (const.p.y_ports(11) - const.p.y_ports(10));
    linfit.port10to11_intercept = coef.pressure_pos(10) - (linfit.port10to11_slope * const.p.y_ports(10));

    
    linfit.port8to9_estimation      = linfit.port8to9_intercept + ...
                                    (linfit.port8to9_slope * const.c.cord_length);

    linfit.port10to11_estimation    = linfit.port10to11_intercept + ...
                                    (linfit.port10to11_slope * const.c.cord_length);

    % Calculating pressure at trailing edge using estimations
    const.c.p_TE                    = mean([linfit.port8to9_estimation, ...
                                            linfit.port10to11_estimation]);

    coef.pressure_aoa_wTE           = [coef.pressure_pos(1:9) ...
                                        const.c.p_TE ...
                                        coef.pressure_pos(10:end)];

    c_P = coef.pressure_aoa_wTE;
end