/*
CenterLED lights up all LEDs by cycling through them quickly.  It then
picks a "center" LED and lights it up slightly longer than the other
LEDs... the effect being that one LED is brighter than all the others.

After redrawing this display 1000x, we move the "center" LED to the right.

Use it with the schematic at http://swannman.wordpress.com/projects/howto-get-started-with-arduino/
*/

// The pins we're using to interface with the 74HC237
const int addr0 = 2;
const int addr1 = 3;
const int addr2 = 4;

// The number of times to redraw the center before moving on.
// Higher numbers will make the center brighter but all other LEDs dimmer.
const int numRedrawLoops = 5;

// The number of times to loop through all the LEDs before moving the center
// Higher numbers will make the center move more slowly.
const int numLoopsBeforeMoveCenter = 1000;

int value = 0;   // which LED to light up
int center = 0;  // the center of the bright spot
int numRedrawLoopsRemaining = numRedrawLoops;
int numLoopsRemainingBeforeMoveCenter = numLoopsBeforeMoveCenter;

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
  
  // Are we drawing the center?
  if (value == center)
  {
    // Yes, so decrement the number of times we need to go through
    // this loop before moving on
    numRedrawLoopsRemaining--;
    
    // Did we decrement past zero?
    if (numRedrawLoopsRemaining == -1)
    {
      // Yes -- we're done!  Reset the number of redraw loops remaining
      numRedrawLoopsRemaining = numRedrawLoops;
      
      // Move on to the next LED
      value++;
    }
  }
  else
  {
    // This isn't the center, so just move on to the next LED
    value++;
  }
  
  // Did we increment value too far?
  if (value == 8)
  {
    // If so, reset it to the first LED
    value = 0;
    
    // Decrement the number of full LED redraws we've seen before moving the center
    numLoopsRemainingBeforeMoveCenter--;
    
    // Did we get through all the LED redraws?
    if (numLoopsRemainingBeforeMoveCenter == -1)
    {
      // Yes -- reset the number of loops remaining
      numLoopsRemainingBeforeMoveCenter = numLoopsBeforeMoveCenter;
      
      // Move the center ahead to the next LED
      center++;
      
      // Did we move it too far?
      if (center == 8)
      {
        // Yes -- reset to the first LED
        center = 0;
      }
    }
  }
}
