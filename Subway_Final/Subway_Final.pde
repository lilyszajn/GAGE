//add sandwich photos as array
//add external camera

// Simple sketch to demonstrate uploading directly from a Processing sketch to Flickr.
// Uses a camera as a data source, uploads a frame every time you click the mouse.

import processing.video.*;
import javax.imageio.*;
import java.awt.image.*;
import com.aetrion.flickr.*;
import postdata.*;
import processing.serial.*;

import SimpleOpenNI.*;
SimpleOpenNI kinect;

PVector prevRightHandLocation;
PVector prevLeftHandLocation;

int[] userMap;

PImage sandwich; //sandwich image
PImage backgroundImage; //background image

PImage[] images = new PImage[3];

//ArrayList = sandwiches;

// Fill in your own apiKey and secretKey values.
String apiKey = "b81f75e0a690b647e9b7451f430a6fee";
String secretKey = "b17229d92139ddff";

boolean upload = false;
Flickr flickr;
Uploader uploader;
Auth auth;
String frob = "";
String token = "";

Capture cam;

Serial myPort;
int inByte = 0;

boolean autoCalib=true;

void setup() {
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableRGB();

  // turn on user tracking
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);

  //turn on depth color alignment
  kinect.alternativeViewPointDepthToImage();

  size(640, 480); 
  fill(255, 0, 0);
  prevRightHandLocation = new PVector(0, 0, 0);
  prevLeftHandLocation = new PVector(0, 0, 0);

  //load the sandwich image
  sandwich = loadImage("Subway.png");

  //load the background image
  backgroundImage = loadImage("TECHUP.jpg");

  //sandwiches = new ArrayList(); //create an empty arraylist

  println(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600);


  // Set up the camera.
  cam = new Capture(this, 320, 240);  
  // Set up Flickr.
  flickr = new Flickr(apiKey, secretKey, (new Flickr(apiKey)).getTransport());

  // Authentication is the hard part.
  // If you're authenticating for the first time, this will open up
  // a web browser with Flickr's authentication web page and ask you to
  // give the app permission. You'll have 15 seconds to do this before the Processing app
  // gives up waiting fr you.

  // After the initial authentication, your info will be saved locally in a text file,
  // so you shouldn't have to go through the authentication song and dance more than once
  authenticate();

  // Create an uploader
  uploader = flickr.getUploader();
}

void draw() {
  image(backgroundImage, 0, 0, width, height);
  //scale(2);
  kinect.update();
  //get the kinect color image
  PImage rgbImage = kinect.rgbImage();

  // make a vector of ints to store the list of users
  IntVector userList = new IntVector();
  // write the list of detected users
  // into our vector
  kinect.getUsers(userList);

  // if we found any users
  if (userList.size() > 0) {
    // get the first user
    int userId = userList.get(0);

    // if we're successfully calibrated
    if (kinect.isTrackingSkeleton(userId)) {
      //prepare the color pixels
      rgbImage.loadPixels();
      loadPixels();
      userMap = kinect.getUsersPixels(SimpleOpenNI.USERS_ALL);
      for (int i = 0; i < userMap.length; i++) {
        //if the pixel is part of the user
        if (userMap[i] !=0) {
          //set the sketch pixel to the color pixel
          pixels[i] = rgbImage.pixels[i];
        }
      }//end of pixel for loop
      updatePixels();
      // make a vector to store the left hand
      PVector rightHand = new PVector();
      PVector leftHand = new PVector();
      //PVector head = new PVector();
      // put the position of the left hand into that vector
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, rightHand);
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, leftHand);

      // convert the detected hand position
      // to "projective" coordinates
      // that will match the depth image
      PVector convertedRightHand = new PVector();
      kinect.convertRealWorldToProjective(rightHand, convertedRightHand);
      // and display it      

      PVector convertedLeftHand = new PVector();
      kinect.convertRealWorldToProjective(leftHand, convertedLeftHand);
      float subwaySizeRight = convertedRightHand.dist(convertedLeftHand);
      float subwaySizeLeft = convertedLeftHand.dist(convertedRightHand);
      float inches = subwaySizeLeft / 25.4;
      //make an array of the sandwich images
      //  PImage[] images = new PImage[2];
      //    for ( int i = 0; i< images.length; i++ )
      //     {
      smooth();
      image(sandwich, convertedRightHand.x, convertedRightHand.y, subwaySizeLeft, 100 );   // make sure images "0.jpg" to "11.jpg" exist
      //    image(images[(int)random(3)], convertedRightHand.x, convertedRightHand.y, subwaySizeLeft, 100);
      //    }


      //      fill(255);
      //      scale(2.5);
      //      text(inches + " Inches", 100, 120);
      //      println(inches);
      //      //sandwich.resize(convertedLeftHand.x, convertedRightHand.y);

      prevRightHandLocation = convertedRightHand;
      prevLeftHandLocation = convertedLeftHand;
    }
  }
  //saveFrame("Subway######.jpg");
  if (upload == true)
  {
    uploadIt();
    upload = false;
    println("DONEZO");
  }
}//draw loop

void serialEvent (Serial myPort) {
  int inByte = myPort.read();
  if (inByte == '1') {
    println(inByte);

    String incoming = myPort.readStringUntil('\n');
    // Upload the current camera frame.
    println("Setting Uploading to true");
    upload = true;
    println("upload is true");
  }
}


