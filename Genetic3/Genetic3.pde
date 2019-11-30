PVector goal;
int gen = 0;
//int timer = 0;

int instrLength = 500;
boolean mutateDynamic = false;
float thrustPower = 0.4;
int numRockets = 200;

int frameSpeed = 4;

ArrayList<Population> myPops = new ArrayList<Population>();
int popCount = 10;
boolean following = false;
PVector mouse = new PVector();

ArrayList<float[]> obs = new ArrayList<float[]>();

float[] addingOb;

void setup() {
  size(displayWidth, displayHeight);
  //noStroke();
  colorMode(HSB, 255);
  goal = new PVector(width/2, 50);
  for (int i = 1; i < popCount + 1; i++) {
    myPops.add(new Population((float)i/(popCount + 1)));
  }
}

void draw() {
  fill(51, 10);
  rect(0, 0, width*2, height*2);
  for (int runs = 0; runs < frameSpeed; runs++) {

    fill(200, 200);
    strokeWeight(0);
    if (following) {
      float[] taddingOb = {startM.x, startM.y, mouse.x - startM.x, mouse.y - startM.y};
      addingOb = taddingOb;
      //rectMode(CORNER);
      rect(addingOb[0], addingOb[1], addingOb[2] * 2, addingOb[3] * 2);
    }

    updateMouse();

    rect(goal.x, goal.y, 20, 20);
    for (float[] rects : obs) {
      rect(rects[0], rects[1], rects[2] * 2, rects[3] * 2);
    }
    for (Population myPop : myPops) {
      stroke(color(255*sin(myPop.mutateRate), 255*cos(myPop.mutateRate), 255*tan(myPop.mutateRate)));
    //fill(color(255*sin(myPop.mutateRate), 255*cos(myPop.mutateRate), 255*tan(myPop.mutateRate)));
  if (myPop.stillAlive()) {//run sim
        myPop.update();
        //println("gens: " + gen + " ,timer: " + timer);
      } else { //repopulate
        myPop.printFit();
        //println(myPop.topFit());
        if (myPop.averageFit() > 85) {
          myPop.wins++;
          float x = random(width);
          float y = random(height);

          while (isInObs(x, y)) {
            x = random(width);
            y = random(height);
          }
          goal.x = x;
          goal.y = y;
        }
        gen++;
        myPop.repopulate();
      }
    }
  }
}


boolean isInObs(float inX, float inY) {
  for (float[] rects : obs) {
    float xOff = rects[2];
    float yOff = rects[3];
    if (inX > rects[0] - xOff && inY > rects[1] - yOff && inX < rects[0] + xOff && inY < rects[1] + yOff) {
      return true;
    }
  }
  return false;
}

PVector startM = new PVector(-1, -1);

void mousePressed() {
  if (mouse.y > 50 || mouse.y < height - 50) {
    following = !following;
    if (following) {
      startM = new PVector(mouse.x, mouse.y);
    } else {
      obs.add(addingOb);
    }
  }
}


void updateMouse() {
  float targetX = mouseX;
  float dx = targetX - mouse.x;
  mouse.x += dx;

  float targetY = mouseY;
  float dy = targetY - mouse.y;
  mouse.y += dy;

  ellipse(mouse.x, mouse.y, 66, 66);
}
