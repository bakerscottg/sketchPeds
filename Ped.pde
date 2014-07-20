class Ped {
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector destination;
  PVector seat;// = s.seatPoint1[0];
  float r;
  float gregarious;
  float grlow = 0.00;
  float grhigh = 0.03;
  float maxforce;
  float topspeed;
  float shortlife = 500;
  float stand = 2475;
  float longlife = 2500;
  float late = 2175;
  float lifetime = random(10, 50);//, longlife);
  float age = random(0, 20);



  Ped(float x, float y) {
    location = new PVector (x, y);
    velocity = new PVector (0, -1);
    acceleration = new PVector(0, 0);
    destination = new PVector (dest1.x, dest1.y);
    seat = new PVector (seats1[0].location.x, seats1[0].location.y);//s.seatPoint1[0].x,s.seatPoint1[0].y);
    r = 2.5; // 5 pixels equals half of a meter. Almost 20 inches.
    gregarious = random(grlow, grhigh);
    maxforce = random(0.11, 0.13);
    topspeed = random(0.41667, 0.4667); //1.25 to 1.4 meter per second at 30 fps.
  }

  void run(ArrayList <Ped> peds) {
    behavior(peds, b);
    update();
    borders();
    render();
    arrive();
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void behavior(ArrayList<Ped> peds, Building b) {
    PVector sep = separate(peds);  //separation
    PVector sep2 = separateTwo(peds);//large scale separation.
    PVector gWay = giveWay(peds); // Give Way. Slow down to avoid collision.
    PVector seekForce = seek(destination); //move to destinaiton/target
    PVector seekSeat = sit(seat); //sit down if time allows.
    //PVector ali = align(peds); //alignment
    PVector coh = cohesion(peds); //cohesion
    PVector avoid = avoidance(b, ben); //avoid buildings
    PVector pau = pause(peds);   // stop when next to other peds
    PVector nav = navigate(peds); //navigate around other peds.
    PVector pnav = proNavigate(peds); //navigate around projected point of other peds
    pnav.mult(0.4);//0.6);
    nav.mult(0.4);//.4);
    sep.mult(0.4);//.65);//0.35);
    gWay.mult(0.5);//.5);
    if ((lifetime > stand) && (age > 60)) {
      seekForce.mult(0.001);
      seekSeat.mult(0.15);
      coh.mult(0);
      sep2.mult(0);
    }
    else if ((lifetime > late) && (lifetime < stand)) {
      seekForce.mult(0.025);
      seekSeat.mult(0);    
      sep2.mult(0);
      coh.mult(gregarious*2.25);
    }
    else {
      seekForce.mult(0.15);
      seekSeat.mult(0);
      coh.mult(gregarious*2);    
      sep2.mult(0.125);
    }
    //ali.mult(0); //allignment is turned off.
    if ((lifetime > stand) && 
      (location.x < seat.x + 20) && (location.x > seat.x - 20) && 
      (location.y < seat.y + 20) && (location.y > seat.y- 20)) {
      avoid.mult(0);//don't avoid buildings
    }
    else {
      avoid.mult(0.5);//avoid buildings
    }

    //Apply all forces
    applyForce(pnav);
    applyForce(nav);
    applyForce(sep);
    applyForce(sep2);
    applyForce(gWay);
    applyForce(seekSeat);
    if (lifetime > late) {
      //applyForce(ali);
      applyForce(coh); //Apply cohesion only if the ped isn't "late" yet.
    }
    applyForce(seekForce); 
    applyForce(avoid);
  } 

  void update() {
    velocity.add(acceleration);
    velocity.limit(topspeed);
    location.add(velocity);
    acceleration.mult(0);
    lifetime -= 0.1;
    age += 0.1;
    if ((lifetime < stand) && (lifetime +1 > stand)) {
      lifetime = late;
    }
    println("life:", lifetime, "/", "gregarious:", gregarious, "/", "framerate:", frameRate, "/", "age", age, "/", "frame", frameCount);
    if (lifetime < 0) {
      location.x = destination.x;
      location.y = destination.y;
    }
  }

  //Regenerate to a new location
  void arrive() {
    PVector mouse = new PVector (mouseX, mouseY);
    if (((location.x < destination.x +r*6) && (location.x > destination.x -r*6) && 
      (location.y < destination.y + r*6) && (location.y > destination.y-r*6))
      || 
      ((mousePressed) && (location.x < mouse.x + r*2) && location.x > mouse.x - r*2) &&
      (location.y < mouse.y +r*2) && (location.y > mouse.y - r*2)) {
      //float prob = 0.50;
      float r = random(1);
      gregarious = random(grlow, grhigh);
      lifetime = random(shortlife, longlife);
      maxforce = random(0.11, 0.13);
      topspeed = random(0.41667, 0.4667); //1.25 to 1.4 meter per second.
      if (lifetime > stand) {
        lifetime += random(900, 2700);// 900  = 5 mins, 2700  = 15 mins
      }
      age = random(0, 20);
      chooseSeat();
      //println(gregarious,lifetime);
      //set origin to Origin #1
      if (r <= 0.2) {
        location.x = orig1.x + random(-80, 80);
        location.y = orig1.y;
        velocity = new PVector(0, 1);
        float rdest = random(1);
        if (rdest < 0.425) {
          destination = dest5;
        }
        else if ((rdest > 0.425) && (rdest <= 0.475)) {
          destination = dest6;
        }
        else if ((rdest > 0.475) && (rdest <= 0.575)) {
          destination = dest7;
        }
        else {
          destination = dest8;
        }
      }
      //set origin to Origin #2
      else if ((r > 0.2) && (r <= 0.36)) {
        location.x = orig2.x + random(-5, 5);
        location.y = orig2.y;
        velocity = new PVector(-0.5, 1);
        float rdest = random(1);
        //println(rdest);
        if (rdest < 0.156) {
          destination = dest1;
        }
        else if ((rdest > 0.156) && (rdest <= 0.25)) {
          destination = dest6;
        }
        else if ((rdest > 0.25) && (rdest <= 0.437)) {
          destination = dest7;
        }
        else {
          destination = dest8;
        }
      }
      //set origin to Origin #3
      else if ((r > 0.36) && (r <= 0.385)) {
        location.x = orig3.x;
        location.y = orig3.y + random(-15, 15);
        velocity = new PVector(-1, 0);
        float rdest = random(1);
        if (rdest < 0.5) {
          destination = dest7;
        }
        else {
          destination = dest8;
        }
      }
      //set origin to Orign #4
      else if ((r > 0.385) && (r <= 0.385)) {
        location.x = orig4.x;
        location.y = orig4.y + random(-15, 15);
        velocity = new PVector(-1, 0);
        float rdest = random(1);
        if (rdest < 0.5) {
          destination = dest7;
        }
        else {
          destination = dest8;
        }
      }
      //set origin to Origin #5
      else if ((r > 0.385) && (r <= 0.58)) {
        location.x = orig5.x +random(-5, 5);
        location.y = orig5.y +random(-10, 10);
        velocity = new PVector(-1, -0.5);
        float rdest = random(1);
        if (rdest < 0.359) {
          destination = dest1;
        }
        else if ((rdest > 0.359) && (rdest <= 0.74)) {
          destination = dest8;
        }
        else {
          destination = dest10;
        }
      }
      //set origin to Orign #6
      else if ((r > 0.58) && (r <= 0.605)) {
        location.x = orig6.x + random(-10, 10);
        location.y = orig6.y + random(-5, 5);
        velocity = new PVector(0, -1);
        float rdest = random(1);
        if (rdest < 0.4) {
          destination = dest1;
        }
        else {
          destination = dest2;
        }
      }
      //set origin to Origin #7
      else if ((r >0.605) && (r<= 0.64)) {
        location.x = orig7.x + random(-10, 10);
        location.y = orig7.y;
        velocity = new PVector(1, -1);
        float rdest = random(1);
        if (rdest < 0.285) {
          destination = dest1;
        }
        else if ((rdest > 0.285) && (rdest <= 0.714)) {
          destination = dest2;
        }
        else {
          destination = dest3;
        }
      }
      //set origin to Origin #8
      else if ((r > 0.64) && (r <= 0.85)) {
        location.x = orig8.x + random(-10, 10);
        location.y = orig8.y + random(-5, 5);
        velocity = new PVector(1, 0);
        float rdest = random(1);
        if (rdest < 0.143) {
          destination = dest1;
        }
        else if ((rdest > 0.143) && (rdest <= 0.595)) {
          destination = dest2;
        }
        else if ((rdest > 0.595) && (rdest <= 0.643)) {
          destination = dest3;
        }
        else {
          destination = dest5;
        }
      }
      //set origin to Origin #9
      else if ((r > 0.85) && (r <= 0.875)) {
        location.x = orig9.x + random(-10, 10);
        location.y = orig9.y + random (-5, 5);
        velocity = new PVector(1, 0);
        float rdest = random(1);
        if (rdest < 0.8) {
          destination = dest1;
        }
        else {
          destination = dest5;
        }
      }
      //set origin to Origin #10
      else {
        location.x = orig10.x + random(-7, 7);
        location.y = orig10.y + random(-7, 7);
        velocity = new PVector(.25, 1);
        float rdest = random(1);
        if (rdest < 0.2) {
          destination = dest1;
        }
        else if ((rdest > 0.2) && (rdest <= 0.76)) {
          destination = dest5;
        }
        else {
          destination = dest9;
        }
      }
    }
  }




  // bounce off borders
  void borders() {

    PVector desired = null;

    if (location.x < (1*r)) {
      desired = new PVector(topspeed, velocity.y);
    }
    else if (location.x > width - (1*r)) {
      desired = new PVector (-topspeed, velocity.y);
    }
    if (location.y < (1*r)) {
      desired = new PVector(velocity.x, topspeed);
    }
    else if (location.y > height - (1*r)) {
      desired = new PVector(velocity.x, -topspeed);
    }
    if (desired != null) {
      desired.normalize();
      desired.mult(topspeed);
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(maxforce);
      applyForce(steer);
    }
  }



  //Seek to go to "destination.x,destination.y" location.

  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, location);
    desired.normalize();
    desired.mult(topspeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);
    return steer;
  }


  void chooseSeat() {
    float r = random(6);
    if (r <= 1) {
      float r1 = random(seats1.length+seats7.length);
      if (r1 <= 1) {
        seat = new PVector(seats1[0].location.x, seats1[0].location.y);
      }
      else if ((r1 > 1) && (r1 <= 2)) {
        seat = new PVector(seats1[1].location.x, seats1[1].location.y);
      }
      else if ((r1 > 2) &&(r1 <= 3)) {
        seat = new PVector(seats1[2].location.x, seats1[2].location.y);
      }
      else if ((r1 > 3) &&(r1 <= 4)) {
        seat = new PVector(seats1[3].location.x, seats1[3].location.y);
      }
      else if ((r1 > 4) &&(r1 <= 5)) {
        seat = new PVector(seats1[4].location.x, seats1[4].location.y);
      }
      else if ((r1 > 5) &&(r1 <= 6)) {
        seat = new PVector(seats1[5].location.x, seats1[5].location.y);
      }
      else if ((r1 > 6) &&(r1 <= 7)) {
        seat = new PVector(seats1[6].location.x, seats1[6].location.y);
      }
      else if ((r1 > 7) &&(r1 <= 8)) {
        seat = new PVector(seats1[7].location.x, seats1[7].location.y);
      }
      else if ((r1 > 8) &&(r1 <= 9)) {
        seat = new PVector(seats1[8].location.x, seats1[8].location.y);
      }
      else if ((r1 > 9) &&(r1 <= 10)) {
        seat = new PVector(seats1[9].location.x, seats1[9].location.y);
      }
      else if ((r1 > 10) && (r1 <= 11)) {
        seat = new PVector(seats1[10].location.x, seats1[10].location.y);
      }
      else if ((r1 > 11) && (r1 <= 12)) {
        seat = new PVector(seats7[0].location.x, seats7[0].location.y);
      }
      else if ((r1 > 12) &&(r1 <= 13)) {
        seat = new PVector(seats7[1].location.x, seats7[1].location.y);
      }
      else if ((r1 > 13) &&(r1 <= 14)) {
        seat = new PVector(seats7[2].location.x, seats7[2].location.y);
      }
      else if ((r1 > 14) &&(r1 <= 15)) {
        seat = new PVector(seats7[3].location.x, seats7[3].location.y);
      }
      else if ((r1 > 15) &&(r1 <= 16)) {
        seat = new PVector(seats7[4].location.x, seats7[4].location.y);
      }
      else if ((r1 > 16) &&(r1 <= 17)) {
        seat = new PVector(seats7[5].location.x, seats7[5].location.y);
      }
      else if ((r1 > 17) &&(r1 <= 18)) {
        seat = new PVector(seats1[6].location.x, seats1[6].location.y);
      }
      else if ((r1 > 18) &&(r1 <= 19)) {
        seat = new PVector(seats1[7].location.x, seats1[7].location.y);
      }
      else if ((r1 > 19) &&(r1 <= 20)) {
        seat = new PVector(seats1[8].location.x, seats1[8].location.y);
      }
      else if ((r1 > 20) &&(r1 <= 21)) {
        seat = new PVector(seats1[9].location.x, seats1[9].location.y);
      }
      else {
        seat = new PVector(seats1[10].location.x, seats1[10].location.y);
      }
    }
    else if ((r > 1) && (r <= 2)) {
      float r2 = random (seats2.length);
      if (r2 <= 1) {
        seat = new PVector(seats2[0].location.x, seats2[0].location.y);
      }
      else if ((r2 > 1) && (r2 <= 2)) {
        seat = new PVector(seats2[1].location.x, seats2[1].location.y);
      }
      else if ((r2 > 2) && (r2 <= 3)) {
        seat = new PVector(seats2[2].location.x, seats2[2].location.y);
      }
      else if ((r2 > 3) && (r2 <= 4)) {
        seat = new PVector(seats2[3].location.x, seats2[3].location.y);
      }
      else if ((r2 > 4) && (r2 <= 5)) {
        seat = new PVector(seats2[4].location.x, seats2[4].location.y);
      }
      else if ((r2 > 5) && (r2 <= 6)) {
        seat = new PVector(seats2[5].location.x, seats2[5].location.y);
      }
      else if ((r2 > 6) && (r2 <= 7)) {
        seat = new PVector(seats2[6].location.x, seats2[6].location.y);
      }
      else if ((r2 > 7) && (r2 <= 8)) {
        seat = new PVector(seats2[7].location.x, seats2[7].location.y);
      }
      else if ((r2 > 8) && (r2 <= 9)) {
        seat = new PVector(seats2[8].location.x, seats2[8].location.y);
      }
      else {
        seat = new PVector(seats2[9].location.x, seats2[9].location.y);
      }
    }
    else if ((r > 2) && (r <= 3)) {
      float r3 = random(seats3.length);
      if (r3 <= 1) {
        seat = new PVector(seats3[0].location.x, seats3[0].location.y);
      }
      else if ((r3 > 1) && (r3 <= 2)) {
        seat = new PVector(seats3[1].location.x, seats3[1].location.y);
      }
      else if ((r3 > 2) && (r3 <= 3)) {
        seat = new PVector(seats3[2].location.x, seats3[2].location.y);
      }
      else if ((r3 > 3) && (r3 <= 4)) {
        seat = new PVector(seats3[3].location.x, seats3[3].location.y);
      }
      else if ((r3 > 4) && (r3 <= 5)) {
        seat = new PVector(seats3[4].location.x, seats3[4].location.y);
      }
      else if ((r3 > 5) && (r3 <= 6)) {
        seat = new PVector(seats3[5].location.x, seats3[5].location.y);
      }
      else if ((r3 > 6) && (r3 <= 7)) {
        seat = new PVector(seats3[6].location.x, seats3[6].location.y);
      }
      else if ((r3 > 7) && (r3 <= 8)) {
        seat = new PVector(seats3[7].location.x, seats3[7].location.y);
      }
      else if ((r3 > 8) && (r3 <= 9)) {
        seat = new PVector(seats3[8].location.x, seats3[8].location.y);
      }
      else if ((r3 > 9) && (r3 <= 10)) {
        seat = new PVector(seats3[9].location.x, seats3[9].location.y);
      }
      else if ((r3 > 10) && (r3 <= 11)) {
        seat = new PVector(seats3[10].location.x, seats3[10].location.y);
      }
      else if ((r3 > 11) && (r3 <= 12)) {
        seat = new PVector(seats3[11].location.x, seats3[11].location.y);
      }
      else if ((r3 > 12) && (r3 <= 13)) {
        seat = new PVector(seats3[12].location.x, seats3[12].location.y);
      }
      else if ((r3 > 13) && (r3 <= 14)) {
        seat = new PVector(seats3[13].location.x, seats3[13].location.y);
      }
      else if ((r3 > 14) && (r3 <= 15)) {
        seat = new PVector(seats3[14].location.x, seats3[14].location.y);
      }
      else if ((r3 > 15) && (r3 <= 16)) {
        seat = new PVector(seats3[15].location.x, seats3[15].location.y);
      }
      else if ((r3 > 16) && (r3 <= 17)) {
        seat = new PVector(seats3[16].location.x, seats3[16].location.y);
      }
      else {
        seat = new PVector(seats3[17].location.x, seats3[17].location.y);
      }
    }
    else if ((r > 3) && (r <= 4)) {
      float r4 = random(seats4.length);
      if (r4 <= 1) {
        seat = new PVector(seats4[0].location.x, seats4[0].location.y);
      }
      else if ((r4 > 1) && (r4 <= 2)) {
        seat = new PVector(seats4[1].location.x, seats4[1].location.y);
      }
      else if ((r4 > 2) && (r4 <= 3)) {
        seat = new PVector(seats4[2].location.x, seats4[2].location.y);
      }
      else if ((r4 > 3) && (r4 <= 4)) {
        seat = new PVector(seats4[3].location.x, seats4[3].location.y);
      }
      else if ((r4 > 4) && (r4 <= 5)) {
        seat = new PVector(seats4[4].location.x, seats4[4].location.y);
      }
      else if ((r4 > 5) && (r4 <= 6)) {
        seat = new PVector(seats4[5].location.x, seats4[5].location.y);
      }
      else if ((r4 > 6) && (r4 <= 7)) {
        seat = new PVector(seats4[6].location.x, seats4[6].location.y);
      }
      else if ((r4 > 7) && (r4 <= 8)) {
        seat = new PVector(seats4[7].location.x, seats4[7].location.y);
      }
      else if ((r4 > 8) && (r4 <= 9)) {
        seat = new PVector(seats4[8].location.x, seats4[8].location.y);
      }
      else if ((r4 > 9) && (r4 <= 10)) {
        seat = new PVector(seats4[9].location.x, seats4[9].location.y);
      }
      else if ((r4 > 10) && (r4 <= 11)) {
        seat = new PVector(seats4[10].location.x, seats4[10].location.y);
      }
      else if ((r4 > 11) && (r4 <= 12)) {
        seat = new PVector(seats4[11].location.x, seats4[11].location.y);
      }
      else if ((r4 > 12) && (r4 <= 13)) {
        seat = new PVector(seats4[12].location.x, seats4[12].location.y);
      }
      else if ((r4 > 13) && (r4 <= 14)) {
        seat = new PVector(seats4[13].location.x, seats4[13].location.y);
      }
      else if ((r4 > 14) && (r4 <= 15)) {
        seat = new PVector(seats4[14].location.x, seats4[14].location.y);
      }
      else if ((r4 > 15) && (r4 <= 16)) {
        seat = new PVector(seats4[15].location.x, seats4[15].location.y);
      }
      else if ((r4 > 16) && (r4 <= 17)) {
        seat = new PVector(seats4[16].location.x, seats4[16].location.y);
      }
      else if ((r4 > 17) && (r4 <= 18)) {
        seat = new PVector(seats4[17].location.x, seats4[17].location.y);
      }
      else if ((r4 > 18) && (r4 <= 19)) {
        seat = new PVector(seats4[18].location.x, seats4[18].location.y);
      }
      else {
        seat = new PVector(seats4[19].location.x, seats4[19].location.y);
      }
    }



    else if ((r > 4) && (r <= 5)) {
      float r5 = random(seats5.length);
      if (r5 <= 1) {
        seat = new PVector(seats5[0].location.x, seats5[0].location.y);
      }
      else if ((r5 > 1) && (r5 <= 2)) {
        seat = new PVector(seats5[1].location.x, seats5[1].location.y);
      }
      else if ((r5 > 2) && (r5 <= 3)) {
        seat = new PVector(seats5[2].location.x, seats5[2].location.y);
      }
      else if ((r5 > 3) && (r5 <= 4)) {
        seat = new PVector(seats5[3].location.x, seats5[3].location.y);
      }
      else if ((r5 > 4) && (r5 <= 5)) {
        seat = new PVector(seats5[4].location.x, seats5[4].location.y);
      }
      else if ((r5 > 5) && (r5 <= 6)) {
        seat = new PVector(seats5[5].location.x, seats5[5].location.y);
      }
      else if ((r5 > 6) && (r5 <= 7)) {
        seat = new PVector(seats5[6].location.x, seats5[6].location.y);
      }
      else if ((r5 > 7) && (r5 <= 8)) {
        seat = new PVector(seats5[7].location.x, seats5[7].location.y);
      }
      else if ((r5 > 8) && (r5 <= 9)) {
        seat = new PVector(seats5[8].location.x, seats5[8].location.y);
      }
      else if ((r5 > 9) && (r5 <= 10)) {
        seat = new PVector(seats5[9].location.x, seats5[9].location.y);
      }
      else if ((r5 > 10) && (r5 <= 11)) {
        seat = new PVector(seats5[10].location.x, seats5[10].location.y);
      }
      else {
        seat = new PVector(seats5[11].location.x, seats5[11].location.y);
      }
    }




    else {
      float r6 = random(seats6.length);
      if (r6 <= 1) {
        seat = new PVector(seats6[0].location.x, seats6[0].location.y);
      }
      else if ((r6 > 1) && (r6 <= 2)) {
        seat = new PVector(seats6[1].location.x, seats6[1].location.y);
      }
      else if ((r6 > 2) && (r6 <= 3)) {
        seat = new PVector(seats6[2].location.x, seats6[2].location.y);
      }
      else if ((r6 > 3) && (r6 <= 4)) {
        seat = new PVector(seats6[3].location.x, seats6[3].location.y);
      }
      else if ((r6 > 4) && (r6 <= 5)) {
        seat = new PVector(seats6[4].location.x, seats6[4].location.y);
      }
      else if ((r6 > 5) && (r6 <= 6)) {
        seat = new PVector(seats6[5].location.x, seats6[5].location.y);
      }
      else if ((r6 > 6) && (r6 <= 7)) {
        seat = new PVector(seats6[6].location.x, seats6[6].location.y);
      }
      else if ((r6 > 7) && (r6 <= 8)) {
        seat = new PVector(seats6[7].location.x, seats6[7].location.y);
      }
      else if ((r6 > 8) && (r6 <= 9)) {
        seat = new PVector(seats6[8].location.x, seats6[8].location.y);
      }
      else if ((r6 > 9) && (r6 <= 10)) {
        seat = new PVector(seats6[9].location.x, seats6[9].location.y);
      }
      else if ((r6 > 10) && (r6 <= 11)) {
        seat = new PVector(seats6[10].location.x, seats6[10].location.y);
      }
      else {
        seat = new PVector(seats6[11].location.x, seats6[11].location.y);
      }
    }
  }
  PVector sit(PVector target) {  
    PVector steer = new PVector(0, 0);
    PVector desired = PVector.sub(target, location);
    desired.normalize();
    desired.mult(topspeed);
    steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);
    if ((location.x < seat.x + 5) && (location.x > seat.x -5) && 
      (location.y < seat.y + 5) && (location.y > seat.y-5) &&(lifetime > late)) {
      location.x = seat.x;
      location.y = seat.y;
      gregarious = 0;
      velocity.x /=100;
      velocity.y /=100;
      //acceleration = seat;
    }
    return steer;
  }




  //display Ped Objects
  void render() {
    float theta = velocity.heading();
    float speed = velocity.mag() + 1;
    fill(255);
    noFill();
    strokeWeight(1);
    stroke(200);
    if (!debugcirc) {
      pushMatrix();
      translate(location.x, location.y);
      rotate(theta);
      if ((location.x < seat.x + 5) && (location.x > seat.x -5) && 
        (location.y < seat.y + 5) && (location.y > seat.y-5) &&(lifetime > late)) {
      }
      else {
        line(r*1.8, 0, r, -r*1.2);
        line(r*1.8, 0, r, r*1.2);
      }
      stroke(0);
      strokeWeight(0.5);
      // if "standing": YELLOW
      if ((velocity.x < 0.1) && (velocity.x > -0.1) 
        && (velocity.y < 0.1) && (velocity.y> -0.1)
        && //(location.x != seat.x) && (location.x != seat.x) && 
      //(location.y != seat.y) && (location.y != seat.y) &&  
      (lifetime < stand)) {
        fill(255, 251, 12);
      }
      // if "sitting": RED
      else if ((location.x < seat.x +5) && (location.x > seat.x -5) && 
        (location.y < seat.y + 5) && (location.y > seat.y-5) &&(lifetime > late)) {
        fill(210, 20, 20);
      }
      // if "walking": GREEN
      else {
        //        noFill();
        //        ellipse(0,0,25,25);//sep2 ellipse.
        fill (40, 230, 40);
      }
      ellipse(0, 0, r+r/2, r*2);
      if (debug2) { // 'p'
        fill(100, 100);
        // line(0, 0, speed*speed*speed*speed*speed, 0);
        //ellipse(speed*speed*speed*speed*speed, 0, 10, 10);
        arc(0, 0, speed*speed*speed*speed*speed*speed*speed*speed*speed+r, 
        speed*speed*speed*speed*speed*speed*speed*speed*speed+r, -PI/6, PI/6);
        arc(0, 0, speed*speed*speed*speed*speed*speed*speed*speed*speed*speed*speed+r, 
        speed*speed*speed*speed*speed*speed*speed*speed*speed*speed*speed+r, -PI/12, PI/12);
      }
      if (debug3) { //'g'
        fill(100, 100);
        if (lifetime > late) {
          ellipse(0, 0, r*5 +(gregarious*lifetime), r*5 +(gregarious*lifetime));
        }
      }


      popMatrix();

      if (debug5) { // 'd'
        fill(100, 100);
        strokeWeight(0.5);
        stroke(50);
        if (lifetime < stand) {
          line(location.x, location.y, destination.x, destination.y);
        }
        if (lifetime > stand) {
          line(location.x, location.y, seat.x, seat.y);
        }
        //ellipse(0, 0, gregarious*1000, gregarious*1000);
      }
    }


    //
    // Enables the circle coding of the program to compile an image.
    if (debugcirc) {
      int s = second();
      if ((s == 0) &&((frameCount % 30) <= 1) || (s == 30) && ((frameCount % 30) <= 1)) {
        noStroke();
        //if "sitting": RED
        if ((location.x < seat.x +5) && (location.x > seat.x -5) && 
          (location.y < seat.y + 5) && (location.y > seat.y-5) &&(lifetime > late)) {
          fill(210, 20, 20, 20);
        }
        //if "standing": YELLOW
        else if ((velocity.x < 0.1) && (velocity.x > -0.1) 
          && (velocity.y < 0.1) && (velocity.y> -0.1)
          && //(location.x != seat.x) && (location.x != seat.x) && 
        //(location.y != seat.y) && (location.y != seat.y) &&  
        (lifetime < stand)) {
          fill(255, 251, 12, 20);
        }
        //if "walking": GREEN
        else {
          fill(40, 230, 40, 20);
        }
        ellipse(location.x, location.y, r*2, r*2);
      }
    }
  }



  // Copy of Alignment to test "pause"
  // For every nearby boid in the system, calculate the average velocity
  PVector pause (ArrayList<Ped> peds) {
    float neighbordist = r*5;
    //ellipse(location.x,location.y,neighbordist,neighbordist);
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Ped other : peds) {
      if (lifetime > late) {
        float p = PVector.dist(location, other.location);
        if ((p > 0) && (p < neighbordist) && (other.lifetime > late)) {
          velocity.x /= 1 + (gregarious*8);
          velocity.y /= 1 + (gregarious*8);
          count++;
        }
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.normalize();
      sum.mult(topspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } 
    else {
      return new PVector(0, 0);
    }
  }



  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Ped> peds) {
    float desiredseparation = r*2;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Ped other : peds) {
      float p = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than desired separation(0 means you are yourself)
      if ((p > 0) && (p < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(p);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(topspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }



  // Separation # 2 larger area to help with avoidance and achieve a more natural looking interaction.
  // Method checks for nearby boids and steers away
  PVector separateTwo (ArrayList<Ped> peds) {
    float desiredseparation = 25;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Ped other : peds) {
      float p = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than desired separation(0 means you are yourself)
      if ((p > 0) && (p < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(p);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(topspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }





  // Give Way - (slow down to let other peds pass in front of you.
  // Same as separate, but with an arc in front of you and a desired separation
  // that is dependent upon the Ped's speed.
  // Method checks for nearby boids and steers away
  PVector giveWay (ArrayList<Ped> peds) {
    float speed = velocity.mag() + 1;
    float desiredseparation = (speed*speed*speed*speed*speed*speed*speed*speed*speed*speed*speed+r);
    PVector steer = new PVector(0, 0, 0);
    float periphery = PI/12;
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Ped other : peds) {
      float p = PVector.dist(location, other.location);
      PVector comparison = PVector.sub(other.location, location);
      float angle = PVector.angleBetween(comparison, velocity);
      // If the distance is greater than 0 and less than desired separation(0 means you are yourself)
      if ((p > 0) && (p < desiredseparation) && (angle < periphery)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        //        PVector goRight = new PVector(0, 55555550);
        //        diff.add(goRight);

        diff.normalize();
        diff.div(p);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(topspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }

    return steer;
  }


  // Copy of NAVIGATION! to Prospective Navigation: proNavigate or pNav.
  // Method checks for nearby boids and steers away
  // WORKS!! Must add 'view field' though they are reacting to peds that are behind them.
  PVector proNavigate (ArrayList<Ped> peds) {
    float speed = velocity.mag() + 1;
    float desiredseparation = speed*speed*speed*speed*speed*speed*speed*speed*speed+r;
    float periphery = PI/6;
    PVector steer = new PVector(0, 0, 0);
    PVector predict = velocity.get();
    predict.normalize();
    predict.mult((speed*speed*speed*speed*speed*speed));
    PVector predictLoc = PVector.add(location, predict);
    if (debug4) { //'l'
      fill(255, 50);
      strokeWeight(0.5);
      //  if (lifetime > late) {
      //ellipse(0, 0, lifetime/100, lifetime/100);
      //ellipse(0, 0, lifetime/100, lifetime/100);
      //      PVector velp = predictLoc.get();
      //      
      //      velp.normalize();
      //      velp.mult(speed);
      ellipse(predictLoc.x, predictLoc.y, 5, 5);
      //  }
    }
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Ped other : peds) {
      float otherspeed = other.velocity.mag() + 1;
      PVector otherpredict = other.velocity.get();
      otherpredict.normalize();
      otherpredict.mult(otherspeed*otherspeed*otherspeed*otherspeed*otherspeed*otherspeed);
      PVector otherpredictLoc = PVector.add(other.location, otherpredict);
      PVector comparison = PVector.sub(otherpredictLoc, location);
      float p = PVector.dist(location, otherpredictLoc);
      float angle = PVector.angleBetween(comparison, velocity);
      // If the distance is greater than 0 and less than desired separation(0 means you are yourself)
      if ((p > 0) && (p < desiredseparation) && (angle < periphery)) {
        // Calculate vector pointing away from neighbor
        PVector norm = scalarProjection(other.location, location, predictLoc);

        PVector diff = PVector.sub(norm, other.location);
        //predictLoc.mult(diff.dot(predictLoc);
        //adjust.sub(velocity, diff);
        diff.normalize();
        diff.div(p);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(topspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }


  // NAVIGATION!
  // Method checks for nearby boids and steers away
  PVector navigate (ArrayList<Ped> peds) {
    float speed = velocity.mag() + 1;
    float desiredseparation = speed*speed*speed*speed*speed*speed*speed*speed*speed+r;
    float periphery = PI/6;
    PVector steer = new PVector(0, 0, 0);
    PVector predict = velocity.get();
    predict.normalize();
    predict.mult((speed*speed*speed));
    PVector predictLoc = PVector.add(location, predict);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Ped other : peds) {
      float p = PVector.dist(location, other.location);
      PVector comparison = PVector.sub(other.location, location);
      float angle = PVector.angleBetween(comparison, velocity);
      // If the distance is greater than 0 and less than desired separation(0 means you are yourself)
      if ((p > 0) && (p < desiredseparation) && (angle < periphery)) {
        // Calculate vector pointing away from neighbor
        PVector norm = scalarProjection(other.location, location, predictLoc);
        PVector diff = new PVector(0, 0);
        if (p <= 10) { //if they are within one meter of you, turn yourself so as to go around them.
          PVector close = PVector.sub(other.location, norm);
          diff.set(close);
//          fill(200, 0, 0);
//          noFill();
//          stroke(200, 0, 0);
//          ellipse(other.location.x, other.location.y, 10, 10);
//          ellipse(location.x, location.y, 10, 10);
//          fill(0, 200, 0);
//          //ellipse(predictLoc.x,predictLoc.y,5,5);
//          ellipse(location.x, location.y, 100, 100);
        }
        else {
          PVector far = PVector.sub(norm, other.location);
          diff.set(far);
        }
        //predictLoc.mult(diff.dot(predictLoc);
        //adjust.sub(velocity, diff);
        diff.normalize();
        diff.div(p);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(topspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }


  // Cohesion adopted from Reynolds 
  // For the average location (i.e. center) of all nearby peds, calculate steering vector towards that location
  // addition of lifetime variable so peds are only attracted to other peds that have the time to stop.
  PVector cohesion (ArrayList<Ped> peds) {
    float neighbordist = (r*5 +(gregarious*lifetime))/2;
    //ellipse(location.x,location.y,20,20);
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (Ped other : peds) {
      float p = PVector.dist(location, other.location);
      if ((p > 0) && (p < neighbordist) && (other.lifetime > late) && (other.lifetime < stand)) {
        sum.add(other.location); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the location
    } 
    else {
      return new PVector(0, 0);
    }
  }


  // Avoid Buildings
  PVector avoidance (Building b, Bench ben) {
    PVector steer = new PVector(0, 0, 0);
    float speed = velocity.mag()+1;
    float theta = velocity.heading() + radians(90);
    float sightDistance = 5+speed*speed*speed*speed*speed;
    PVector predictLocR = new PVector((speed*speed*speed*speed), -sightDistance);
    PVector predictLocL = new PVector((-speed*speed*speed*speed), -sightDistance);
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    popMatrix();
    predictLocR.rotate(theta);
    predictLocL.rotate(theta);
    predictLocR.add(location.x, location.y, 0);
    predictLocL.add(location.x, location.y, 0);

    // Now we must find the normal to the building from the predicted location
    // We look at the normal for each line segment and pick out the closest one
    PVector normalR = null;
    PVector normalL = null;
    PVector targetL = null;
    PVector targetR = null;
    float worldRecordR = 10000;  // Start with a very high worldRecord distance that can easily be beaten
    float worldRecordL = 10000;  // Start with a very high worldRecord distance that can easily be beaten

    // Loop through all points of the BUILDING path 
    // BENCH Avoidance is below.
    //
    for (int i = 0; i < b.points.size(); i++) {

      // Look at a line segment
      PVector a = b.points.get(i);
      PVector c = b.points.get((i+1)%b.points.size()); // Note Path has to wraparound
      // Get the normal point to that line
      PVector normalPointR = getNormalPoint(predictLocR, a, c);
      PVector normalPointL = getNormalPoint(predictLocL, a, c);

      // Check if normal is on line segment
      PVector dir = PVector.sub(c, a);
      // If it's not within the line segment, consider the normal to just be the end of the line segment (point b)
      // if (da + dc > line.mag()+1) {
      if (normalPointR.x < min(a.x, c.x) || normalPointR.x > max(a.x, c.x) 
        || normalPointR.y < min(a.y, c.y) || normalPointR.y > max(a.y, c.y)) {
        normalPointR = c.get();
      }
      //}
      if (normalPointL.x < min(a.x, c.x) || normalPointL.x > max(a.x, c.x) 
        || normalPointL.y < min(a.y, c.y) || normalPointL.y > max(a.y, c.y)) {
        normalPointL = c.get();
      }

      // How far away are we from the path?
      float dR = PVector.dist(predictLocR, normalPointR);
      float dL = PVector.dist(predictLocL, normalPointL);
      // Did we beat the worldRecord and find the closest line segment?
      if (dR < worldRecordR) {
        worldRecordR = dR;
        normalR = normalPointR;
        // Look at the direction of the line segment so we can seek a little bit ahead of the normal
        //        dir.normalize();
        //        // This is an oversimplification
        //        // Could be based on distance to path & velocity
        //        dir.mult(25);
        //        targetR = normalR.get();
        //        targetR.add(dir);
        //       dir.rotate(radians(20));
      }
      if (dL < worldRecordL) {
        worldRecordL = dL;
        normalL = normalPointL;
      }
    }


    // Bench 1 Avoidance within Building Avoidance.
    for (int i = 0; i < ben.benchPoints1.size(); i++) {
      // Look at a line segment
      PVector a = ben.benchPoints1.get(i);
      PVector c = ben.benchPoints1.get((i+1)%ben.benchPoints1.size());
      // Get the normal point to that line
      PVector normalPointR = getNormalPoint(predictLocR, a, c);
      PVector normalPointL = getNormalPoint(predictLocL, a, c);
      // Check if normal is on line segment
      PVector dir = PVector.sub(c, a);
      // If it's not within the line segment, consider the normal to just be the end of the line segment (point b)
      if (normalPointR.x < min(a.x, c.x) || normalPointR.x > max(a.x, c.x) 
        || normalPointR.y < min(a.y, c.y) || normalPointR.y > max(a.y, c.y)) {
        normalPointR = c.get();
      }
      if (normalPointL.x < min(a.x, c.x) || normalPointL.x > max(a.x, c.x) 
        || normalPointL.y < min(a.y, c.y) || normalPointL.y > max(a.y, c.y)) {
        normalPointL = c.get();
      }
      // How far away are we from the path?
      float dR = PVector.dist(predictLocR, normalPointR);
      float dL = PVector.dist(predictLocL, normalPointL);
      // Did we beat the worldRecord and find the closest line segment?
      if (dR < worldRecordR) {
        worldRecordR = dR;
        normalR = normalPointR;
        // Look at the direction of the line segment so we can seek a little bit ahead of the normal
        dir.normalize();
        dir.mult(25);
        targetR = normalR.get();
        targetR.add(dir);
      }
      if (dL < worldRecordL) {
        worldRecordL = dL;
        normalL = normalPointL;
      }
    }
    // Bench 2 Avoidance within Building Avoidance.
    for (int i = 0; i < ben.benchPoints2.size(); i++) {
      // Look at a line segment
      PVector a = ben.benchPoints2.get(i);
      PVector c = ben.benchPoints2.get((i+1)%ben.benchPoints2.size());
      // Get the normal point to that line
      PVector normalPointR = getNormalPoint(predictLocR, a, c);
      PVector normalPointL = getNormalPoint(predictLocL, a, c);
      // Check if normal is on line segment
      PVector dir = PVector.sub(c, a);
      // If it's not within the line segment, consider the normal to just be the end of the line segment (point b)
      if (normalPointR.x < min(a.x, c.x) || normalPointR.x > max(a.x, c.x) 
        || normalPointR.y < min(a.y, c.y) || normalPointR.y > max(a.y, c.y)) {
        normalPointR = c.get();
      }
      if (normalPointL.x < min(a.x, c.x) || normalPointL.x > max(a.x, c.x) 
        || normalPointL.y < min(a.y, c.y) || normalPointL.y > max(a.y, c.y)) {
        normalPointL = c.get();
      }
      // How far away are we from the path?
      float dR = PVector.dist(predictLocR, normalPointR);
      float dL = PVector.dist(predictLocL, normalPointL);
      // Did we beat the worldRecord and find the closest line segment?
      if (dR < worldRecordR) {
        worldRecordR = dR;
        normalR = normalPointR;
        // Look at the direction of the line segment so we can seek a little bit ahead of the normal
        dir.normalize();
        dir.mult(25);
        targetR = normalR.get();
        targetR.add(dir);
      }
      if (dL < worldRecordL) {
        worldRecordL = dL;
        normalL = normalPointL;
      }
    }
    // Bench 4 Avoidance within Building Avoidance.
    for (int i = 0; i < ben.benchPoints3.size(); i++) {
      // Look at a line segment
      PVector a = ben.benchPoints3.get(i);
      PVector c = ben.benchPoints3.get((i+1)%ben.benchPoints3.size());
      // Get the normal point to that line
      PVector normalPointR = getNormalPoint(predictLocR, a, c);
      PVector normalPointL = getNormalPoint(predictLocL, a, c);
      // Check if normal is on line segment
      PVector dir = PVector.sub(c, a);
      // If it's not within the line segment, consider the normal to just be the end of the line segment (point b)
      if (normalPointR.x < min(a.x, c.x) || normalPointR.x > max(a.x, c.x) 
        || normalPointR.y < min(a.y, c.y) || normalPointR.y > max(a.y, c.y)) {
        normalPointR = c.get();
      }
      if (normalPointL.x < min(a.x, c.x) || normalPointL.x > max(a.x, c.x) 
        || normalPointL.y < min(a.y, c.y) || normalPointL.y > max(a.y, c.y)) {
        normalPointL = c.get();
      }
      // How far away are we from the path?
      float dR = PVector.dist(predictLocR, normalPointR);
      float dL = PVector.dist(predictLocL, normalPointL);
      // Did we beat the worldRecord and find the closest line segment?
      if (dR < worldRecordR) {
        worldRecordR = dR;
        normalR = normalPointR;
        // Look at the direction of the line segment so we can seek a little bit ahead of the normal
        dir.normalize();
        dir.mult(25);
        targetR = normalR.get();
        targetR.add(dir);
      }
      if (dL < worldRecordL) {
        worldRecordL = dL;
        normalL = normalPointL;
      }
    }
    // Bench 4 Avoidance within Building Avoidance.
    for (int i = 0; i < ben.benchPoints4.size(); i++) {
      // Look at a line segment
      PVector a = ben.benchPoints4.get(i);
      PVector c = ben.benchPoints4.get((i+1)%ben.benchPoints4.size());
      // Get the normal point to that line
      PVector normalPointR = getNormalPoint(predictLocR, a, c);
      PVector normalPointL = getNormalPoint(predictLocL, a, c);
      // Check if normal is on line segment
      PVector dir = PVector.sub(c, a);
      // If it's not within the line segment, consider the normal to just be the end of the line segment (point b)
      if (normalPointR.x < min(a.x, c.x) || normalPointR.x > max(a.x, c.x) 
        || normalPointR.y < min(a.y, c.y) || normalPointR.y > max(a.y, c.y)) {
        normalPointR = c.get();
      }
      if (normalPointL.x < min(a.x, c.x) || normalPointL.x > max(a.x, c.x) 
        || normalPointL.y < min(a.y, c.y) || normalPointL.y > max(a.y, c.y)) {
        normalPointL = c.get();
      }
      // How far away are we from the path?
      float dR = PVector.dist(predictLocR, normalPointR);
      float dL = PVector.dist(predictLocL, normalPointL);
      // Did we beat the worldRecord and find the closest line segment?
      if (dR < worldRecordR) {
        worldRecordR = dR;
        normalR = normalPointR;
        // Look at the direction of the line segment so we can seek a little bit ahead of the normal
        dir.normalize();
        dir.mult(25);
        targetR = normalR.get();
        targetR.add(dir);
      }
      if (dL < worldRecordL) {
        worldRecordL = dL;
        normalL = normalPointL;
      }
    }
    // Bench 5 Avoidance within Building Avoidance.
    for (int i = 0; i < ben.benchPoints5.size(); i++) {
      // Look at a line segment
      PVector a = ben.benchPoints5.get(i);
      PVector c = ben.benchPoints5.get((i+1)%ben.benchPoints5.size());
      // Get the normal point to that line
      PVector normalPointR = getNormalPoint(predictLocR, a, c);
      PVector normalPointL = getNormalPoint(predictLocL, a, c);
      // Check if normal is on line segment
      PVector dir = PVector.sub(c, a);
      // If it's not within the line segment, consider the normal to just be the end of the line segment (point b)
      if (normalPointR.x < min(a.x, c.x) || normalPointR.x > max(a.x, c.x) 
        || normalPointR.y < min(a.y, c.y) || normalPointR.y > max(a.y, c.y)) {
        normalPointR = c.get();
      }
      if (normalPointL.x < min(a.x, c.x) || normalPointL.x > max(a.x, c.x) 
        || normalPointL.y < min(a.y, c.y) || normalPointL.y > max(a.y, c.y)) {
        normalPointL = c.get();
      }
      // How far away are we from the path?
      float dR = PVector.dist(predictLocR, normalPointR);
      float dL = PVector.dist(predictLocL, normalPointL);
      // Did we beat the worldRecord and find the closest line segment?
      if (dR < worldRecordR) {
        worldRecordR = dR;
        normalR = normalPointR;
        // Look at the direction of the line segment so we can seek a little bit ahead of the normal
        dir.normalize();
        dir.mult(25);
        targetR = normalR.get();
        targetR.add(dir);
      }
      if (dL < worldRecordL) {
        worldRecordL = dL;
        normalL = normalPointL;
      }
    }
    // Bench 6 Avoidance within Building Avoidance.
    for (int i = 0; i < ben.benchPoints6.size(); i++) {
      // Look at a line segment
      PVector a = ben.benchPoints6.get(i);
      PVector c = ben.benchPoints6.get((i+1)%ben.benchPoints6.size());
      // Get the normal point to that line
      PVector normalPointR = getNormalPoint(predictLocR, a, c);
      PVector normalPointL = getNormalPoint(predictLocL, a, c);
      // Check if normal is on line segment
      PVector dir = PVector.sub(c, a);
      // If it's not within the line segment, consider the normal to just be the end of the line segment (point b)
      if (normalPointR.x < min(a.x, c.x) || normalPointR.x > max(a.x, c.x) 
        || normalPointR.y < min(a.y, c.y) || normalPointR.y > max(a.y, c.y)) {
        normalPointR = c.get();
      }
      if (normalPointL.x < min(a.x, c.x) || normalPointL.x > max(a.x, c.x) 
        || normalPointL.y < min(a.y, c.y) || normalPointL.y > max(a.y, c.y)) {
        normalPointL = c.get();
      }
      // How far away are we from the path?
      float dR = PVector.dist(predictLocR, normalPointR);
      float dL = PVector.dist(predictLocL, normalPointL);
      // Did we beat the worldRecord and find the closest line segment?
      if (dR < worldRecordR) {
        worldRecordR = dR;
        normalR = normalPointR;
        // Look at the direction of the line segment so we can seek a little bit ahead of the normal
        dir.normalize();
        dir.mult(25);
        targetR = normalR.get();
        targetR.add(dir);
      }
      if (dL < worldRecordL) {
        worldRecordL = dL;
        normalL = normalPointL;
      }
    }
    // Bench 7 Avoidance within Building Avoidance.
    for (int i = 0; i < ben.benchPoints7.size(); i++) {
      // Look at a line segment
      PVector a = ben.benchPoints7.get(i);
      PVector c = ben.benchPoints7.get((i+1)%ben.benchPoints7.size());
      // Get the normal point to that line
      PVector normalPointR = getNormalPoint(predictLocR, a, c);
      PVector normalPointL = getNormalPoint(predictLocL, a, c);
      // Check if normal is on line segment
      PVector dir = PVector.sub(c, a);
      // If it's not within the line segment, consider the normal to just be the end of the line segment (point b)
      if (normalPointR.x < min(a.x, c.x) || normalPointR.x > max(a.x, c.x) 
        || normalPointR.y < min(a.y, c.y) || normalPointR.y > max(a.y, c.y)) {
        normalPointR = c.get();
      }
      if (normalPointL.x < min(a.x, c.x) || normalPointL.x > max(a.x, c.x) 
        || normalPointL.y < min(a.y, c.y) || normalPointL.y > max(a.y, c.y)) {
        normalPointL = c.get();
      }
      // How far away are we from the path?
      float dR = PVector.dist(predictLocR, normalPointR);
      float dL = PVector.dist(predictLocL, normalPointL);
      // Did we beat the worldRecord and find the closest line segment?
      if (dR < worldRecordR) {
        worldRecordR = dR;
        normalR = normalPointR;
        // Look at the direction of the line segment so we can seek a little bit ahead of the normal
        dir.normalize();
        dir.mult(25);
        targetR = normalR.get();
        targetR.add(dir);
      }
      if (dL < worldRecordL) {
        worldRecordL = dL;
        normalL = normalPointL;
      }
    }



    // Draw the debugging stuff
    if (debug) {// "b" key is pressed
      // Draw predicted future locations
      stroke(50);
      strokeWeight(0.5);
      fill(100, 100);
      line(location.x, location.y, predictLocR.x, predictLocR.y);
      ellipse(predictLocR.x, predictLocR.y, 4, 4);
      line(location.x, location.y, predictLocL.x, predictLocL.y);
      ellipse(predictLocL.x, predictLocL.y, 4, 4);
      ellipse(normalR.x, normalR.y, 4, 4);
      ellipse(normalL.x, normalL.y, 4, 4);
      //      // Draw actual target (red if steering towards it)
      line(predictLocR.x, predictLocR.y, normalR.x, normalR.y);
      line(predictLocL.x, predictLocL.y, normalL.x, normalL.y);
      if ((worldRecordR < b.radius) || (worldRecordR < ben.radius)) fill(255, 0, 0);
      if ((worldRecordL < b.radius) || (worldRecordL < ben.radius)) fill(0, 255, 0);
      noStroke();
      ellipse(normalR.x, normalR.y, 8, 8);
      ellipse(normalL.x, normalL.y, 8, 8);
    }

    // Only if the distance is less than the path's radius do we bother to steer

    if ((worldRecordR < b.radius) || (worldRecordR < ben.radius)) {
      steer.add(predictLocR);
      steer.sub(normalR);
      //steer.normalize();
      //steer.mult(topspeed);
      steer.limit(maxforce);
      return steer;
    } 
    if ((worldRecordL < b.radius) || (worldRecordL < ben.radius)) {

      steer.add(predictLocL);
      steer.sub(normalL);
      //steer.normalize();
      //steer.mult(topspeed);
      steer.limit(maxforce);
      return steer;
    }
    else {
      return new PVector(0, 0);
    }
  }
  // A function to get the normal point from a point (p) to a line segment (a-b)
  // This function could be optimized to make fewer new Vector objects
  PVector getNormalPoint(PVector b, PVector a, PVector c) {
    // Vector from a to p
    PVector ab = PVector.sub(b, a);
    // Vector from a to b
    PVector ac = PVector.sub(c, a);
    ac.normalize(); // Normalize the line
    // Project vector "diff" onto line by using the dot product
    ac.mult(ab.dot(ac));
    PVector normalPoint = PVector.add(a, ac);
    return normalPoint;
  }
}

