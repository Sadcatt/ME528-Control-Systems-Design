%% This the script for part 2
% Initialise variables
max_torque = 190; %Nm
max_engine_revs = 420; %rad/s
beta = 0.4; 
mass = 1000; %kg
gravity = 9.81; %m/s^2
air_density = 1.225; %kg/m^3
drag_coefficient = 0.32;
rolling_coefficient = 0.01;
area = 2.4; %m^2
alpha_n = 16; %/m
% Sim settings
initial_speed = 0; %mph
max_speed = 60; %mph
zero_to_sixty = 8.7; %seconds
% PI settings
Kp_m2 = 0.5;
Ki_m2 = 0.1;
Kv_m2 = 0.1;
Kd_m2 = 0.1;
% Run sim and collect data
out = sim("part2B_project_file.slx");
info = stepinfo(out.simout_2.data)