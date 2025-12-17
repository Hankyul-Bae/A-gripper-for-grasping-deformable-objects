#include <AccelStepper.h>

AccelStepper stepper2(4, 8, 9, 10, 11); 
AccelStepper stepper3(4, 4, 5, 6, 7);   

bool runMotorRight = true;  
bool runMotorLeft  = true;  

void setup() {
  Serial.begin(9600);

  stepper2.setSpeed(-800); 
  stepper3.setSpeed(-800); 
}

void loop() {
  if (Serial.available() > 0) {
    char command = Serial.read();

    if (command == 'A') {      
      runMotorRight = false;
    } else if (command == 'B') {   
      runMotorLeft = false;
    } else if (command == 'S') {   
      runMotorRight = false;
      runMotorLeft  = false;
    } else if (command == 'R') {  
      runMotorRight = true;
      runMotorLeft  = true;
    }
  }

  if (runMotorRight) stepper2.runSpeed();
  if (runMotorLeft)  stepper3.runSpeed();
}
