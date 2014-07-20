Citizen citizen;
Building b;
Bench ben;
Destination d1, d2, d3, d4, d5, d6, d7, d8, d9, d10;
Origin o1, o2, o3, o4, o5, o6, o7, o8, o9, o10;
Seating[] seats1 = new Seating[11];
Seating[] seats2 = new Seating[10];
Seating[] seats3 = new Seating[18];
Seating[] seats4 = new Seating[20];
Seating[] seats5 = new Seating[10];
Seating[] seats6 = new Seating[12];
Seating[] seats7 = new Seating[11];
PImage plaza;
PImage cad;
//Establish all destination points
PVector dest1 = new PVector (300, 100);
PVector dest2 = new PVector (475, 150);
PVector dest3 = new PVector (495, 200);
PVector dest4 = new PVector (520, 300);
PVector dest5 = new PVector (460, 480);
PVector dest6 = new PVector (355, 455);
PVector dest7 = new PVector (95, 445);
PVector dest8 = new PVector (60, 300);
PVector dest9 = new PVector (60, 170);
PVector dest10 = new PVector (90, 150);
//Establish all origin points
PVector orig1 = new PVector (300, 30); 
PVector orig2 = new PVector (510, 40);
PVector orig3 = new PVector (590, 170);
PVector orig4 = new PVector (590, 290);
PVector orig5 = new PVector (550, 520);
PVector orig6 = new PVector (335, 540);
PVector orig7 = new PVector (80, 480);
PVector orig8 = new PVector (40, 320);
PVector orig9 = new PVector (40, 200);
PVector orig10 = new PVector (60, 105);
//Enter how many Peds should be in the system.
int pedCount = 60;
int m = millis();
//Establish boolean functions for key-presses.
boolean debug = false;
boolean debug2 = false;
boolean debug3 = false;
boolean debug4 = false;
boolean debug5 = false;
boolean debug6 = false;
boolean debug7 = true; //'e' display edges of building.
boolean debugrec = false; //for recording video.
boolean debugcirc = false; // for creating dots based on walk/stand/sit
boolean debugwhite = true; //'w' creates a white background

