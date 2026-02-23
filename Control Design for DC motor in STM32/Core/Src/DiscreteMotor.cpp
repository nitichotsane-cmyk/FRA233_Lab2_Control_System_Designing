#include "DiscreteMotor.h"

// Constructor: รับค่าพารามิเตอร์ทางฟิสิกส์ แล้วแปลงเป็นสัมประสิทธิ์
DiscreteMotor::DiscreteMotor(float n, float Ke, float J, float L, float b, float Rm, float Ts) {

    // 1. แปลงพารามิเตอร์ทางฟิสิกส์ เป็นกลุ่มตัวแปร A, B, C, K
    float K_val = n * Ke;
    float A = J * L;
    float B = (L * b) + (Rm * J);
    float C = (Rm * b) + (n * Ke * Ke);

    float Ts2 = Ts * Ts; // คาบเวลาสุ่มกำลังสอง

    // 2. คำนวณสัมประสิทธิ์ Forward
    fwd_cw1 = (2.0f * A - B * Ts) / A;
    fwd_cw2 = -(A - B * Ts + C * Ts2) / A;
    fwd_cv2 = (K_val * Ts2) / A;

    // 3. คำนวณสัมประสิทธิ์ Backward
    float bwd_den = A + B * Ts + C * Ts2;
    bwd_cw1 = (2.0f * A + B * Ts) / bwd_den;
    bwd_cw2 = -A / bwd_den;
    bwd_cv0 = (K_val * Ts2) / bwd_den;

    // 4. คำนวณสัมประสิทธิ์ Tustin
    float tus_den = 4.0f * A + 2.0f * B * Ts + C * Ts2;
    tus_cw1 = (8.0f * A - 2.0f * C * Ts2) / tus_den;
    tus_cw2 = -(4.0f * A - 2.0f * B * Ts + C * Ts2) / tus_den;
    tus_cv  = (K_val * Ts2) / tus_den;

    resetStates();
}

void DiscreteMotor::resetStates() {
    w1 = 0.0f; w2 = 0.0f;
    v1 = 0.0f; v2 = 0.0f;
}

// ==========================================
// ฟังก์ชัน Update ยังคงเหมือนเดิมครับ
// ==========================================

float DiscreteMotor::updateForward(float v_in) {
    float w_out = (fwd_cw1 * w1) + (fwd_cw2 * w2) + (fwd_cv2 * v2);
    w2 = w1;     w1 = w_out;
    v2 = v1;     v1 = v_in;
    return w_out;
}

float DiscreteMotor::updateBackward(float v_in) {
    float w_out = (bwd_cw1 * w1) + (bwd_cw2 * w2) + (bwd_cv0 * v_in);
    w2 = w1;     w1 = w_out;
    v2 = v1;     v1 = v_in;
    return w_out;
}

float DiscreteMotor::updateTustin(float v_in) {
    float w_out = (tus_cw1 * w1) + (tus_cw2 * w2) + tus_cv * (v_in + 2.0f * v1 + v2);
    w2 = w1;     w1 = w_out;
    v2 = v1;     v1 = v_in;
    return w_out;
}
