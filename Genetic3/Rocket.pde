class Rocket {
  float fitness = 0;
  PVector location;
  PVector velocity;
  PVector acceleration;

  long startTime = System.currentTimeMillis();

  boolean destroyed = false;
  PVector start = new PVector(width/2, height/2);
  int inD = 200;
  DNA rocketDNA;
Population myPop;

  Rocket (Population inPop) {
    myPop = inPop;
    location = start;
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0.1);
    rocketDNA = new DNA(inPop);
  }

  void UpdatePos() {

    for (float[] rects : obs) {
      float xOff = rects[2];
      float yOff = rects[3];
      if (location.x > rects[0] - xOff && location.y > rects[1] - yOff && location.x < rects[0] + xOff && location.y < rects[1] + yOff) {
        destroyed = true;
      }
    }

    if (location.x < 0 || location.x > width || location.y < 0 || location.y > height) {
      destroyed = true;
    }

    if (location.x > goal.x - 10 && location.x < goal.x + 10 && location.y > goal.y - 10 && location.y < goal.y  + 10) {
      location = goal;
      destroyed = true;
      fitness = 100;
    }


    if (!destroyed) {
      acceleration.set(rocketDNA.instructions[myPop.timer % instrLength]);
      velocity.add(acceleration);
      location.add(velocity);
    }
  }

  void updateFitness() {
    if (!destroyed) {
      float neFit = (1000 / location.dist(goal)) - ((System.currentTimeMillis() - startTime) / 10000);
      if (neFit > fitness) {
        fitness = neFit;
      }
    } else {
      fitness -= 0.01;
    }
  }

  void Display () {
    pushMatrix();
    rectMode(CENTER);
    translate(location.x, location.y);
    rotate(velocity.heading());
    //rect(0, 0, 30, 5);
    strokeWeight(3);
    point(0, 0);

    popMatrix();
  }
}
