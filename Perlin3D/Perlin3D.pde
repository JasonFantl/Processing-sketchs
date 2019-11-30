import peasy.*;
PeasyCam cam;

int fieldSize = 100;
int boxSize = 10;

float sharpness = 0.05;
int steepness = 100;
float speed = 0.005;

ArrayList<ArrayList<box>> boxs = new ArrayList<ArrayList<box>>();

boolean boxOrVertex = true;
boolean noiseOrImg = false;

PImage img;
int filePathIndex = 1;
String fileNames[] = {"finalSupper.png", "fish.jpg", "chess.jpg", "box.jpg"};
void setup() {

  img = loadImage(fileNames[filePathIndex]);

  size(1000, 1000, P3D);
  cam = new PeasyCam(this, 100, 100, 200, 500);
  cam.setPitchRotationMode();

  noStroke();
  initialize();
}


void draw() {
  ambientLight(102, 102, 102);
  directionalLight(126, 126, 126, 0, 0, -1);

  background(51);


  for (int i = 0; i < boxs.size() - 1; i ++) {
    beginShape(TRIANGLE_STRIP);
    for (int j = 0; j < boxs.get(i).size(); j++) {
      fill(boxs.get(i).get(j).zDisplayHeight);
      boxs.get(i).get(j).update();
      boxs.get(i + 1).get(j).update();

      if (boxOrVertex) {
        boxs.get(i).get(j).displayBox();
        boxs.get(i + 1).get(j).displayBox();
      } else {
        boxs.get(i).get(j).displayVertex();
        boxs.get(i + 1).get(j).displayVertex();
      }
    }
    endShape();
  }
}


void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      steepness += 10;
      println("Steepness: " + steepness);
    } else if (keyCode == DOWN) {
      steepness -= 10;
      println("Steepness: " + steepness);
    } else if (keyCode == LEFT) {
      sharpness -= 0.01;
      println("sharpness: " + sharpness);
    } else if (keyCode == RIGHT) {
      sharpness += 0.01;
      println("sharpness: " + sharpness);
    } else if (keyCode == SHIFT) {
      speed += 0.001;
      println("speed: " + speed);
    } else if (keyCode == CONTROL) {
      speed -= 0.001;
      println("speed: " + speed);
    } else if (keyCode == TAB) {
      boxOrVertex = !boxOrVertex;
    } else if (keyCode == ALT) {
      noiseOrImg = !noiseOrImg;
      if (noiseOrImg) {
        filePathIndex++;
        filePathIndex %= fileNames.length;
        img = loadImage(fileNames[filePathIndex]);
        updateBoxs();
      }
    }
    println();
  }
}
void initialize() {

  for (int i = 0; i < fieldSize; i ++) {
    boxs.add(new ArrayList<box>());
    for (int j = 0; j < fieldSize; j ++) {
      int goal = (int)brightness(img.get((int)map(i, 0, fieldSize, 0, img.width), (int)map(j, 0, fieldSize, 0, img.height)));
      boxs.get(i).add(new box(i, j, goal));
    }
  }
}


void updateBoxs() {
  for (int i = 0; i < boxs.size(); i ++) {
    for (int j = 0; j < boxs.get(i).size(); j++) {
      int goal = (int)brightness(img.get((int)map(i, 0, fieldSize, 0, img.width), (int)map(j, 0, fieldSize, 0, img.height)));
      boxs.get(i).get(j).goal = goal;
    }
  }
}
