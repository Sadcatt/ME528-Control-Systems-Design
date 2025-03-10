clc
clear
% variable_name = sim("file_name")
gravitational_acceleration = 9.81; %m/s^2
gradient = 0; %degrees
initial_speed = 0; %m/s
max_speed = 30; %m/s
zero_to_sixty = 8.7; %seconds
linear_slope = (26.82) / zero_to_sixty; %m/s
Kp_m = 1.81;
Ki_m = 1.47;
Kd_m = 0;
alpha_n = 16;
max_torque = 190; %Nm
max_engine_revs = 420; %rad/s
beta = 0.4; 
mass = 1000; %kg
air_density = 1.225; %kg/m^3
drag_coefficient = 0.32;
rolling_coefficient = 0.01;
area = 2.4; %m^2
gravity = 9.81;
Kp_m2 = 0.5;
Ki_m2 = 0.1;
Kv_m2 = 0.1;
Kd_m2 = 0.1;


%% gradient sweep funciton
gradient_array = linspace(-20,20,11);
figure()
hold on
grid on
grid minor
xlabel('Time [s]')
ylabel('Velocity [m/s]')
yline(max_speed)
%legend('Velocity Set Point', '- 20 deg', '- 16 deg', '- 12 deg', '- 8 deg', '- 4 deg', ' 0 deg', ' 4 deg', ' 8 deg', ' 12 deg', ' 16 deg', ' 20 deg','Location','east','Orientation','veritcal')
for i = 1:length(gradient_array)
    gradient = gradient_array(i);
    out = sim("part2B_project_file.slx");
    time = out.tout;
    velocity = out.simout_2.Data;
    plot(time, velocity)
    %gtheta = deg2rad(gradient)*gravitational_acceleration;
    %sys = tf([Kd_m Kp_m-gtheta Ki_m],[1+Kd_m 0.02+Kp_m-gtheta Ki_m]);
    %margin(sys)
    %rlocus(sys)
end
%legend(gradient_array)
hold off
gradient = 0;
i = 1;

figure()
hold on
grid on
grid minor
xlabel('Time [s]')
ylabel('Error Integral [m]')
alpha_n_array = [10 12 16 25];
for i = 1:length(alpha_n_array)
alpha_n = alpha_n_array(i);
out = sim("part2B_project_file.slx");
time = out.tout;
Z = out.simout_z.Data;
plot(time,Z)
end
hold off

figure()
hold on
grid on
grid minor
xlabel('Time [s]')
ylabel('Velocity [m/s]')
i=1;
for i = 1:length(alpha_n_array)
alpha_n = alpha_n_array(i);
out = sim("part2B_project_file.slx");
time = out.tout;
V = out.simout_v.Data;
plot(time,V)
end
hold off

figure()
hold on
grid on
grid minor
xlabel('Velocity [m/s]')
ylabel('Error Integral [m]')
%legend('10','12','16','25','40','Orientation','vertical')
i=1;
for i = 1:length(alpha_n_array)
alpha_n = alpha_n_array(i);
out = sim("part2B_project_file.slx");
V = out.simout_v.Data;
Z = out.simout_z.Data;
plot(V,Z)
end
%% 
