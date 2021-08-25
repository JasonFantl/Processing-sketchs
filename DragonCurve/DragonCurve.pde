
void setup() {
  size(900, 500);

  points = new PVector[]{new PVector(width/4, height*0.7), new PVector(width*3/4, height*0.7)};
}

PVector[] points;

void draw() {
  background(200);
  for (int i = 0; i < points.length-1; i++) {
    line(points[i].x, points[i].y, points[i+1].x, points[i+1].y);
  }
}

void mousePressed() {
  iterateGoldenCurve();
}

void keyPressed() {
  save("curve");
  println("saved!");
}
float bigMag = 0.7427429446246816413695660476057885141497552527069779641441434078;
float smallMag = 0.5516670817897428991373945094665101561710649903290951692334613572;

float angleToBig = -0.574105428;
float angleToSmall = 0.8200600924;

void iterateGoldenCurve() {

  PVector[] newPoints = new PVector[points.length*2-1];

  for (int i = 0; i < points.length-1; i++) {
    PVector P0 = points[i];
    PVector P1 = points[i+1];
    PVector d = PVector.sub(P1, P0);

    float mag = smallMag;
    float angle = angleToSmall;
    if (i % 2 == 0) {
      mag = bigMag;
      angle = angleToBig;
    }

    PVector delta = d.mult(mag).rotate(angle);

    newPoints[i*2] = P0;
    newPoints[i*2+1] = delta.add(P0);
    newPoints[i*2+2] = P1;
  }

  points = newPoints;
}
