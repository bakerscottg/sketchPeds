class Origin {
  //PVector origin;
  float xpos;
  float ypos;

  Origin (float tempXpos, float tempYpos) {
    xpos = tempXpos;
    ypos = tempYpos;
  }
  void display() {
    strokeWeight(.5);
    fill(180, 242, 180);
   //ellipse(xpos, ypos, 10, 10);
  }
}

