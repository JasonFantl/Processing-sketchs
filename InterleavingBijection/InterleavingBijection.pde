import peasy.PeasyCam;
PeasyCam cam;


int n = 0;
int d = 3;

int speed = 50;

float scale = 10;

ArrayList<int[]> blocks;

void setup() {
  size(400, 400, P3D);
  cam = new PeasyCam(this, 400);

  blocks = new ArrayList<int[]>();
}


void draw() {
  background(51);
  lights();
  
  // get new block
  if (frameCount % speed == 0) {
    int[] pos = NToPos();
    blocks.add(pos);
    n++;

    if (speed > 1) {
      speed--;
    }
  }


  // render blocks
  for (int[] pos : blocks) {
    pushMatrix();
    translate(pos[0]*scale, pos[1]*scale, pos[2]*scale);
    box(scale);
    popMatrix();
  }
}

int[] NToPos() {
  // convert n to binary. Can use 10, but recursive pattern takes longer to see
  String s = Integer.toBinaryString(n);

  int[] pos = new int[d];

  for (int i = 0; i < s.length(); i++) {
    int posPlace = i % d;
    int tensPlace = (i - posPlace) / d;
    int digitValue = int(s.charAt(s.length()-i-1) - '0');

    pos[posPlace] += pow(2, tensPlace)*digitValue;
  }


  return pos;
}
