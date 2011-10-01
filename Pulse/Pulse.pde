/*
Pulse causes the LED attached to PWM pin 11 to pulse on and off.

Use it with the schematic at http://swannman.wordpress.com/projects/howto-get-started-with-arduino/
*/

const int pwmPin = 11;

int value = 0;
int valueDirection = 1;

void setup()
{
  pinMode(pwmPin, OUTPUT);
}

void loop()
{
  analogWrite(pwmPin, value);
  
  value = value + valueDirection;
  
  if ((value == 255) || (value == 0))
  {
    valueDirection = valueDirection * -1;
  }
  
  delay(10);
}
