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
zeta = ((log(PO/100)^2)/(log(PO/100)^2+pi^2))^(1/2)
sig = 4/Ts;
wd = sig*tan(acos(zeta));

s12_ng = -sig - wd*j;
s12_po = -sig + wd*j;

%Step1 PID Cal
phi_p1 = 180 - atand(wd/(sig-p_Gp(1)));
phi_p2 = atand(wd/(sig-p_Gp(2)));
phi_p3 = 180 - atand(wd/(sig-p_Gp(3)));
phi_pPI = 180 - atand(wd/(sig-0));
phi_zPD_PD = -180+phi_p1+phi_p2+phi_p3+phi_pPI;

%Step2 PD Cal
phi_zPD = -180+phi_p1+phi_p2+phi_p3;
ZPD = wd/tand(phi_zPD)+sig;

Kc_PD = -tf([1],[1,ZPD])*Gp^-1;
mag_at_sd = abs(evalfr(tf([1,ZPD],1)* Gp, s12_ng));
Kc = 1/mag_at_sd;
%Timeline การเเก้ Parameter
Kc
ZPD
Gpd = Kc*tf([1,ZPD],1)

Gpi = tf([1 0.01],[1 0])

Gpid = Gpd*Gpi

ZPD = 2
% ZPD = 1.5
% Kc = 1
Gpd = Kc*tf([1,ZPD],1)

Gpi = tf([1 0.01],[1 0])

Gpid = Gpd*Gpi

% rlocus(Gpid*Gp)