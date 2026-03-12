%transfer function of plant
Gp = tf([kt], ...
    [mp*L*L*Lm+Lm*J, ...
    R*J+Lm*b+mp*L*L*R, ...
    ke*kt+R*b, ...
    0])
p_Gp = pole(Gp)
Z_Gp = zero(Gp)
% rlocus(Gp)

%requirment
PO = 5;
Ts = 2.5;
Abs_Error = 4*10^-3;

%req para
zeta = ((log(5/100)^2)/(log(5/100)^2+pi^2))^(1/2);
sig = 4/Ts;
wd = sig*tan(acos(zeta));

s12_ng = -sig - wd*j;
s12_po = -sig + wd*j;

%Step1 PID Cal
phi_p1 = 180 - atand(wd/(sig-p_Gp(1)));
phi_p2 = atand(wd/(sig-p_Gp(2)));
phi_p3 = 180 - atand(wd/(sig-p_Gp(3)));
phi_pPI = 180 - atand(wd/(sig-0));
phi_zPI = -180+phi_p1+phi_p2+phi_p3+phi_pPI

zPI = sig - wd/tand(-(phi_zPI-180))

Kc_PI = -tf([1 0],[1,zPI])*Gp^-1
mag_at_sd = abs(evalfr(tf([1,zPI],[1 0])* Gp, s12_ng));
Kc = 1/mag_at_sd

Gpi = Kc*tf([1 zPI],[1 0])

% ไม่สามารถเป็นตาม requirment

% rlocus(Gpi*Gp)