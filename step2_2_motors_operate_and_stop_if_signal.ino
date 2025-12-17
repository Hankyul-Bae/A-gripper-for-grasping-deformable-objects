#include <AccelStepper.h>


AccelStepper stepper2(4, 8, 9, 10, 11); 
AccelStepper stepper3(4, 4, 5, 6, 7);   

bool runMotors = true;

void setup() {
  Serial.begin(9600);
  
  
  stepper2.setSpeed(-800);  
  stepper3.setSpeed(-800);  
}

void loop() {
  if (Serial.available()) {
    char command = Serial.read();
    if (command == 'S') {  
      runMotors = false;
    }
  }

  if (runMotors) {
    
    stepper2.runSpeed();  
    stepper3.runSpeed();  
  }
}
