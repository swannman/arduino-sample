/*
LEDSequence cycles through one LED at a time.

Use it with the schematic at http://swannman.wordpress.com/projects/howto-get-started-with-arduino/
*/

// The pins we're using to interface with the 74HC237
const int addr0 = 2;
const int addr1 = 3;
const int addr2 = 4;

int value = 0;   // which LED to light up

void setup() {
  // Tell Arduino that these pins will be used for output (vs. input)
  pinMode(addr0, OUTPUT);
  pinMode(addr1, OUTPUT); 
  pinMode(addr2, OUTPUT);   
}

void loop()
{
  // Tell the 74HC237 to display the LED at position 'value'
  digitalWrite(addr0, value & B001); // bit 0 of 'value'
  digitalWrite(addr1, value & B010); // bit 1 of 'value'
  digitalWrite(addr2, value & B100); // bit 2 of 'value'

  // Move on to the next LED
  value++;

  // Did we increment 'value' too far?
  if (value == 8)
  {
    // Yes, reset it to the first LED
    value = 0;
  }
  
  // Comment out this line to go through all the LEDs as quickly as possible --
  // eg all the LEDs appear lit, but dimmer.
  delay(250);
}
