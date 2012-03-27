/*
  AnalogWrite for ADK
 
 Takes input from an Android device touchscreen and
 sends it to an Android ADK device to fade an LED.
 
 created 16 Jun 2011
 by Tom Igoe
 
 This example code is in the public domain.
 http://labs.arduino.cc/en/Tutorial/AnalogWrite
 
 */
 
 import cc.arduino.*;

ArduinoAdkUsb arduino;    // instance of the USB library

int positionY = 0;

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
}

void draw() {
  // white background, nice blue text:
  background(255);
  fill(#2389F6);
  // print the mouse position to the screen:
  text(positionY, 10, 100);
  // draw a rext from the mouseY to the bottom of the screen,
  // 40 pixels wide, in the middle of the screen:
  rect(width/2-20, mouseY, 40, height-mouseY);

  // if there's an Arduino connected:
  if ( arduino.isConnected() ) {
    // if there's a finger on the screen:
    if ( mousePressed ) {
      // get the mouseY, invert it so that bottom of the screen
      // is the lowest value, scale it to a 0-255 range, 
      // and send it to the Arduino:
      positionY = int(map(mouseY, height, 0, 0, 255));
      arduino.write(positionY);
    }
  }
}

// clean up nicely after the app closes:
void onStop() {
  super.onStop();
  finish();
}
