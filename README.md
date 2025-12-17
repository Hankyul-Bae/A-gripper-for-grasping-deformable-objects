# A-gripper-for-grasping-deformable-objects
A gripper for grasping deformable objects based on the prediction of grip status via force sensing linear potentiometer

This repository provides the MATLAB and Arduino codes used in the experiments for deformation-aware grasping of deformable objects.

The control framework consists of three sequential steps.
For each step, the corresponding Arduino code should be uploaded first, followed by execution of the matching MATLAB script.

**Files**
**MATLAB**

step1_adjusting_posture.m

step2_1_slip_detection.m

step2_2_deformation_prediction.m

**Arduino**

step1_motors_operate_and_stop_if_signal.ino

step2_1_motors_stop_and_operate_if_signal.ino

step2_2_motors_operate_and_stop_if_signal.ino

**Usage**

Upload the Arduino code corresponding to the desired step.

Run the matching MATLAB script.

Repeat the process for each step in order (Step 1 → Step 2-1 → Step 2-2).

**Notes**

Serial communication parameters (e.g., COM ports) may need to be adjusted depending on the system.

Hardware-specific settings are omitted for clarity.
