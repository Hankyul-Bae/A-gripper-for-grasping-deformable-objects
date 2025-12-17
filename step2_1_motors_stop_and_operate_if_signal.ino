#include <AccelStepper.h>


AccelStepper stepper2(4, 8, 9, 10, 11);
AccelStepper stepper3(4, 4, 5, 6, 7);  

const int speed = -300; 
const unsigned long runTime = 1000; 
bool moveCommandReceived = false; 
unsigned long startTime; /

void setup() {
  Serial.begin(9600);
  
  
  stepper2.setSpeed(speed);  
  stepper3.setSpeed(speed);  
}

void loop() {
  if (Serial.available()) {
    char command = Serial.read();
    if (command == 'S') {  
      if (!moveCommandReceived) {
        startTime = millis();  
        moveCommandReceived = true;

        
        stepper2.moveTo(stepper2.currentPosition() + speed * (runTime / 1000)); 
        stepper3.moveTo(stepper3.currentPosition() + speed * (runTime / 1000));
      }
    }
  }

  if (moveCommandReceived) {
    
    stepper2.run();
    stepper3.run();

    
    if (millis() - startTime >= runTime) {
      moveCommandReceived = false;  
    }
  }
}
