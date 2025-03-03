%% PID selection script for part 1
selected_for_testing = zeros(1,13);
j = 1;
l = 0;
for i = 1:size(PID_analysis,1)
    Kp = PID_analysis(i,1);
    Ki = PID_analysis(i,2);
    Kd = PID_analysis(i,3);
    sys = tf([Kd Kp Ki],[(Kd + 1) (0.02 + Kp) Ki]);
    [Wn,Z] = damp(sys);
    if Z(1) < 1 && Z(1) > 0.75
        selected_for_testing(j,1:12) = PID_analysis(i,:);
        selected_for_testing(j,13) = Z(1);
        j = j + 1;
        l = l + 1;
        disp(l)
    end
    %disp(i)
end