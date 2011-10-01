/*
SerialVoltageDecimal accepts two digits from the serial port and treats them as
a decimal voltage, eg '11' = 1.1v.  That voltage is output on PWM pin 11.

Use it with the schematic at http://swannman.wordpress.com/projects/howto-get-started-with-arduino/
*/

const int pwmPin = 11;

int input[2]; // create an array that holds 2 ints
int arrayIndex = 0; // arrays are zero-indexed, so the first position is at position 0

void setup() {
  Serial.begin(9600);
  delay(500);
  Serial.print("Give me a voltage between 0.0 and 5.0, and I'll put it on pin ");
  Serial.println(pwmPin, DEC);
  pinMode(pwmPin, OUTPUT);
}

void loop() {
    
    while (Serial.available() > 0)
    {
       // Read the key value
       int incomingByte = Serial.read();
      
       // If the key value isn't a digit between '0' and '9', display an error
       if ((incomingByte < 48) || (incomingByte > 57))
       {
          Serial.println("Invalid input!  Please give me two digits: '22' = 2.2V.");
          Serial.flush();
          arrayIndex = 0;
          break;
       }
       
       // Store the digit in our array
       input[arrayIndex] = incomingByte;
       
       // Point at the next position in the array... this is where the next digit will be stored
       arrayIndex++;
    }
    
    // Are we pointing at spot #3, eg indicating that we've put two digits in the array?
    if (arrayIndex == 2)
    {
      // Yes, so reset the index where we'll store the next digit
      arrayIndex = 0;
      
      // Grab the first key value and subtract 48 to get the digit that was entered
      float value = input[0] - 48;
      
      // Grab the second key value and get the digit that was entered
      float decimalValue = input[1] - 48;
      
      // Divide the second digit by 10 (since it's on the right of the decimal point) and add it to the first digit
      value = value + (decimalValue / 10.0);
      
      // Write back the value that we got
      Serial.println(value, 1);
      
      // Put this voltage on the PWM pin.  Max input is 5.0, 5 * 51 = 255.
      analogWrite(pwmPin, value * 51);
    }
}


