import peasy.PeasyCam;
PeasyCam cam;


int speed = 50;

float scale = 10;

ArrayList<int[]> blocks;

void setup() {
  size(800, 800, P3D);
  noStroke();
  
  cam = new PeasyCam(this, 400);

  blocks = new ArrayList<int[]>();
  
  int n = toDeci("654321", 8);

  for (int i = 0; i < n; i++) {
   blocks.add(NToPos(i, 3)); 
  }
}


void draw() {
  background(51);
  lights();
  directionalLight(51, 102, 126, -1, 0, 0);

  //// get new block
  //if (speed > 31 && frameCount % speed == 0) {
  //  int[] pos = NToPos(n, 3);
  //  blocks.add(pos);
  //  n++;

  //  if (speed > 1) {
  //    speed--;
  //  }
  //}


  // render blocks
  for (int[] pos : blocks) {
    pushMatrix();
    translate(pos[0]*scale, pos[1]*scale, pos[2]*scale);
    box(scale);
    popMatrix();
  }
}

int[] NToPos(int n, int d) {
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


int toDeci(String str, int base)
{
    int len = str.length();
    int power = 1; // Initialize power of base
    int num = 0;  // Initialize result
    int i;
 
    // Decimal equivalent is str[len-1]*1 +
    // str[len-2]*base + str[len-3]*(base^2) + ...
    for (i = len - 1; i >= 0; i--)
    {
        num += int(str.charAt(i) - '0') * power;
        power = power * base;
    }
 
    return num;
}
