# **ME528-Control-Systems-Design**
## Coursework: Car cruise control project
This repo contains course notes for contorl modules at Strathclyde, as well as my personal submission to the Y5 cruise control assignment.
I encourage viewers to look around, glean what they can from the lessons I learned, however, plagiarise at your own risk. x

## Notes on lessons learned:

### Learn how to run a simulink model from within Matlab Script
This will just make things a lot faster in the long run, as well as this it will allow the second point to run a lot more smoothly.

### Gain Optimisation
This will save you hours of fucking around without a scientific backing, pick your output variables to be one or multiple of the rise time, settling time, overshoot, etc. and make a script that will do this for you in a fraction of the time.
I would reccommend either looking at the strath optimisation course or Matlab docs or wikipedia to find a decent optimisation method instead of just 3 nested for loops.
Something like the following will work, however it isn't as efficient.
```
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

```
### Noise
You can model noise as stacked sine functions and it adds a little bit of pizzaz.

### Leveraging Matlab
Theres a lot of evil transfer function and stability plot related things that you can get away with in the coursework by just using an in-built function, this doesn't help for the exam but this could result in an easier understanding of it.
