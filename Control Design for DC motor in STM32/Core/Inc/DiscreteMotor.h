/*
 * DiscreteMotor.h
 *
 *  Created on: Feb 24, 2026
 *      Author: nitic
 */
#ifndef DISCRETE_MOTOR_H
#define DISCRETE_MOTOR_H

class DiscreteMotor {
private:
    // --- สัมประสิทธิ์สำหรับวิธี Forward ---
    float fwd_cw1, fwd_cw2, fwd_cv2;

    // --- สัมประสิทธิ์สำหรับวิธี Backward ---
    float bwd_cw1, bwd_cw2, bwd_cv0;

    // --- สัมประสิทธิ์สำหรับวิธี Tustin ---
    float tus_cw1, tus_cw2, tus_cv;

    // --- ตัวแปรเก็บสถานะย้อนหลัง (State Variables) ---
    float w1, w2;
    float v1, v2;

public:
    // Constructor แบบรับพารามิเตอร์ทางฟิสิกส์ของมอเตอร์โดยตรง
    DiscreteMotor(float n, float Ke, float J, float L, float b, float Rm, float Ts);

    void resetStates();

    float updateForward(float v_in);
    float updateBackward(float v_in);
    float updateTustin(float v_in);
};

#endif
