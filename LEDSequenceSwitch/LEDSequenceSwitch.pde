/*
LEDSequenceSwitch cycles through the LEDs and reverses direction when 
the momentary switch is pushed.

Note that this program does not "debounce" the switch -- what happens 
when you hold the switch down?

Use it with the schematic at http://swannman.wordpress.com/projects/howto-get-started-with-arduino/
*/

// The pins we're using to interface with the 74HC237
const int addr0 = 2;
const int addr1 = 3;
const int addr2 = 4;

// The pin where the switch is connected
const int switchPin = 5;

int value = 0;   // which LED to light up
int dir = 1;     // the increment to add to 'value'

void setup() {
  pinMode(addr0, OUTPUT);
  pinMode(addr1, OUTPUT); 
  pinMode(addr2, OUTPUT);
  
  pinMode(switchPin, INPUT);
}

void loop()
{
  // Tell the 74HC237 to display the LED at position 'value'
  digitalWrite(addr0, value & B001); // bit 0 of 'value'
  digitalWrite(addr1, value & B010); // bit 1 of 'value'
  digitalWrite(addr2, value & B100); // bit 2 of 'value'
  
  // Read the current switch value
  int switchValue = digitalRead(switchPin);
  
  // Is someone pushing the switch?
  if (switchValue == HIGH)
  {
    // Yes, reverse direction
    dir = dir * -1;
  }

  // Move on to the next LED
  value = value + dir;
  
  // Make sure 'value' is still within bounds
  if (value == 8)
  {
    value = 0;
  }
  else if (value == -1)
  {
    value = 7;
  }
  
  delay(100);
}