void setup() {
  size(600, 550); 
  frameRate(30);
  plaza = loadImage ("BaileyPlaza.jpg");
  cad = loadImage ("CadBackground.jpg");
  citizen = new Citizen();
  newBuilding();
  newBench();
  //initialize seats 1
  for (int i = 0; i < seats1.length; i++) {
    seats1[i] = new Seating();
  }
  seats1[0].location = new PVector(399, 30);
  seats1[1].location = new PVector(399, 40);  
  seats1[2].location = new PVector(399, 50);
  seats1[3].location = new PVector(399, 60);
  seats1[4].location = new PVector(399, 70);
  seats1[5].location = new PVector(399, 80);
  seats1[6].location = new PVector(399, 90);
  seats1[7].location = new PVector(399, 100);
  seats1[8].location = new PVector(399, 110);
  seats1[9].location = new PVector(399, 120);
  seats1[10].location = new PVector(399, 130);

  //initialize seats 2
  for (int i = 0; i < seats2.length; i++) {
    seats2[i] = new Seating();
  }
  seats2[0].location = new PVector(478, 226);
  seats2[1].location = new PVector(482, 236);
  seats2[2].location = new PVector(486, 246);
  seats2[3].location = new PVector(490, 256);
  seats2[4].location = new PVector(493, 266);
  //halfway
  seats2[5].location = new PVector(485, 224);
  seats2[6].location = new PVector(489, 234);
  seats2[7].location = new PVector(493, 244);
  seats2[8].location = new PVector(497, 254);
  seats2[9].location = new PVector(500, 264);

  //initialize seats 3
  for (int i = 0; i < seats3.length; i++) {
    seats3[i] = new Seating();
  }
  seats3[0].location = new PVector(498, 318);
  seats3[1].location = new PVector(496, 328); 
  seats3[2].location = new PVector(493, 338);
  seats3[3].location = new PVector(490.5, 348); 
  seats3[4].location = new PVector(488, 358);
  seats3[5].location = new PVector(486, 368); 
  seats3[6].location = new PVector(483, 378);
  seats3[7].location = new PVector(481, 388); 
  seats3[8].location = new PVector(478, 398);
  //halfway
  seats3[9].location = new PVector(505, 320);
  seats3[10].location = new PVector(503, 330); 
  seats3[11].location = new PVector(500, 340);
  seats3[12].location = new PVector(497.5, 350); 
  seats3[13].location = new PVector(495, 360);
  seats3[14].location = new PVector(493, 370); 
  seats3[15].location = new PVector(490, 380);
  seats3[16].location = new PVector(488, 390); 
  seats3[17].location = new PVector(485, 400);

  //initialize seats 4
  for (int i = 0; i < seats4.length; i++) {
    seats4[i] = new Seating();
  }
  seats4[0].location = new PVector(216, 410);
  seats4[1].location = new PVector(226, 410.5); 
  seats4[2].location = new PVector(236, 411);
  seats4[3].location = new PVector(246, 411.5); 
  seats4[4].location = new PVector(256, 412);
  seats4[5].location = new PVector(266, 412.5); 
  seats4[6].location = new PVector(276, 413);
  seats4[7].location = new PVector(286, 414); 
  seats4[8].location = new PVector(296, 415);
  seats4[9].location = new PVector(306, 416);
  //halfway
  seats4[10].location = new PVector(216, 403);
  seats4[11].location = new PVector(226, 403.5); 
  seats4[12].location = new PVector(236, 404);
  seats4[13].location = new PVector(246, 404.5); 
  seats4[14].location = new PVector(256, 405);
  seats4[15].location = new PVector(266, 405.5); 
  seats4[16].location = new PVector(276, 406);
  seats4[17].location = new PVector(286, 407); 
  seats4[18].location = new PVector(296, 408);
  seats4[19].location = new PVector(306, 409); 


  //initialize seats 5
  for (int i = 0; i < seats5.length; i++) {
    seats5[i] = new Seating();
  }
  seats5[0].location = new PVector(92, 351); 
  seats5[1].location = new PVector(93, 362);
  seats5[2].location = new PVector(95, 373); 
  seats5[3].location = new PVector(97, 383);
  seats5[4].location = new PVector(99, 393); 
  //halfway 
  seats5[5].location = new PVector(85, 352); 
  seats5[6].location = new PVector(86, 363);
  seats5[7].location = new PVector(88, 374); 
  seats5[8].location = new PVector(90, 384);
  seats5[9].location = new PVector(92, 394); 

  //initialize seats 6
  for (int i = 0; i < seats6.length; i++) {
    seats6[i] = new Seating();
  }
  seats6[0].location = new PVector(104, 230);
  seats6[1].location = new PVector(101, 239); 
  seats6[2].location = new PVector(97, 248);
  seats6[3].location = new PVector(94, 258); 
  seats6[4].location = new PVector(91, 267);
  seats6[5].location = new PVector(88, 276);
  //halfway 
  seats6[6].location = new PVector(97, 228);
  seats6[7].location = new PVector(94, 237); 
  seats6[8].location = new PVector(90, 246);
  seats6[9].location = new PVector(87, 256); 
  seats6[10].location = new PVector(84, 265);
  seats6[11].location = new PVector(81, 274);


  //initialize seats 7
  for (int i = 0; i < seats7.length; i++) {
    seats7[i] = new Seating();
  }
  seats7[0].location = new PVector(201, 30);
  seats7[1].location = new PVector(201, 40);  
  seats7[2].location = new PVector(201, 50);
  seats7[3].location = new PVector(201, 60);
  seats7[4].location = new PVector(201, 70);
  seats7[5].location = new PVector(201, 80);
  seats7[6].location = new PVector(201, 90);
  seats7[7].location = new PVector(201, 100);
  seats7[8].location = new PVector(201, 110);
  seats7[9].location = new PVector(201, 120);
  seats7[10].location = new PVector(201, 130);

  //Initialize all Pedestrians. 
  //Control number of peds from 'pedCount' variable above.
  for (int i = 0; i < pedCount; i++) {
    Ped p = new Ped(random(200, 400), random(180, 280));
    citizen.addPed(p);
  }
  //initialize all origins & destinations
  d1 = new Destination(dest1.x, dest1.y);
  d2 = new Destination(dest2.x, dest2.y);
  d3 = new Destination(dest3.x, dest3.y);
  d4 = new Destination(dest4.x, dest4.y);
  d5 = new Destination(dest5.x, dest5.y);
  d6 = new Destination(dest6.x, dest6.y);
  d7 = new Destination(dest7.x, dest7.y);
  d8 = new Destination(dest8.x, dest8.y);
  d9 = new Destination(dest9.x, dest9.y);
  d10 = new Destination(dest10.x, dest10.y);
  o1 = new Origin(orig1.x, orig1.y);
  o2 = new Origin(orig2.x, orig2.y);
  o3 = new Origin(orig3.x, orig3.y);
  o4 = new Origin(orig4.x, orig4.y);
  o5 = new Origin(orig5.x, orig5.y);
  o6 = new Origin(orig6.x, orig6.y);
  o7 = new Origin(orig7.x, orig7.y);
  o8 = new Origin(orig8.x, orig8.y);
  o9 = new Origin(orig9.x, orig9.y);
  o10 = new Origin(orig10.x, orig10.y);
}




