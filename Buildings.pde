class Building {
  ArrayList<PVector> points;
  float radius;

  Building() {
    radius = 10;
    points = new ArrayList<PVector>();
  } 

  void addPoint(float x, float y) {
    PVector point = new PVector (x, y);
    points.add(point);
  }
  void display() {
    stroke(100, 200);
    strokeWeight(radius*2);
    fill(255, 0);
    beginShape();
    for (PVector a: points) {
      vertex (a.x, a.y);
    }
    endShape(CLOSE);
  }
}

