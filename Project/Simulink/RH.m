%% Routh Hurwitz Array Coefficient Calculator
% Initialise PID gains
Kp = 1.81;
Ki = 1.47;
Kd = 0;
% Create transfer funtion and use to determine RH equation
sys = tf([Kd Kp-gtheta Ki],[(Kd + 1) (0.02 + Kp - gtheta) Ki])
denominator = [(Kd + 1) (0.02 + Kp - gtheta) Ki];
a0 = denominator(1);
a1 = denominator(2);
a2 = denominator(3);
a3 = 0;
b1 = (a1*a2 - a0*a3)/a1;
RH_array = [a0 a2;a1 a3;b1 0]
figure(1)
margin(sys)
figure(2)
rlocus(sys)