void uploadIt()
{
  // First compress it as a jpeg.
  byte[] compressedImage = compressImage(cam);



  // Set some meta data.
  UploadMetaData uploadMetaData = new UploadMetaData(); 
  uploadMetaData.setTitle("Frame " + frameCount + " Uploaded from Processing"); 
  uploadMetaData.setDescription("To find out how, go to http://frontiernerds.com/upload-to-flickr-from-processing");
  //uploadMetaData.setTags("H");
  uploadMetaData.setPublicFlag(true);

  // Finally, upload/
  try {
    //uploader.upload(compressedImage, uploadMetaData);
    String photoid = uploader.upload(compressedImage, uploadMetaData);
    println(photoid);
    vals[0] = photoid; 
    vals[1] = "highFive"; 
    // and we're done :)
    String code = pd.post( url, vars, vals );
  }
  catch (Exception e) {
    println("Upload failed:" + e.toString());
  }


  println("Finished uploading");
}

// Attempts to authenticate. Note this approach is bad form,
// it uses side effects, etc.
void authenticate() {
  // Do we already have a token?
  if (fileExists("token.txt")) {
    token = loadToken();    
    println("Using saved token " + token);
    authenticateWithToken(token);
  }
  else {
    println("No saved token. Opening browser for authentication");    
    getAuthentication();
  }
}

// FLICKR AUTHENTICATION HELPER FUNCTIONS
// Attempts to authneticate with a given token
void authenticateWithToken(String _token) {
  AuthInterface authInterface = flickr.getAuthInterface();  

  // make sure the token is legit
  try {
    authInterface.checkToken(_token);
  }
  catch (Exception e) {
    println("Token is bad, getting a new one");
    getAuthentication();
    return;
  }

  auth = new Auth();

  RequestContext requestContext = RequestContext.getRequestContext();
  requestContext.setSharedSecret(secretKey);    
  requestContext.setAuth(auth);

  auth.setToken(_token);
  auth.setPermission(Permission.WRITE);
  flickr.setAuth(auth);
  println("Authentication success");
}


// Goes online to get user authentication from Flickr.
void getAuthentication() {
  AuthInterface authInterface = flickr.getAuthInterface();

  try {
    frob = authInterface.getFrob();
  } 
  catch (Exception e) {
    e.printStackTrace();
  }

  try {
    URL authURL = authInterface.buildAuthenticationUrl(Permission.WRITE, frob);

    // open the authentication URL in a browser
    open(authURL.toExternalForm());
  }
  catch (Exception e) {
    e.printStackTrace();
  }

  println("You have 15 seconds to approve the app!");  
  int startedWaiting = millis();
  int waitDuration = 15 * 1000; // wait 10 seconds  
  while ( (millis () - startedWaiting) < waitDuration) {
    // just wait
  }
  println("Done waiting");

  try {
    auth = authInterface.getToken(frob);
    //println("Authentication success");
    // This token can be used until the user revokes it.
    token = auth.getToken();
    // save it for future use
    saveToken(token);
  }
  catch (Exception e) {
    e.printStackTrace();
  }

  // complete authentication
  authenticateWithToken(token);
}

// Writes the token to a file so we don't have
// to re-authenticate every time we run the app
void saveToken(String _token) {
  String[] toWrite = { 
    _token
  };
  saveStrings("token.txt", toWrite);
}

boolean fileExists(String filename) {
  File file = new File(sketchPath(filename));
  return file.exists();
}

// Load the token string from a file
String loadToken() {
  String[] toRead = loadStrings("token.txt");
  return toRead[0];
}

// IMAGE COMPRESSION HELPER FUNCTION

// Takes a PImage and compresses it into a JPEG byte stream
// Adapted from Dan Shiffman's UDP Sender code
byte[] compressImage(PImage img) {
  // We need a buffered image to do the JPG encoding
  BufferedImage bimg = new BufferedImage( img.width, img.height, BufferedImage.TYPE_INT_RGB );

  img.loadPixels();
  bimg.setRGB(0, 0, img.width, img.height, img.pixels, 0, img.width);

  // Need these output streams to get image as bytes for UDP communication
  ByteArrayOutputStream baStream	= new ByteArrayOutputStream();
  BufferedOutputStream bos		= new BufferedOutputStream(baStream);

  // Turn the BufferedImage into a JPG and put it in the BufferedOutputStream
  // Requires try/catch
  try {
    ImageIO.write(bimg, "jpg", bos);
  } 
  catch (IOException e) {
    e.printStackTrace();
  }

  // Get the byte array, which we will send out via UDP!
  return baStream.toByteArray();
}

void keyPressed(int userId, boolean pictureTaken) {
  saveFrame("Subway###.jpg");
  //track new user
  userId = 0;
  pictureTaken = false;
}

// user-tracking callbacks!
void onNewUser(int userId) {
  println("start pose detection");
  kinect.startPoseDetection("Psi", userId);
}

void onEndCalibration(int userId, boolean successful) {
  if (successful) { 
    println("  User calibrated !!!");
    kinect.startTrackingSkeleton(userId);
  } 
  else { 
    println("  Failed to calibrate user !!!");
    kinect.startPoseDetection("Psi", userId);
  }
}
void onStartPose(String pose, int userId) { 
  println("Started pose for user"); 
  kinect.stopPoseDetection(userId); 
  kinect.requestCalibrationSkeleton(userId, true);
}

