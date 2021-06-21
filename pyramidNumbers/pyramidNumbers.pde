
import peasy.PeasyCam;


PeasyCam cam;

public void settings() {
  size(800, 600, P3D);
}


PVector lastCord;
ArrayList<PVector> poss = new ArrayList<PVector>();


public void setup() {
  cam = new PeasyCam(this, 400);
  lastCord = new PVector(0, 0, 0);
}

int lastTick = 0;
int tickTime = 0;

int n = 0;

void draw() {
  background(51);
  lights();

  if (millis() - lastTick > tickTime) {
    lastTick = millis();

    //int calcIndex = toIndex(lastCord);
    //PVector newCord = iterateCord(lastCord);
    //lastCord = newCord;
    
    PVector newCord = toCord(n);
    int calcIndex = toIndex(newCord);    

    //PVector newCord = indexToAltCord(n);
    //int calcIndex = altCordToIndex(newCord);

    if (calcIndex != n) {
      print("failed on " + n + ", have ");
      print(newCord);
      print(", which gives index of");
      println(calcIndex);
    }

    // we store in order to draw all the cubs so far
    poss.add(newCord);
    
    n++;
  }

  for (PVector pos : poss) {
    drawBox(pos);
  }
}


void drawBox(PVector pos) {
  int boxSize = 10;

  pushMatrix();
  translate(pos.x*boxSize, pos.y*boxSize, pos.z*boxSize);
  box(boxSize);
  popMatrix();
}
