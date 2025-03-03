%% This the script for part 2
% Initialise variables
clear
max_torque = 190; %Nm
max_engine_revs = 420; %rad/s
beta = 0.4; 
mass = 1000; %kg
gravity = 9.81; %m/s^2
air_density = 1.225; %kg/m^3
drag_coefficient = 0.32;
rolling_coefficient = 0.01;
area = 2.4; %m^2
alpha_n_array = [10 12 16 25 40]; %/m
gradient = deg2rad(0); %degrees
% Sim settings
initial_speed = 0; %m/s
max_speed = 30; %m/s
zero_to_sixty = 8.7; %seconds
linear_slope = (max_speed - initial_speed) / zero_to_sixty; %mph/s
% PI settings
Kp_m2 = 0.5;
Ki_m2 = 0.1;
% Run sim and collect data
%simout_v = zeros(500,5);
%simout_z = zeros(500,5);

%for i = 1:length(alpha_n_array)
    alpha_n = alpha_n_array(5)
    out = sim("part2_project_file.slx");
    %info = stepinfo(out.simout_2.data);
    simout_v(1:out.simout_v.Length,1) = out.simout_v.Data
    simout_z(1:out.simout_z.Length,1) = out.simout_z.Data
%end
% figure()
% hold on
% plot(simout_z(:,1),simout_v(:,1))
% plot(simout_z(:,2),simout_v(:,2))
% plot(simout_z(:,3),simout_v(:,3))
% plot(simout_z(:,4),simout_v(:,4))
% plot(simout_z(:,5),simout_v(:,5))
% hold off