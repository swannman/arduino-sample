/*
LEDSequenceSwitchPot cycles through the LEDs in sequence, reversing direction
when the momentary switch is pressed.  The potentiometer (variable resistor) 
controls how quickly the LEDs cycle.

Note that this program "debounces" the momentary switch so that one press = one
change in direction, even if you hold the switch down.  We use the value of 
switchWaitTimeRemaining to do this -- if it's equal to switchWaitTime, we read 
the switch like normal.  If it's less than switchWaitTime, then we subtract one
from it and ignore the switch until it hits -1 and we reset it to switchWaitTime.

Use it with the schematic at http://swannman.wordpress.com/projects/howto-get-started-with-arduino/
*/

// The pins we're using to interface with the 74HC237
const int addr0 = 2;
const int addr1 = 3;
const int addr2 = 4;

// The pin where the switch is connected
const int switchPin = 5;

// The pin where the pot is connected
const int potPin = 5;

// The number of loops to wait before reading the switch after it's been pressed
const int switchWaitTime = 10000;

// The default number of loops to delay before moving to the next LED (changes based on pot)
int loopDelay = 1024;

int value = 0;   // which LED to light up
int dir = 1;     // the increment to add to 'value'
int loopDelayRemaining = loopDelay * 10;
int switchWaitTimeRemaining = switchWaitTime;
boolean ignoreSwitch = false;

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
  
  if (switchWaitTimeRemaining == switchWaitTime)
  {
    // Read the current switch value
    int switchValue = digitalRead(switchPin);
    
    // Is someone pushing the switch?
    if (switchValue == HIGH)
    {
      // Yes, reverse direction
      dir = dir * -1;
      
      // Ignore the switch value for a duration (comment this out to see what "debouncing" solves!)
      switchWaitTimeRemaining--;
      
      // Reset the delay so that we enter into the 'if' statement below
      loopDelayRemaining = loopDelay * 10;
    }
  }
  
  // If we're at the beginning of the delay time, update the LED position
  if (loopDelayRemaining >= loopDelay * 10)
  {
    // Count this as one of the loops
    loopDelayRemaining--;
    
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
  }
  else
  {
    // We're in the middle of the delay loop, so decrement our counter
    loopDelayRemaining--;
    
    // If we've started waiting after a switch press, keep decrementing the timer until it's 'empty' again
    if (switchWaitTimeRemaining < switchWaitTime)
    {
      if (digitalRead(switchPin) == HIGH)
      {
        // If someone is still holding the switch down, keep waiting...
        switchWaitTimeRemaining = switchWaitTime;
      }
      
      switchWaitTimeRemaining--;
      
      // If we decremented all the way past 0, reset it
      if (switchWaitTimeRemaining == -1)
      {
        switchWaitTimeRemaining = switchWaitTime;
      }
    }
    
    // If we got to the end, reset the delay time and reset the switch
    if (loopDelayRemaining == -1)
    {
      // Refresh the delay value from the pot
      loopDelay = analogRead(potPin);
      
      if (loopDelay < 10)
      {
        loopDelay = 10;
      }
      
      loopDelayRemaining = loopDelay * 10;
    }
  }
}
