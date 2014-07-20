class Destination {
  /*the destination class creates a red rectangle
   at the destination x/y coordinates with a size of 10 pixels by 10 pixels.
   it is purely to help in the understanding and coding of the model.
   No shape needs to be there for the Peds to go to this locaiton, but
   it helps us humans see what is going on.
   */

  float xpos;
  float ypos;

  Destination (float tempXpos, float tempYpos) {
    xpos = tempXpos;
    ypos = tempYpos;
  }
  void display() {
    strokeWeight(.5);
    fill(242, 180, 180);
    //change to be in the center, I think this is upper corner?
    //rect(xpos-5, ypos-5, 10, 10);
  }
}