void draw() {
  if (debugwhite) {
    background (255);
  }
  smooth();
  //tint (255, 80);//tint adds opacity to the Bailey Plaza Image
  //image (plaza, 0, 0);//display Bailey Plaza Image 
  //image (cad, -8, 6); // displays cad background image

  //Create Grid
//  stroke(0);
//  strokeWeight(1);
//  line(0, 0, 0, 550);
//  line(50, 0, 50, 550);
//  line(100, 0, 100, 550);
//  line(150, 0, 150, 550);
//  line(200, 0, 200, 550);
//  line(250, 0, 250, 550);
//  line(300, 0, 300, 550);
//  line(350, 0, 350, 550);
//  line(400, 0, 400, 550); 
//  line(450, 0, 450, 550);
//  line(500, 0, 500, 550);
//  line(550, 0, 550, 550);
//  line(600, 0, 600, 550);
//
//  line(0, 0, 600, 0);
//  line(0, 50, 600, 50);
//  line(0, 100, 600, 100);
//  line(0, 150, 600, 150);
//  line(0, 200, 600, 200);
//
//  line(0, 250, 600, 250);
//  line(0, 300, 600, 300);
//
//  line(0, 350, 600, 350);
//  line(0, 400, 600, 400);
//
//  line(0, 450, 600, 450);
//  line(0, 500, 600, 500);
//
//  line(0, 550, 600, 550);
//  line(0, 600, 600, 600);
//
//






  //display all Destination Points:
  d1.display();
  d2.display();
  d3.display();
  d4.display();
  d5.display();
  d6.display();
  d7.display();
  d8.display();
  d9.display();
  d10.display();
  //display all Origin points
  o1.display();
  o2.display();
  o3.display();
  o4.display();
  o5.display();
  o6.display();
  o7.display();
  o8.display();
  o9.display();
  o10.display();

  // b.display(); //display the buildings toggle on/off to show actual "buildings" the Peds avoid.
  if (debug7) { // see the peds sit ON the benches, they must be rendered only once.
    ben.display();  //display the benches
  }
  //display the "seats"
  if (debug6) { //'s'
    for (int i = 0; i < seats1.length; i++) {
      seats1[i].display();
    }
    for (int i = 0; i < seats2.length; i++) {
      seats2[i].display();
    }
    for (int i = 0; i < seats3.length; i++) {
      seats3[i].display();
    }
    for (int i = 0; i < seats4.length; i++) {
      seats4[i].display();
    }
    for (int i = 0; i < seats5.length; i++) {
      seats5[i].display();
    }
    for (int i = 0; i < seats6.length; i++) {
      seats6[i].display();
    }
    for (int i = 0; i < seats7.length; i++) {
      seats7[i].display();
    }
  }
  citizen.run(); //activates the Ped Array within the Citizen Class.

  stroke(50);
  strokeWeight(0);
  noStroke();
  fill(100);
  if (debug7) {
    beginShape();
    //  //Copy of building shape - note 'vertex' instead of 'b.addPoints'
    //  //This is the actual location of walls and elements. The objects for peds to avoid
    //  //were moved inward as they had a radius that stuck out very far into the space, confusing
    //  //the peds and causing erratic behavior.
    vertex(-3, -10); //Entry #10
    vertex(69, 150); 
    vertex(-10, 150); // Entry #9
    vertex(-10, 217); // Entry #9
    vertex(92, 217); 
    vertex(68, 284); 
    vertex(-10, 285); //Entry #8
    vertex(-10, 338); //Entry #8
    vertex(71, 337);
    vertex(85, 430);
    vertex(-10, 547); //Entry #7
    vertex(-10, 570); //Entry #7
    vertex(42, 560);
    vertex(139, 437); //start of water feature
    vertex(180, 436);
    vertex(187, 418);
    vertex(216, 425);
    vertex(217, 421);
    vertex(349, 446);//end of water feature
    vertex(302, 610); //Entry #6
    vertex(320, 610); //Entry #6
    vertex(363, 473);
    vertex(405, 450);
    vertex(578, 610); //Entry #5
    vertex(610, 530); //Entry #5
    vertex(494, 423);
    vertex(522, 310);
    vertex(610, 310); //Entry #4
    vertex(610, 273); //Entry#4
    vertex(514, 273);
    vertex(490, 214);
    vertex(610, 214); //Entry #3
    vertex(610, 150); //Entry #3
    vertex(489, 150);
    vertex(560, -10); //Entry #2
    vertex(518, -10); //Entry #2
    vertex(446, 150);
    vertex(400, 150);
    vertex(400, 25); //Entry #1 At Bailey Hall
    vertex(200, 25); //Entry #1 At Bailey Hall
    vertex(200, 150);
    vertex(100, 150);
    vertex(20, -25);
    vertex(675, -25);
    vertex(675, 625);
    vertex(-25, 625);
    vertex(-25, -25);
    endShape(CLOSE);
  }
  //RECORD Video:
  if (debugrec) {
    saveFrame("sketchPeds-######.png");
  }
}

