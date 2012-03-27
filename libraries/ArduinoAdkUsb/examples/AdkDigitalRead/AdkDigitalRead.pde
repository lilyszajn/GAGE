/*
  DigitalRead for ADK
 
 Reads input from an Android ADK device and uses it to change the screen.
 
 created 16 Jun 2011
 by Tom Igoe
 
 This example code is in the public domain.
 http://labs.arduino.cc/en/Tutorial/DigitalRead
 
 */
 import cc.arduino.*;

ArduinoAdkUsb arduino;     // instance of the USB library

int bgColor = 0;           // background color
int fgColor = 255;         // foreground color
String buttonString = "OFF";  // Text to display
void setup() {
  // initialize the USB host:
  arduino = new ArduinoAdkUsb( this );

  // if there is a USB host, open a connection to it:

  if ( arduino.list() != null ) {
    arduino.connect( arduino.list()[0] );
  }

  // Lock PORTRAIT view:
  orientation( PORTRAIT );

  // initialize a font to draw on the screen:
  String thisFont = PFont.list()[0];
  PFont myFont = createFont(thisFont, 96);
  textFont(myFont, 96);
  textAlign(CENTER);
}

void draw() {
 background(bgColor);
  fill(fgColor);
  
  // Try to read from arduino
  if (arduino.isConnected()) {
    if ( arduino.available() > 0 ) {
      int inChar = arduino.read();

      if (inChar == 'H') {  
        buttonString = "ON";
        bgColor = 255;
        fgColor = 0;
      } 
      else if (inChar =='L') {
        buttonString = "OFF";
        bgColor = 0;
        fgColor = 255;
      }
    }
  }

  // print the mouse position to the screen:
  text(buttonString, width/2, height/2);
}

// clean up nicely after the app closes:
void onStop() {
  super.onStop();
  finish();
}

