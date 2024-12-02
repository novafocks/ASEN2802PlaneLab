% Third time's the charm. :(

%% Clear Workspace

clear; clc; close all;

%% 5.5.2 - Import Port Locations

% Port position data
raw.ports = readmatrix("ClarkY14_PortLocations.xlsx");

% NACA coefficient data
raw.naca = readmatrix("ClarkY14_NACA_TR628.xlsx");


%% 5.5.3 - Import Development Data

% Name of file
name = "ASEN2802_InfiniteWing_FullRange.csv";

% Raw pressures
raw.collected = readmatrix(name);

%% test

const = getConst(raw);

coef_p = coef_pressure_calculator(name, 1, 2, raw.ports);

%% 5.5.4 - Calculating C_P around airfoil for 1 AoA

function coef_pressure = coef_pressure_calculator(filename, aoa, const, ports)
    dev_data = readmatrix("ASEN2802_InfiniteWing_FullRange.csv");

    pressure_matrix = dev_data(:, 15:end);
    q_inf = dev_data(:, 5);

    [m_rows, m_cols] = size(pressure_matrix);

    coef_pressure = zeros(m_rows, m_cols);

    for i = 1 : m_cols

        % Pressure matrix divided by dynamic pressure
        coef_pressure(:, i) = pressure_matrix(:, i) ./ q_inf;

    end
end


function const = getConst(raw)
    
    %%% COLLECTED %%%
    
    % Pressure matrix
    const.c.p_M = raw.collected(:, 15:end);
    
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
    
    % UNIQUE angles of attack
    const.c.unique_aoa = unique(const.c.aoa);
    
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
    
    % Modified for plotting with coef at AoA = 9
    const.p.y_mod = const.p.y;
    const.p.y_mod(end + 1) = 0;
    
    % Z-POSITION
    const.p.z            = raw.ports(:, 4);
    const.p.z_ports      = const.p.z(~isnan(const.p.num));
    
    %%% NACA %%%
    
    % Angle of attack
    const.n.aoa = raw.naca(:, 1);
    
    % Coefficient of lift
    const.n.coefL = raw.naca(:, 2);
    
    % Coefficient of drag
    const.n.coefD = raw.naca(:, 3);
end