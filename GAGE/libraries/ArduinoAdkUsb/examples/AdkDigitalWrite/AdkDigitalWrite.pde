/*
  DigitalWrite for ADK
 
 Takes input from an Android device touchscreen and
 sends it to an Android ADK device to turn an LED on and off.
 
 created 16 Jun 2011
 by Tom Igoe
 
 This example code is in the public domain.
 http://labs.arduino.cc/en/Tutorial/DigitalWrite
 
 */
 import cc.arduino.*;

ArduinoAdkUsb arduino;    // instance of the USB library

boolean ledState = false;
int bgColor = 0;
int fgColor = 255;
String ledString = "OFF";

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
  // change the background and fill:
  background(bgColor);
  fill(fgColor);
  // print the LED state to the screen:
  text(ledString, width/2, height/2);

}

public boolean surfaceTouchEvent(MotionEvent event) {
 if (!mousePressed) {
  ledState = !ledState;
  char outChar = 0;

  if (ledState) {  
    ledString = "ON";
    bgColor = 255;
    fgColor = 0;
    outChar = 'H';
  } 
  else {
    ledString = "OFF";
    bgColor = 0;
    fgColor = 255;
    outChar = 'L';
  }

// if there's an Arduino connected, send it the LED state:
  if ( arduino.isConnected() ) {
    arduino.write(outChar);
  }
 }

  return super.surfaceTouchEvent(event);
}

// clean up nicely after the app closes:
void onStop() {
  super.onStop();
  finish();
}
