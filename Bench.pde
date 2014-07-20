class Bench {
  ArrayList<PVector> benchPoints1;
  ArrayList<PVector> benchPoints2;
  ArrayList<PVector> benchPoints3;
  ArrayList<PVector> benchPoints4;
  ArrayList<PVector> benchPoints5;
  ArrayList<PVector> benchPoints6;
  ArrayList<PVector> benchPoints7;
  float radius;

  Bench() {
    radius = 4;
    benchPoints1 = new ArrayList<PVector>();
    benchPoints2 = new ArrayList<PVector>();
    benchPoints3 = new ArrayList<PVector>();
    benchPoints4 = new ArrayList<PVector>();
    benchPoints5 = new ArrayList<PVector>();
    benchPoints6 = new ArrayList<PVector>();
    benchPoints7 = new ArrayList<PVector>();
  } 

  void addPoint1(float x, float y) {
    PVector point1 = new PVector (x, y);
    benchPoints1.add(point1);
  }

  void addPoint2(float x, float y) {
    PVector point2 = new PVector (x, y);
    benchPoints2.add(point2);
  }  

  void addPoint3(float x, float y) {
    PVector point3 = new PVector (x, y);
    benchPoints3.add(point3);
  }

  void addPoint4(float x, float y) {
    PVector point4 = new PVector (x, y);
    benchPoints4.add(point4);
  }

  void addPoint5(float x, float y) {
    PVector point5 = new PVector (x, y);
    benchPoints5.add(point5);
  }

  void addPoint6(float x, float y) {
    PVector point6 = new PVector (x, y);
    benchPoints6.add(point6);
  }

  void addPoint7(float x, float y) {
    PVector point7 = new PVector (x, y);
    benchPoints7.add(point7);
  }

  void display() {
    stroke(0, 0, 0);
    strokeWeight(radius*2);
    strokeCap(PROJECT);
    fill(255, 0);

    beginShape(LINES);
    for (PVector a: benchPoints1) {
      vertex (a.x, a.y);
    }
    endShape(CLOSE);

    beginShape(LINES);
    for (PVector a: benchPoints2) {
      vertex (a.x, a.y);
    }
    endShape(CLOSE);

    beginShape(LINES);
    for (PVector a: benchPoints3) {
      vertex (a.x, a.y);
    }
    endShape(CLOSE);

    beginShape(LINES);
    for (PVector a: benchPoints4) {
      vertex (a.x, a.y);
    }
    endShape(CLOSE);

    beginShape(LINES);
    for (PVector a: benchPoints5) {
      vertex (a.x, a.y);
    }
    endShape(CLOSE);

    beginShape(LINES);
    for (PVector a: benchPoints6) {
      vertex (a.x, a.y);
    }
    endShape(CLOSE);

    beginShape(LINES);
    for (PVector a: benchPoints7) {
      vertex (a.x, a.y);
    }
    endShape(CLOSE);
  }
}

