/*
SerialVoltage accepts a number between 0 and 9 on the serial port and uses it to scale
the voltage output on PWM pin 11.

Use it with the schematic at http://swannman.wordpress.com/projects/howto-get-started-with-arduino/
*/

const int pwmPin = 11;

void setup() {
  Serial.begin(9600);
  delay(500);
  Serial.print("Give me a voltage between 0 and 5, and I'll put it on pin ");
  Serial.println(pwmPin, DEC);
  pinMode(pwmPin, OUTPUT);
}

void loop() {
    while (Serial.available() > 0)
    {
       // Get the key that was pressed.  It comes in as a "key value"... '0' is 48, '1' is 49, ... '9' is 57
       int incomingByte = Serial.read();
      
      // Make sure the key is a digit between 0 and 9
       if ((incomingByte < 48) || (incomingByte > 57))
       {
          Serial.println("Invalid input!  Please give me a digit.");
          Serial.flush();
       }
       
       analogWrite(pwmPin, (incomingByte - 48) * 28); // 9 * 28 = 252, max is 255
    }
}


