/*
* Libraries needed to run OSC in Processing
*/
import oscP5.*; 
import netP5.*;

/*
* Setting up the OSC to communicate with MAX
*/
OscP5 oscP5; 
NetAddress myBroadcastLocation; 

/*
*An array that contains all the points that make up the fractal (see the class aPoint) 
*/
aPoint[] points;    

/*
* An array that contains the (x,y) coordinates of the current position of the points 
* and an array that contains the (x,y) coordinates of the destination points of the points
*/
float[][] currPos;      
float[][] desPos;       

/*
*The a,b,c values of the equation
*/

float a;                 
float b;
float c; 

/*
*Total number of points 
*/

int numPoints = 8000; 


/*
* Variable Checking if the user wants to 
*program to run automatically or not
*/
boolean automatic; 
boolean clicked; 

void setup() {
 
   size(1000,1000);  //Window size 
  
  
  /*
  *Setting up the OSC. 
  *Message sent through port 1200 and received through port 12000
  */
  oscP5 = new OscP5(this,12000); 
  myBroadcastLocation = new NetAddress("127.0.0.1", 1200); 
  
  /*
  *Initializing the global variables
  */
  currPos= new float[numPoints][2]; 
  desPos = new float [numPoints][2];
  automatic = false;
  clicked = false;
  /*
  *Randomly initiating values of a,b, and c
  */
  randomNums();
  
  /*
  *Calculating the points and 
  *Displaying the current hopalong fractal
  */
  hopalongCurr(a,b,c);
  points = new aPoint[numPoints];
  for (int i= 0; i < points.length; i++) { 
    points[i] =  new aPoint((currPos[i][0]*100 + width/2), (currPos[i][1] * 100 + height/2)); 
  }
  
  /*
  *Sending the OSC message to MAX
  */
  
  sendOSCMessage();
  
  /*
  *Updating a,b, and c and the x,y values
  */
  
  randomNums();
  hopalongDes(a,b,c); 
  
  /*
  *Sending the OSC message to MAX
  */
  
  sendOSCMessage();

} 


void draw() {
  
  background(0);  //Set background to black 
  
  /*
  *Check if the user wants the program to run automatically
  */
  if (automatic == true){
    
    /*
    * For each point, move the point to its destination
    */
    for (int i = 0; i< points.length; i++){
      PVector target = new PVector ((desPos[i][0]*100) + width/2, (desPos[i][1] * 100) + height/2); 
      aPoint currPoint = points[i]; 
      currPoint.arrive(target); 
      currPoint.update(); 
      currPoint.display(colour(i)); 
    }
    
    /*
    *Check to see if each point has arrive at it's destination
    */
     boolean arrived = false; 
    for (aPoint point : points) {
      if (point.arrived == true) {
        arrived = true; 
      }else {
        arrived = false; 
      }
    }
    
    /*
    *Once each point has arrived, update a,b, and c and restart the process
    */
    if (arrived == true) { 
     delay (100);   //display the fractal for 1/100th of a second
     randomNums();
     hopalongDes(a,b,c);
     for (aPoint point : points){
       point.arrived = false;
     }
    
    /*
    *Send an OSC message to MAX
    */
    sendOSCMessage(); 
    }
    
  /*
  *User wants to control when fractals change
  */
  }else {
    for (int i = 0; i< points.length; i++){
    PVector target = new PVector ((desPos[i][0]*100) + width/2, (desPos[i][1] * 100) + height/2); 
    aPoint currPoint = points[i]; 
    currPoint.arrive(target); 
    currPoint.update(); 
    currPoint.display(colour(i)); 
    }
  
  
    /*
    *Wait until the user clicks the trigger to change the fractal
    */
    if (clicked == true) { 
     delay (100);   //display the fractal for 1/100th of a second
     randomNums();
     hopalongDes(a,b,c);
     for (aPoint point : points){
       point.arrived = false;
       }
    
    /*
    *Send an OSC message to MAX
    */
    sendOSCMessage(); 
    clicked = false; 
    }
   }
 }
  



/*
*A method that calculates the (x,y) positions of the first hopalong fractal
*and populates currPos with those values
*/
void hopalongCurr(float a, float b, float c) {
  float x = 0; 
  float y = 0; 
  for (int i =0; i<currPos.length; i++) {
    currPos[i][0] = x; 
    currPos[i][1] = y; 
    float xx = y - (findSign(x)) * (float)Math.pow(Math.abs((b*x) - c), 0.5); 
    float yy = a - x; 
    x = xx; 
    y = yy;
  }
}

/**
*A method that calculates the (x,y) positions of the next hopalong fractal
*and populates desPos with those values
*/
void hopalongDes(float a, float b, float c) {
  float x = 0; 
  float y = 0; 
  for (int i =0; i<currPos.length; i++) {
    desPos[i][0] = x; 
    desPos[i][1] = y; 
    float xx = y - (findSign(x)) * (float)Math.pow(Math.abs((b*x) - c), 0.5); 
    float yy = a - x; 
    x = xx; 
    y = yy;
  }
}

/**
*A method that returns the sign of a float
*Returns: -1 if the float is negative, 1 if the float is positive, 
*and 0 if the float is 0
**/
int findSign(float x){
  if (x<0){
    return -1; 
  }else if (x>0) {
    return 1; 
  }else {
    return 0;
  }
}

/*
*A method that initializes a,b, and c with random floats
*between -1 and 1. 
*/
void randomNums() { 
  a = (float) Math.random() * 2 - 1; 
  b = (float) Math.random() * 2 - 1; 
  c = (float) Math.random() * 2 - 1; 
}

/*
*Setting the colour of a point
*the colour changes every numPoints/5 points
*/
int[] colour (int i) { 
  if (i < numPoints/5) {
     int[] colours =  {127,235, 233}; //Blue
     return colours; 
    }else if (i >= numPoints/5 && i < 2*(numPoints/5) ){ 
      int[] colours =  {148, 235, 76}; //Green
      return colours; 
    }else if (i >= 2*(numPoints/5) && i < 3*(numPoints/5)) {
      int [] colours =  {251,232, 77}; //Yellow
      return colours; 
    } else if (i >= 3*(numPoints/5) && i < 4*(numPoints/5)) {
      int [] colours =  {220, 47, 246}; //Purple
      return colours; 
    }else {
      int [] colours =  {255, 129, 0}; //Orange
      return colours; 
    }
}

/*
*A method that creates and sends an OSC to MAX
*/
void sendOSCMessage() {
  OscMessage message = new OscMessage ("/variables"); 
  message.add(a); 
  message.add(b); 
  message.add(c); 
  oscP5.send(message,myBroadcastLocation);
  print("message sent"); 
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* get and print the address pattern and the typetag of the received OscMessage */
  println("### received an osc message with addrpattern "+theOscMessage.addrPattern()+" and typetag "+theOscMessage.typetag());
  theOscMessage.print();
  
  if (theOscMessage.addrPattern().equals("/automatic")){
    if(theOscMessage.get(0).intValue() == 1) {
      automatic = true; 
    }else if(theOscMessage.get(0).intValue() == 0) {
      automatic = false; 
    }
  }
  
  if (theOscMessage.addrPattern().equals("/update")){
    clicked = true; 
  }
}
