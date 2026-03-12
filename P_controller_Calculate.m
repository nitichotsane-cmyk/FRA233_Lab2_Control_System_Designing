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

%% --- ให้ Parameter จากรูป ---
ke = 52.8e-3;
kt = 50.6e-3;
Lm = 2.8445e-3;
R = 3.18;
b = 77.581e-6;
J = 58.559e-6;

%% --- 1. ใส่ Requirements ที่ต้องการตรงนี้ ---
OS_req = 10;    % %OS: Percent Overshoot สูงสุดที่รับได้ (เช่น 10%)
Tp_req = 3;   % Tp: Peak time สูงสุดที่รับได้ในหน่วยวินาที (เช่น 0.1 วิ)

%% --- 2. คำนวณค่าคงที่ A และ B ตามสมการลักษณะเฉพาะ ---
% สมการคือ A*s^2 + B*s + kt*kp = 0
A = R*J + Lm*b + mp*(L^2)*R;
B = ke*kt + R*b;

%% --- 3. คำนวณช่วงของ kp ---
% คำนวณ Damping Ratio (Zeta) ที่ต้องการจาก %OS
zeta_req = -log(OS_req/100) / sqrt(pi^2 + log(OS_req/100)^2);

% ขอบเขตบน (Max kp) คำนวณจากเงื่อนไข Overshoot
kp_max = (B^2) / (4 * A * kt * zeta_req^2);

% ขอบเขตล่าง (Min kp) คำนวณจากเงื่อนไข Peak Time
kp_min = (A / kt) * ( (pi / Tp_req)^2 + (B^2) / (4 * A^2) );

%% --- 4. แสดงผลลัพธ์ (Display Results) ---
clc;
fprintf('--- Required Specifications ---\n');
fprintf('Max Overshoot : <= %.2f %%\n', OS_req);
fprintf('Max Peak Time : <= %.4f sec\n\n', Tp_req);

fprintf('--- kp Range Results ---\n');
fprintf('Minimum kp (from Tp) : %.4f\n', kp_min);
fprintf('Maximum kp (from OS) : %.4f\n\n', kp_max);

% เช็คว่าช่วงที่คำนวณมาเป็นไปได้จริงหรือไม่
if kp_min <= kp_max
    fprintf('>> Valid range for kp is: [ %.4f , %.4f ] <<\n', kp_min, kp_max);
else
    fprintf('>> WARNING: สเปคที่ตั้งไว้เป็นไปไม่ได้! <<\n');
    fprintf('เนื่องจาก kp_min มีค่ามากกว่า kp_max\n');
    fprintf('การใช้แค่ Proportional Control (kp) อย่างเดียว ไม่สามารถตอบสนองเงื่อนไขทั้งสองอย่างพร้อมกันได้\n');
    fprintf('คุณจำเป็นต้องเปลี่ยนสเปคให้ผ่อนปรนขึ้น หรือเปลี่ยนไปใช้ PD Controller ครับ\n');
end