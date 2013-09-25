//import the SimpleOpenNI library
import SimpleOpenNI.*;
SimpleOpenNI  kinect;
//set up autocalibration
boolean autoCalib=true;

void setup() {
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  kinect.setMirror(true);

  size(640, 480);
  stroke(255, 0, 0);
  strokeWeight(5);
}

void draw() {
  kinect.update();
  image(kinect.depthImage(), 0, 0);

  IntVector userList = new IntVector();
  //find anyone standing in front of the camera
  kinect.getUsers(userList);

  //if there is a user, start going through the Kinect stuff
  if (userList.size() > 0) {
    int userId = userList.get(0);

    if (kinect.isTrackingSkeleton(userId)) {      
      PVector leftHand = new PVector();
      PVector rightHand = new PVector();

      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, leftHand);      
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);

      // calculate difference by subtracting one vector from another
      PVector differenceVector = PVector.sub(leftHand, rightHand);
      // calculate the distance and direction
      // of the difference vector
      float magnitude = differenceVector.mag();
      differenceVector.normalize();
      // draw a line between the two hands
      kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HAND, SimpleOpenNI.SKEL_RIGHT_HAND);
      // display
      pushMatrix();
      scale(4);
      fill(differenceVector.x * 255, differenceVector.y * 255, differenceVector.z * 255);
      text("m: " + magnitude, 5, 10);
      popMatrix();
    }
  }
}

// SimpleOpenNI events

void onNewUser(int userId)
{
  println("onNewUser - userId: " + userId);
  println("  start pose detection");

  if (autoCalib)
    kinect.requestCalibrationSkeleton(userId, true);
  else    
    kinect.startPoseDetection("Psi", userId);
}

void onLostUser(int userId)
{
  println("onLostUser - userId: " + userId);
}

void onStartCalibration(int userId)
{
  println("onStartCalibration - userId: " + userId);
}

void onEndCalibration(int userId, boolean successfull)
{
  println("onEndCalibration - userId: " + userId + ", successfull: " + successfull);

  if (successfull) 
  { 
    println("  User calibrated !!!");
    kinect.startTrackingSkeleton(userId);
  } 
  else 
  { 
    println("  Failed to calibrate user !!!");
    println("  Start pose detection");
    kinect.startPoseDetection("Psi", userId);
  }
}

void onStartPose(String pose, int userId)
{
  println("onStartPose - userId: " + userId + ", pose: " + pose);
  println(" stop pose detection");

  kinect.stopPoseDetection(userId); 
  kinect.requestCalibrationSkeleton(userId, true);
}

void onEndPose(String pose, int userId)
{
  println("onEndPose - userId: " + userId + ", pose: " + pose);
}
