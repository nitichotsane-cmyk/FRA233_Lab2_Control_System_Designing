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
phi_zPD = -180+phi_p1+phi_p2+phi_p3

zPD = sig - wd/tand(-(phi_zPD-180))

Kc_PD = -tf([1],[1,zPD])*Gp^-1
mag_at_sd = abs(evalfr(tf([1,zPD],1)* Gp, s12_po));
Kc = 1/mag_at_sd

zPD
Kc
Gpd = Kc*tf([1 zPD],1)

zPD = 1.5
Gpd = Kc*tf([1 zPD],1)
% Calculate the closed-loop transfer function
Gcl = feedback(Gpd, Gpd)
rlocus(Gcl)