//All Points for Benches:
void newBench() {
  ben = new Bench();
  beginShape();
  ben.addPoint1(405, 30);
  ben.addPoint1(405, 130);
  endShape(CLOSE);

  beginShape();
  ben.addPoint2(482, 225);
  ben.addPoint2(498, 266);
  endShape(CLOSE);

  beginShape();
  ben.addPoint3(503, 319);
  ben.addPoint3(483, 400);
  endShape(CLOSE);

  beginShape();
  ben.addPoint4(216, 406);
  ben.addPoint4(306, 412);
  endShape(CLOSE);

  beginShape();
  ben.addPoint5(87, 350);
  ben.addPoint5(94, 395);
  endShape(CLOSE);

  beginShape();
  ben.addPoint6(100, 228);
  ben.addPoint6(83, 275);
  endShape(CLOSE);

  beginShape();
  ben.addPoint7(195, 30);
  ben.addPoint7(195, 130);
  endShape(CLOSE);
}
//
void newBuilding() {
  b = new Building();
  beginShape();
  //Each point corresponds to an x,y coordinate of the building outline.
  b.addPoint(-10, -10); //Entry #10
  b.addPoint(57, 143); 
  b.addPoint(-15, 143); // Entry #9
  b.addPoint(-15, 224); // Entry #9
  b.addPoint(81, 224); 
  b.addPoint(63, 277); 
  b.addPoint(-15, 278); //Entry #8
  b.addPoint(-15, 344); //Entry #8
  b.addPoint(64, 345);
  b.addPoint(76, 428);
  b.addPoint(-15, 540); //Entry #7
  b.addPoint(-15, 565); //Entry #7
  b.addPoint(52, 562);
  b.addPoint(142, 444); //start of water feature
  b.addPoint(184, 443);
  b.addPoint(191, 427);  
  b.addPoint(222, 434);
  b.addPoint(223, 431);
  b.addPoint(340, 452);//end of water feature
  b.addPoint(292, 615);
  b.addPoint(328, 615);
  b.addPoint(370, 478);
  b.addPoint(405, 460);
  b.addPoint(591, 635); //Entry #5
  b.addPoint(625, 533); //Entry #5
  b.addPoint(504, 421);
  b.addPoint(528, 318);
  b.addPoint(615, 318); //Entry #4
  b.addPoint(615, 266); //Entry#4
  b.addPoint(518, 266);
  b.addPoint(500, 221);
  b.addPoint(610, 221); //Entry #3
  b.addPoint(610, 143); //Entry #3
  b.addPoint(502, 143);
  b.addPoint(571, -15); //Entry #2
  b.addPoint(510, -15); //Entry #2
  b.addPoint(442, 143);
  b.addPoint(407, 143);
  b.addPoint(407, 18); //Entry #1 At Bailey Hall
  b.addPoint(193, 18); //Entry #1 At Bailey Hall
  b.addPoint(193, 143);
  b.addPoint(106, 143);
  b.addPoint(29, -25);
  b.addPoint(675, -25);
  b.addPoint(675, 625);
  b.addPoint(-25, 625);
  b.addPoint(-25, -25);
  // b.addPoint(50, 100);
  endShape(CLOSE);
}

PVector scalarProjection(PVector s, PVector location, PVector predictLoc) {
  PVector locations = PVector.sub(s, location);
  PVector predictLocs = PVector.sub(predictLoc, location);
  predictLocs.normalize();
  predictLocs.mult(locations.dot(predictLocs));
  PVector normalPoint = PVector.add(location, predictLocs);
  return normalPoint;
}

//Setup for the debugging lines:
void keyPressed() {
  if (key == 'b') {
    debug = !debug;
  }
  if (key == 'p') {
    debug2 = !debug2;
  }
  if (key == 'g') {
    debug3 = !debug3;
  }
  if (key == 'l') {
    debug4 = !debug4;
  }
  if (key == 'd') {
    debug5 = !debug5;
  }
  if (key == 's') {
    debug6 = !debug6;
  }
  if (key =='r') {
    debugrec = !debugrec;
  }
  if (key == 'e') {
    debug7 = !debug7;
  }
  if (key =='c') {
    debugcirc = !debugcirc;
  }
  if (key =='w') {
    debugwhite = !debugwhite;
  }
}

