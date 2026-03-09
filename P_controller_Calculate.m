function status = Check_overshoot(PO,zeta)
    Overshoot = 100*exp((-zeta*pi)/((1-zeta^2)^(1/2)));
    if Overshoot <= PO && isreal(PO) == true
        status = 1;
    else
        status = 0;
    end
end

function status = Check_Peaktime(tp,zeta,wn)
    Peak_time = pi / (wn * sqrt(1 - zeta^2));
    if Peak_time <= tp && isreal(Peak_time) == true
        status = 1;
    else
        status = 0;
    end
end

function status = Check_routh_hurwitz(zeta,wn)
    a = 1;
    b = 2*zeta*wn;
    c = wn^2;
    if a<0 || b<0 || c<0
        status = 0;
    else
        status = 1;
    end
end

kp_correct = [];
for kp = linspace(0,0.1,10000)
    wn = ((kt*kp)/(R*J+Lm*b+mp*L^2*R))^(1/2);
    zeta = ((ke*kt+R*b)/(R*J+Lm*b+mp*L^2*R))/(2*wn);
    x = Check_Peaktime(3,zeta,wn);
    y = Check_overshoot(10,zeta);
    z = Check_routh_hurwitz(zeta,wn);
    % fprintf('%d,%d,%d,%f\n',x,y,z,kp);
    if x == 1 && y == 1 && z == 1
        kp_correct = [kp_correct, kp];
    end
end
fprintf('Allowable Kp %f - %f\n',kp_correct(1),kp_correct(end));

