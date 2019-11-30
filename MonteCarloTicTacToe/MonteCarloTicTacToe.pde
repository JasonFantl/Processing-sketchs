

State currentState;

MonteCarloTree MCT;

int treeState = 2; //0 = watch tree grow, 1 = plays itself, 2 = play againts it
boolean playersTurn = false;

int timeToThink = 200;

int[][] blankBoard = {
  {0, 0, 0}, 
  {0, 0, 0}, 
  {0, 0, 0}};

int[][] initialBoard = {
  {0, 0, 0}, 
  {0, 1, 0}, 
  {0, 0, 0}};


void setup() {
  //fullScreen();
  size(1200, 900);
  noStroke();
  background(100);


  if (treeState == 0) {
    currentState = new State(initialBoard, 1);
  } else {
    currentState = new State(blankBoard, 1);
  }

  MCT = new MonteCarloTree(currentState);
}

boolean displayTree = true;
displayMCT displayer = new displayMCT();

void draw() {
  background(100);

  if (treeState == 0) {
    MCT.getBestMove();
    if (displayTree) {
      displayer.display(MCT.root);
    } else {
      displayer.displayMinMax(MCT.root);
    }
  } else if (treeState == 1) {
    if (currentState.checkWin() == 0) {
      MonteCarloTree newMove = new MonteCarloTree(currentState);
      int start = millis();
      while (millis() - start < timeToThink) {
        newMove.getBestMove();
      }
      currentState = newMove.getBestMove();
    } else {
      if (currentState.checkWin()== -1) blackWon++;
      else if (currentState.checkWin()== 1) whiteWon++;
      totalPlays++;
      currentState = new State(blankBoard, 1);
    }
    currentState.display();
    fill(250);
    text("black wins: " + blackWon, 10, 10);
    text("white wins: " + whiteWon, 10, 20);
    text("ties: " + (totalPlays - blackWon + whiteWon), 10, 30);
    text("total games: " + totalPlays, 10, 40);
  } else {
    if (!playersTurn) {
      MonteCarloTree newMove = new MonteCarloTree(currentState);
      int start = millis();
      while (millis() - start < timeToThink) {
        newMove.getBestMove();
      }
      currentState = newMove.getBestMove();
      playersTurn = true;
      currentState.player *= -1;
    }
    currentState.display();
  }
}

int blackWon = 0;
int whiteWon = 0;
int totalPlays = 0;

void mouseClicked() {
  displayTree = !displayTree;

  if (treeState == 2) {
    if (currentState.checkWin() != 0) {
      currentState = new State(blankBoard, 1);
      return;
    }

    if (playersTurn) {
      int y = (mouseX*3)/width;
      int x = (mouseY*3)/height;
      println(x + " " + y);
      if (currentState.board[x][y] == 0) {
        currentState.place(x, y);
        playersTurn = false;
      }
      currentState.display();
    }
  }
}
