/*
*A class that defines a single point that makes up the visual
*/

class aPoint{
 PVector location;     //Vector of the (x,y) coordinates of it's location
 PVector velocity;     //Velocity of the point
 PVector acceleration; //Acceleration of the opint
 float maxForce;       //The maximum force the point can have
 float topSpeed;       //The maximum velocity the point can have
 boolean arrived;      //Check variable to see if the point has arrived at it's destination
 PVector distance;     //The distance between the point and its destination
 
 
 /*
 *The constructor that initializes the variables
 */
 aPoint(float x, float y) {
   acceleration = new PVector(0,0); 
   location = new PVector(x,y); 
   velocity = new PVector(0,0); 
   topSpeed = 8;
   maxForce = 1; 
   arrived = false; 
 }
 
 /*
 *A method that updates the position of the point
 *As the point reaches it's destination, the acceleration will decrease
 */
 void update() {
  velocity.add(acceleration);   //update velocity
  velocity.limit(topSpeed);     //limit the speed
  location.add(velocity);       //update the location
  acceleration.mult(0);         //reset the accelration
 }
 
 /*
 *A method that adds a force to the acceleration
 */
 void applyForce(PVector force){
   acceleration.add(force);  
 }
 
 /*
 *A vector that updates all the variables of the point
 *to move it closer to it's destination
 */
 void arrive(PVector target) { 
   PVector desired = PVector.sub(target,location); //A vector from the current location to the desired position
   float d = desired.mag();                        //Finding the magnitude of this vector and normalizing it
   desired.normalize(); 
   if (d < 100) {                                  //Scale within 100 pixels
    float m = map(d, 0,100,0,topSpeed); 
   desired.setMag(m); 
   }else{
     desired.setMag(topSpeed);                     
   }
   
   PVector steer = PVector.sub(desired,velocity); //The steering force = desired - velocity 
   steer.limit(maxForce);                         //Limitin the maximum steering force
   applyForce(steer); 
   
   /*
   *Since the point never truly get's to it's position,
   *if it is "close enough" (the magnitude of the desired vector is less than 0.01)
   *then the point has arrived to it's destination
   */
   if (desired.mag() < 0.01) {
     arrived = true; 
   }
 }
   
/*
* A method that displays the point in the correct position with the correct colour
*/
 void display(int[] colour){
   stroke(colour[0], colour[1], colour[2]); 
   strokeWeight(2); 
   point(location.x, location.y); 
 }

   

  
  
}
