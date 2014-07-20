class Seating {
  float radius;
  PVector location;

  Seating() {
    radius = 5;
  }

  void display() {
    stroke(100);
    strokeWeight(0);
    fill(220, 200, 150);
    ellipse(location.x, location.y, 10, 10);
  }
}

