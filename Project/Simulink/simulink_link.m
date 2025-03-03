% Intialise Simulink Vairables
clc
clear
% variable_name = sim("file_name")
gravitational_acceleration = 9.81; %m/s^2
gradient = 0; %degrees
initial_speed = 0; %m/s
max_speed = 30; %m/s
zero_to_sixty = 8.7; %seconds
linear_slope = (max_speed - initial_speed) / zero_to_sixty; %mph/s
sim_setting = 1;
%% Loop method to find the "best" PID or potentially a bunch that might work
if sim_setting == 1
    tic
    % Initial values for coefficients
    initial_Kp_m = 0;
    initial_Ki_m = 0;
    initial_Kd_m = 0;
    % Final values for coefficients
    f_Kp_m = 3;
    f_Ki_m = 2;
    f_Kd_m = 0;
    % Step values for coeffients
    step_Kp_m = 0.05;
    step_Ki_m = 0.05;
    step_Kd_m = 0;
    % Determine number of timesteps
    number_iterations_Kp_m = ceil(f_Kp_m - initial_Kp_m) / step_Kp_m;
    number_iterations_Ki_m = ceil(f_Ki_m - initial_Ki_m) / step_Ki_m;
    if (f_Kd_m - initial_Kd_m) == 0
        number_iterations_Kd_m = 1;
    else
        number_iterations_Kd_m = (f_Kd_m - initial_Kd_m) / step_Kd_m;
    end
    % Time warning
    total_iterations = number_iterations_Kp_m * number_iterations_Ki_m * number_iterations_Kd_m;
    time_seconds = number_iterations_Kp_m * number_iterations_Ki_m * number_iterations_Kd_m * 0.25;
    time_minutes = time_seconds / 60;
    time_hours = time_minutes / 60;
    T = datetime("now");
    disp("Start time:")
    disp(T(1))
    disp("Caution: Sim will *roughly take:") 
    disp(time_minutes + " minutes")
    disp(time_hours + " hours")
    disp(total_iterations + " iterations total")
    % Initialise storage matrices if needed
    storage_option = 1;
    if storage_option == 1
        RiseTime_analysis = zeros(number_iterations_Kp_m,number_iterations_Ki_m,number_iterations_Kd_m);
        TransientTime_analysis = zeros(number_iterations_Kp_m,number_iterations_Ki_m,number_iterations_Kd_m);
        SettlingTime_analysis = zeros(number_iterations_Kp_m,number_iterations_Ki_m,number_iterations_Kd_m);
        SettlingMin_analysis = zeros(number_iterations_Kp_m,number_iterations_Ki_m,number_iterations_Kd_m);
        SettlingMax_analysis = zeros(number_iterations_Kp_m,number_iterations_Ki_m,number_iterations_Kd_m);
        Overshoot_analysis = zeros(number_iterations_Kp_m,number_iterations_Ki_m,number_iterations_Kd_m);
        Undershoot_analysis = zeros(number_iterations_Kp_m,number_iterations_Ki_m,number_iterations_Kd_m);
        Peak_analysis = zeros(number_iterations_Kp_m,number_iterations_Ki_m,number_iterations_Kd_m);
        PeakTime_analysis = zeros(number_iterations_Kp_m,number_iterations_Ki_m,number_iterations_Kd_m);
        damping_coefficient_analysis = zeros(number_iterations_Kp_m,number_iterations_Ki_m,number_iterations_Kd_m);
    end
    PID_analysis = zeros(1,12);
    % Initialise for loops
    Kp_m = initial_Kp_m;
    Ki_m = initial_Ki_m;
    Kd_m = initial_Kd_m;
    l = 1;
    disp("Loops Intialised")
    toc
    tic
    if storage_option == 1
        disp("Big data is taking over the world!")
        for k = 1:number_iterations_Kd_m
            %tic
            Kp_m = initial_Kp_m;
            for i = 1:number_iterations_Kp_m
                %tic
                Ki_m = initial_Ki_m;
                for j = 1:number_iterations_Ki_m
                    %tic
                    out = sim("project_file.slx");
                    info = stepinfo(out.simout.Data);
                    RiseTime_analysis(i,j,k) = info.RiseTime;
                    TransientTime_analysis(i,j,k) = info.TransientTime;
                    SettlingTime_analysis(i,j,k) = info.SettlingTime;
                    SettlingMin_analysis(i,j,k) = info.SettlingMin;
                    SettlingMax_analysis(i,j,k) = info.SettlingMax;
                    Overshoot_analysis(i,j,k) = info.Overshoot;
                    Undershoot_analysis(i,j,k) = info.Undershoot;
                    Peak_analysis(i,j,k) = info.Peak;
                    PeakTime_analysis(i,j,k) = info.PeakTime;
                    sys = tf([Kd_m Kp_m Ki_m],[(Kd_m + 1) (0.02 + Kp_m) Ki_m]);
                    [Wn,Z] = damp(sys);
                    Ki_m = Ki_m + step_Ki_m;
                    percent_overshoot = 100 * (info.Peak - max_speed)/max_speed;
                    if percent_overshoot < 4 && (info.Peak > max_speed) && Z(1) < 1 && Z(2) < 1%&& info.RiseTime > zero_to_sixty
                        PID_analysis(l,1) = Kp_m;
                        PID_analysis(l,2) = Ki_m;
                        PID_analysis(l,3) = Kd_m;
                        PID_analysis(l,4) = info.RiseTime;
                        PID_analysis(l,5) = info.TransientTime;
                        PID_analysis(l,6) = info.SettlingTime;
                        PID_analysis(l,7) = info.SettlingMin;
                        PID_analysis(l,8) = info.SettlingMax;
                        PID_analysis(l,9) = info.Overshoot;
                        PID_analysis(l,10) = info.Undershoot;
                        PID_analysis(l,11) = info.Peak;
                        PID_analysis(l,12) = info.PeakTime;
                        disp("l = " + l)
                        disp("Kp_m = " + Kp_m)
                        disp("Ki_m = " + Ki_m)
                        disp("Kd_m = " + Kd_m)
                        disp("%> = " + percent_overshoot)
                        disp("Z = " + Z)
                        l = l + 1;
                    end
                    %toc
                end
                %toc
                Kp_m = Kp_m + step_Kp_m;
            end
            %toc
            Kd_m = Kd_m + step_Kd_m;
        end
        toc
    end
    %%
    % Re do this part when a solid method is finalised, tbf you might not
    % even need to finish this off.
