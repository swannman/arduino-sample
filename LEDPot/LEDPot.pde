/*
LEDPot reads the value of the potentiometer (variable resistor) connected to pin 5, then 
uses that value to control the brightness of the PWM LED and to determine which LED 
to light up in the array.

Use it with the schematic at http://swannman.wordpress.com/projects/howto-get-started-with-arduino/
*/

// The pins we're using to interface with the 74HC237
const int addr0 = 2;
const int addr1 = 3;
const int addr2 = 4;

// The pin where the pulsing LED is connected.  Must be a pin that supports PWM (9-11).
const int pwmPin = 11;

// The pin where the pot is connected
const int potPin = 5;

int value = 0;

void setup() {
  pinMode(addr0, OUTPUT);
  pinMode(addr1, OUTPUT); 
  pinMode(addr2, OUTPUT);
  pinMode(pwmPin, OUTPUT);
}

void loop()
{
  value = analogRead(potPin);
   
  int ledValue = value / 128; // potPin values range from 0 to 1024
  
  // Tell the 74HC237 to display the LED at position 'value'
  digitalWrite(addr0, ledValue & B001); // bit 0 of 'value'
  digitalWrite(addr1, ledValue & B010); // bit 1 of 'value'
  digitalWrite(addr2, ledValue & B100); // bit 2 of 'value'
  
  int pwmValue = value / 4; // pwm values range from 0 to 255
  
  analogWrite(pwmPin, pwmValue);
}
