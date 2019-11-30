class State {

  int[][] board;
  int player;

  State(int[][] inBoard, int inPlayer) {
    player = inPlayer;
    board = copyArray(inBoard);

  }

  void placeRandom() {
    if (checkWin() == 0) {
      boolean placed = false;
      while (!placed) {
        int x = (int)random(3); 
        int y = (int)random(3); 
        if (board[x][y] == 0) {
          placed = true;
          board[x][y] = player;
        }
      }
    }
  }
  
  void place(int x, int y) {
   board[x][y] = player;
   //player *= -1;
  }

  State copyState() {
    return new State(board, player);
  }


  ArrayList<Node> getLegalMoves() {
    ArrayList<Node> returnList = new ArrayList<Node>();
    if (checkWin() == 0) {

      for (int x = 0; x < 3; x++) {
        for (int y = 0; y < 3; y++) {
          if (board[x][y] == 0) {
            int newBoard[][] = copyArray(board);
            newBoard[x][y] = -player;
            returnList.add(new Node(new State(newBoard, player * -1), 0));
          }
        }
      }
    }
    return returnList;
  }


  int checkWin() { //1 = player 1 won, -1 = player 2 won, 2 = tied, 0 = unfinished
    int tied = 2;
    int diag1 = 0, diag2 = 0;
    for (int i=0; i<3; i++) {
      int rowSum = 0;
      int colSum = 0;
      diag1 += board[i][i];
      diag2 += board[i][2-i];
      for (int j=0; j<3; j++) {
        rowSum += board[i][j];
        colSum += board[j][i];
        if (board[i][j] == 0) {
          tied = 0;
        }
      }
      if (rowSum == 3 || colSum == 3 || diag1 == 3 || diag2 == 3) {
        return 1;
      }
      if (rowSum == -3 || colSum == -3 || diag1 == -3 || diag2 == -3) {
        return -1;
      }
    }
    return tied;
  }


  void display() {
    display(width, height, width/2, height/2);
  }
  
  void display(int inW, int inH, int xOff, int yOff) {
    float offsetX = inW/6;
    float offsetY = inH/6;
    strokeWeight(2);
    stroke(0);
    fill(100);
    rect(xOff - inW/2, yOff - inH/2, inW, inH);
    noStroke();
    for (int x = 0; x < 3; x++) {
      for (int y = 0; y < 3; y++) {
        fill(100 + 100*board[y][x]);
        ellipse((x-1.5)*inW/3 + offsetX + xOff, (y-1.5)*inH/3 + offsetY + yOff, offsetX, offsetY);
      }
    }
  }

  int[][] copyArray(int[][] inBoard) {
    int newBoard[][] = new int[3][3];
    for (int x = 0; x < 3; x++) {
      for (int y = 0; y < 3; y++) {
        newBoard[x][y] = inBoard[x][y];
      }
    }
    return newBoard;
  }
}
