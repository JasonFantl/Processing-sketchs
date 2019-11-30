char[] alphabet = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'};
String[] morsecode = {".-", "-...", "-.-.", "-..", ".", "..-.", "--.", "....", "..", ".---", "-.-", ".-..", "--", "-.", "---", ".--.", "--.-", ".-.", "...", "-", "..-", "...-", ".--", "-..-", "-.--", "--.."};

String outputM = "";
String outputA = "";

String currentM = "";
String currentA = "";

int dot = 500; //in milliseconds
int space = 7 * dot;
int newLetter = 3 * dot;

void setup() {

  size(400, 200);
}

boolean pressed = false;
int timer = 0;

void draw() {
  if (mousePressed == true) { //while mouse is down

    if (pressed == false) { //just switched from not pressing to pressing
      if (currentM != "_") { //ignore time in-between dots and dashes
        outputM += currentM;
      }
      timer = millis();
      println(outputM);
    }
    pressed = true;
    if (millis() - timer < dot) { //set what the result will be from releasing right now
      currentM = ".";
    } else {
      currentM = "-";
    }
  } else {
    if (pressed == true) { //just switched from pressing to not pressing
      outputM += currentM;
      timer = millis();
      println(outputM);
    }
    pressed = false;
    if (millis() - timer > space) { //set what the result will be from pressing right now
      currentM = " ";
    } else if (millis() - timer > newLetter) {
      currentM = ",";
    } else {
      currentM = "_";
    }
  }
  mToA();
  printText();
  outputA = "";
}


void mToA() {
  String[] words = split(outputM, " ");
  for (int i = 0; i < words.length; i++) {
    String[] letters = split(words[i], ",");
    for (int a = 0; a < letters.length; a++) {
      for (int j = 0; j < morsecode.length; j++) {
        String tempR = letters[a];
        if (i == words.length - 1 && a == letters.length - 1 && (currentM == "." || currentM == "-")) { //if at last letter, add current unsure result
          tempR += currentM;
        }
        if (tempR.equals(morsecode[j])) {
          outputA += alphabet[j];
        }
      }
    }
    outputA += " ";
  }
  currentA = outputA;
  println(currentA);
}


void printText() {
  background(200);
  fill(10);
  
  textSize(32);
  textAlign(RIGHT);

  text(outputM + currentM, width/2, height/2);
  text(currentA, width/2, height/3);
}