% elseif storage_option == 0
%     disp("Death to big data")
%     for k = 1:number_iterations_Kd_m
%         tic
%         Kp_m = initial_Kp_m;
%         for i = 1:number_iterations_Kp_m
%             tic
%             Ki_m = initial_Ki_m;
%             for j = 1:number_iterations_Ki_m
%                 tic
%                 out = sim("project_file.slx");
%                 info = stepinfo(out.simout.Data);
%                 Ki_m = Ki_m + step_Ki_m;
%                 if info.Overshoot < 4 && info.RiseTime > zero_to_sixty
%                     PID_analysis(l,1) = Kp_m;
%                     PID_analysis(l,2) = Ki_m;
%                     PID_analysis(l,3) = Kd_m;
%                     PID_analysis(l,4) = info.RiseTime;
%                     PID_analysis(l,5) = info.TransientTime;
%                     PID_analysis(l,6) = info.SettlingTime;
%                     PID_analysis(l,7) = info.SettlingMin;
%                     PID_analysis(l,8) = info.SettlingMax;
%                     PID_analysis(l,9) = info.Overshoot;
%                     PID_analysis(l,10) = info.Undershoot;
%                     PID_analysis(l,11) = info.Peak;
%                     PID_analysis(l,12) = info.PeakTime;
%                     l = l + 1;
%                 end
%                 toc
%             end
%             toc
%             Kp_m = Kp_m + step_Kp_m;
%         end
%         toc
%         Kd_m = Kd_m + step_Kd_m;
%     end
end
%% Determine candidates for acceptable PID combinations
% Conditions for PID being accpetable are based on output variables.
% Script sifts through all recorded PID combinations solved and checks at
% each stage if data is acceptable, if data is okay in all relevant cases
% then the PID combination is logged to matrix containing gains and stats.
% i = 1;
% j = 1;
% k = 1;
% for i = 1:number_iterations_Kd_m
%     for j = 1:number_iterations_Kp_m
%         for k = 1:number_iterations_Ki_m
%         end
%     end
% end
%damp







