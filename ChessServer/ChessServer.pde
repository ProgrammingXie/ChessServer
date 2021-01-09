import processing.net.*;
Server myServer;

color LightBrown = #FFFFC3;
color DarkBrown  = #D8864E;

PImage WhiteRook;
PImage WhiteBishop;
PImage WhiteKnight;
PImage WhiteQueen;
PImage WhiteKing;
PImage WhitePawn;

PImage BlackRook;
PImage BlackBishop;
PImage BlackKnight;
PImage BlackQueen;
PImage BlackKing;
PImage BlackPawn;

PImage PromotionQueen;
PImage PromotionBishop;
PImage PromotionKnight;
PImage PromotionBlackRook;

boolean FirstClick = true;// Select a piece first
int row1;
int col1;
int row2;
int col2;
boolean MyTurn = false;// Sever goes second

int LandingSpotRow;
int LandingSpotCol;
boolean ActivateDetermineLandingSpot = false;
boolean ClickOptions[][] = new boolean[8][8];
boolean AbleToClick = false;

int TakeBack = 0;
int TakeBackEnemyCol;
int TakeBackEnemyRow;
int OpponentChess = 0;

int NumberOfMoves = 0;
boolean PawnPromotion = false;
int PawnPromotionSelection = 0;
int SelectQueenPromotion = 50;
int SelectBishopPromotion = 50;
int SelectKnightPromotion = 50;
int SelectRookPromotion = 50;
int SelectQueenStroke = 30;
int SelectBishopStroke = 30;
int SelectKnightStroke = 30;
int SelectRookStroke = 30;
int PromotionConfirm = 30;
int PromotionDelay = 0;
boolean Checkmate = false;

char grid[][] = {
  {'R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R'}, 
  {'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'}, 
  {'r', 'n', 'b', 'q', 'k', 'b', 'n', 'r'}
};

void setup() {
  size(800, 800);

  for (int xRow = 0; xRow < 8; xRow++){
    for (int yRow = 0; yRow < 8; yRow++){
      ClickOptions[yRow][xRow] = false;
    }
  }

  myServer = new Server(this, 1234);

  BlackRook = loadImage("blackRook.png");
  BlackBishop = loadImage("blackBishop.png");
  BlackKnight = loadImage("blackKnight.png");
  BlackQueen = loadImage("blackQueen.png");
  BlackKing = loadImage("blackKing.png");
  BlackPawn = loadImage("blackPawn.png");

  WhiteRook = loadImage("whiteRook.png");
  WhiteBishop = loadImage("whiteBishop.png");
  WhiteKnight = loadImage("whiteKnight.png");
  WhiteQueen = loadImage("whiteQueen.png");
  WhiteKing = loadImage("whiteKing.png");
  WhitePawn = loadImage("whitePawn.png");
  
  PromotionQueen = loadImage("PromotionQueen.png");
  PromotionBishop = loadImage("PromotionBishop.jpg");
  PromotionKnight = loadImage("PromotionKnight.png");
  PromotionBlackRook = loadImage("PromotionBlackRook.png");
}

void draw() {
  
  drawBoard();
  drawPieces();
  receiveMove();
  
  if (!FirstClick && grid[row1][col1] != ' ' && MyTurn){// green outer select
    PotentialSteps();
    fill(RGB,0);
    stroke(#02A05A);
    strokeWeight(4);
    rect(col1*100,row1*100,100,100,2);
  } 
  
  if (ActivateDetermineLandingSpot){
    LandingSpotRow = mouseY/100;
    LandingSpotCol = mouseX/100;
    if (ClickOptions[LandingSpotRow][LandingSpotCol]){ 
      AbleToClick = true;
    }
    else {
      AbleToClick = false;
    }
  }
  
  if (PawnPromotion){
    fill(#E5D17D);
    stroke(#0D67FF);
    strokeWeight(6);
    rect(220,80,360,640,6);
    
    fill(#0057FF);
    textAlign(CENTER,CENTER);
    textSize(34);
    text("Promotion Options",width/2,120);
        
    fill(#D35F00);
    textAlign(CENTER,CENTER);
    textSize(24);
    text("Queen",375,200);
    image(PromotionQueen,440,145,100,130);
    text("Bishop",375,325);
    image(PromotionBishop,445,275,90,110);
    text("Knight",375,450);
    image(PromotionKnight,445,383,100,130);
    text("Rook",375,570);
    image(PromotionBlackRook,445,520,110,110);
    
    strokeWeight(3);
    fill(SelectQueenPromotion);//
    stroke(SelectQueenStroke);
    rect(275,190,30,30);
    fill(SelectBishopPromotion);//
    stroke(SelectBishopStroke);
    rect(275,315,30,30);
    fill(SelectKnightPromotion);//
    stroke(SelectKnightStroke);
    rect(275,440,30,30);
    fill(SelectRookPromotion);//
    stroke(SelectRookStroke);
    rect(275,558,30,30);
    
    fill(113);
    stroke(PromotionConfirm);
    strokeWeight(4);
    rect(330,640,140,60,3);
    fill(PromotionConfirm);
    text("Confirm",width/2,665);
    
    
    if (mouseX > 275 && mouseX < 305 && mouseY > 190 && mouseY < 220){
      SelectQueenStroke = 130;
    }
    else {
      SelectQueenStroke = 30;
    }
    if (mouseX > 275 && mouseX < 305 && mouseY > 315 && mouseY < 345){
      SelectBishopStroke = 130;
    }
    else {
      SelectBishopStroke = 30;
    }
    if (mouseX > 275 && mouseX < 305 && mouseY > 440 && mouseY < 470){
      SelectKnightStroke = 130;
    }
    else {
      SelectKnightStroke = 30;
    }
    if (mouseX > 275 && mouseX < 305 && mouseY > 558 && mouseY < 588){
      SelectRookStroke = 130;
    }
    else {
      SelectRookStroke = 30;
    }
    if (mouseX > 330 && mouseX < 470 && mouseY > 640 && mouseY < 700){
      PromotionConfirm = 255;
    }
    else {
      PromotionConfirm = 30;
    }
  }
  
  //println(TakeBack);
  //println(OpponentChess);
  //println(row2,col2);

  
}
//==============================================================================================================

void drawBoard() {
  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) { 
      if ( (r%2) == (c%2) ) { 
        fill(LightBrown);
      } else { 
        fill(DarkBrown);
      }
      if (MyTurn){
        stroke(0,255,0);
      }
      else {
        stroke(255,0,0);
      }
      strokeWeight(1);
      rect(c*100, r*100, 100, 100);
    }
  }
}
//==============================================================================================================

void drawPieces() {
  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) {
      if (grid[r][c] == 'r') image (WhiteRook, c*100, r*100, 100, 100);
      if (grid[r][c] == 'R') image (BlackRook, c*100, r*100, 100, 100);
      if (grid[r][c] == 'b') image (WhiteBishop, c*100, r*100, 100, 100);
      if (grid[r][c] == 'B') image (BlackBishop, c*100, r*100, 100, 100);
      if (grid[r][c] == 'n') image (WhiteKnight, c*100, r*100, 100, 100);
      if (grid[r][c] == 'N') image (BlackKnight, c*100, r*100, 100, 100);
      if (grid[r][c] == 'q') image (WhiteQueen, c*100, r*100, 100, 100);
      if (grid[r][c] == 'Q') image (BlackQueen, c*100, r*100, 100, 100);
      if (grid[r][c] == 'k') image (WhiteKing, c*100, r*100, 100, 100);
      if (grid[r][c] == 'K') image (BlackKing, c*100, r*100, 100, 100);
      if (grid[r][c] == 'p') image (WhitePawn, c*100, r*100, 100, 100);
      if (grid[r][c] == 'P') image (BlackPawn, c*100, r*100, 100, 100);
    }
  }
}
//==============================================================================================================

void receiveMove(){
  Client myClient = myServer.available();
  if (myClient != null){
    String incoming = myClient.readString();
    int r1 = int(incoming.substring(0,1));
    int c1 = int(incoming.substring(2,3));
    int r2 = int(incoming.substring(4,5));
    int c2 = int(incoming.substring(6,7));
    TakeBack = int(incoming.substring(8,9));
    TakeBackEnemyRow = int(incoming.substring(10,11));
    TakeBackEnemyCol = int(incoming.substring(12,13));
    OpponentChess = int(incoming.substring(14,15));
    PawnPromotionSelection = int(incoming.substring(16,17));
    PromotionDelay = int(incoming.substring(18,19));
    if (TakeBack == 0){
      if (PawnPromotionSelection == 1){
        grid[r1][c1] = 'q';
      }
      else if (PawnPromotionSelection == 2){
        grid[r1][c1] = 'b';
      }
      else if (PawnPromotionSelection == 3){
        grid[r1][c1] = 'n';
      }
      else if (PawnPromotionSelection == 4){
        grid[r1][c1] = 'r';
      } 
      grid[r2][c2] = grid[r1][c1]; // make the move 
      grid[r1][c1] = ' ';// delete the piece     
      if (PromotionDelay == 0){
        MyTurn = true;
      }
    }
    else {
      grid[r1][c1] = grid[r2][c2];// takeback to the original position
      if (OpponentChess == 0){// Put Down Original Empty Space
        grid[r2][c2] = ' ';
      }
      else if (OpponentChess == 1){// Put Down Original Enemy Pawn
        grid[r2][c2] = 'P';
      }
      else if (OpponentChess == 2){// Put Down Original Enemy Rook
        grid[r2][c2] = 'R';
      }
      else if (OpponentChess == 3){// Put Down Original Enemy Knight
        grid[r2][c2] = 'N';
      }
      else if (OpponentChess == 4){// Put Down Original Enemy Bishop
        grid[r2][c2] = 'B';
      }
      else if (OpponentChess == 5){// Put Down Original Enemy Queen
        grid[r2][c2] = 'Q';
      }
      else if (OpponentChess == 6){// Put Down Original Enemy King
        grid[r2][c2] = 'K';
      }
      TakeBack = 0;
      FirstClick = true;
      ActivateDetermineLandingSpot = false;
      MyTurn = false;    
    }
    NumberOfMoves = 0;
  }
}
//==============================================================================================================

void SelectPiece(int row1, int col1){
  fill(RGB,0);
  stroke(#00713F);
  rect(row1*100,col1*100,100,100);
}
//============================================================================================

void PotentialSteps(){
  fill(#00FFFF,80);
  stroke(#009EEA);
  strokeWeight(2);  
  for (int xRow = 0; xRow < 8; xRow++){
    for (int yRow = 0; yRow < 8; yRow++){
      ClickOptions[yRow][xRow] = false;
    }
  }  
  if (grid[row1][col1] == 'P'){// Possible Black Pawn Steps
    PawnPossibleSteps();
  } 
  if (grid[row1][col1] == 'R'){// Possible Black Rook Steps
    RookPossibleSteps();
  } 
  if (grid[row1][col1] == 'N'){// Possible White Knight Steps
    KnightPossibleSteps();
  } 
  if (grid[row1][col1] == 'B'){// Possible White Bishop Steps
    BishopPossibleSteps();
  }
  if (grid[row1][col1] == 'Q'){// Possible White Queen Steps
    QueenPossibleSteps();
  }
  if (grid[row1][col1] == 'K'){// Possible White King Steps
    KingPossibleSteps();
  }
  
}
//==============================================================================================================  

void mouseReleased() {
  if (!PawnPromotion){
    if (MyTurn){
      if (FirstClick){
        row1 = mouseY/100;
        col1 = mouseX/100;
        PawnPromotionSelection = 0;// Reset Value
        PromotionDelay = 0;// Reset Value
        if (grid[row1][col1] == 'P' || grid[row1][col1] == 'R' || grid[row1][col1] == 'N' || grid[row1][col1] == 'B' || grid[row1][col1] == 'Q' || grid[row1][col1] == 'K'){
          FirstClick = false;
        }
        ActivateDetermineLandingSpot = true;
      } 
      else {
        row2 = mouseY/100;
        col2 = mouseX/100;
        if (AbleToClick){ 
          ActivateDetermineLandingSpot = false;
          if (grid[LandingSpotRow][LandingSpotCol] == 'p'){
            OpponentChess = 1;
          }
          else if (grid[LandingSpotRow][LandingSpotCol] == 'r'){
            OpponentChess = 2;
          }
          else if (grid[LandingSpotRow][LandingSpotCol] == 'n'){
            OpponentChess = 3;
          }
          else if (grid[LandingSpotRow][LandingSpotCol] == 'b'){
            OpponentChess = 4;
          }
          else if (grid[LandingSpotRow][LandingSpotCol] == 'q'){
            OpponentChess = 5;
          }
          else if (grid[LandingSpotRow][LandingSpotCol] == 'k'){// Check Opponent King
            OpponentChess = 6;
          }
          else if (grid[LandingSpotRow][LandingSpotCol] == ' '){
            OpponentChess = 0;
          }
          TakeBack = 0;
          grid[row2][col2] = grid[row1][col1];
          grid[row1][col1] = ' ';
          if (grid[row2][col2] == 'P' && row2 == 7){
            PromotionDelay = 1;
            PawnPromotion = true;
          }
          myServer.write(row1 + "," + col1 + "," + row2 + "," + col2 + "," + TakeBack + "," +  TakeBackEnemyRow + "," + TakeBackEnemyCol + "," + OpponentChess + "," + PawnPromotionSelection + "," + PromotionDelay);// send message
          
          if (!PawnPromotion){
            MyTurn = false;// Black turn ends
            FirstClick = true;
            NumberOfMoves++;
          }
        }
        else if (row2 == row1 && col2 == col1){// unselect the piece
          FirstClick = true;
        }
      }
    }
  }
  else {
    if (mouseX > 275 && mouseX < 305 && mouseY > 190 && mouseY < 220){
      PawnPromotionSelection = 1;
      SelectQueenPromotion = #14C65A;
      SelectBishopPromotion = 50;
      SelectKnightPromotion = 50;
      SelectRookPromotion = 50;
    }
    if (mouseX > 275 && mouseX < 305 && mouseY > 315 && mouseY < 345){
      PawnPromotionSelection = 2;
      SelectQueenPromotion = 50;
      SelectBishopPromotion = #14C65A;
      SelectKnightPromotion = 50;
      SelectRookPromotion = 50;
    }
    if (mouseX > 275 && mouseX < 305 && mouseY > 440 && mouseY < 470){
      PawnPromotionSelection = 3;
      SelectQueenPromotion = 50;
      SelectBishopPromotion = 50;
      SelectKnightPromotion = #14C65A;
      SelectRookPromotion = 50;
    }
    if (mouseX > 275 && mouseX < 305 && mouseY > 558 && mouseY < 588){
      PawnPromotionSelection = 4;
      SelectQueenPromotion = 50;
      SelectBishopPromotion = 50;
      SelectKnightPromotion = 50;
      SelectRookPromotion = #14C65A;
    }
    if (mouseX > 330 && mouseX < 470 && mouseY > 640 && mouseY < 700){
      PawnPromotion = false;
      if (PawnPromotionSelection == 1){
        grid[row2][col2] = 'Q';
      }
      else if (PawnPromotionSelection == 2){
        grid[row2][col2] = 'B';
      }
      else if (PawnPromotionSelection == 3){
        grid[row2][col2] = 'N';
      }
      else if (PawnPromotionSelection == 4){
         grid[row2][col2] = 'R';
      }
      PromotionDelay = 0;// Cannot take back a promotion
      NumberOfMoves = 0;
      myServer.write(row1 + "," + col1 + "," + row2 + "," + col2 + "," + TakeBack + "," +  TakeBackEnemyRow + "," + TakeBackEnemyCol + "," + OpponentChess + "," + PawnPromotionSelection + "," + PromotionDelay);// send message
      MyTurn = false;// Black turn ends
      FirstClick = true;
    }
  }
}
//============================================================================================

void keyReleased(){
  if (!PawnPromotion){
    if (!MyTurn && (key == 'z' || key == 'Z') && NumberOfMoves > 0){
      grid[row1][col1] = grid[row2][col2];// takeback to the original position
      if (OpponentChess == 0){// Take Back My Original Empty Space
        grid[row2][col2] = ' ';
      }
      else if (OpponentChess == 1){// Take Back My Original Pawn
        grid[row2][col2] = 'p';
      }
      else if (OpponentChess == 2){// Take Back My Original Rook
        grid[row2][col2] = 'r';
      }
      else if (OpponentChess == 3){// Take Back My Original Knight
        grid[row2][col2] = 'n';
      }
      else if (OpponentChess == 4){// Take Back My Original Bishop
        grid[row2][col2] = 'b';
      }
      else if (OpponentChess == 5){// Take Back My Original Queen
        grid[row2][col2] = 'q';
      }
      else if (OpponentChess == 6){// Take Back My Original King
        grid[row2][col2] = 'k';
      }
      NumberOfMoves = 0;
      MyTurn = true;
      TakeBack = 1;
      myServer.write(row1 + "," + col1 + "," + row2 + "," + col2 + "," + TakeBack + "," +  TakeBackEnemyRow + "," + TakeBackEnemyCol + "," + OpponentChess + "," + PawnPromotionSelection + "," + PromotionDelay);// send message
    }
  }
  else {
    if (key == 'Q' || key == 'q'){
      PawnPromotionSelection = 1;
      SelectQueenPromotion = #14C65A;
      SelectBishopPromotion = 50;
      SelectKnightPromotion = 50;
      SelectRookPromotion = 50;
    }
    if (key == 'B' || key == 'b'){
      PawnPromotionSelection = 2;
      SelectQueenPromotion = 50;
      SelectBishopPromotion = #14C65A;
      SelectKnightPromotion = 50;
      SelectRookPromotion = 50;
    }
    if (key == 'K' || key == 'k'){
      PawnPromotionSelection = 3;
      SelectQueenPromotion = 50;
      SelectBishopPromotion = 50;
      SelectKnightPromotion = #14C65A;
      SelectRookPromotion = 50;
    }
    if (key == 'R' || key == 'r'){
      PawnPromotionSelection = 4;
      SelectQueenPromotion = 50;
      SelectBishopPromotion = 50;
      SelectKnightPromotion = 50;
      SelectRookPromotion = #14C65A;
    }
  }
}
//============================================================================================

void PawnPossibleSteps(){
  if (row1 == 1 && grid[row1+1][col1] == ' ' && grid[row1+2][col1] == ' '){// pawn go 2 steps
    rect(col1*100,(row1+2)*100,100,100);
    ClickOptions[row1+1][col1] = true;
    ClickOptions[row1+2][col1] = true;
  }
  if (col1 != 7 && (grid[row1+1][col1+1] == 'p' || grid[row1+1][col1+1] == 'r' || grid[row1+1][col1+1] == 'n' || grid[row1+1][col1+1] == 'b' || grid[row1+1][col1+1] == 'q' || grid[row1+1][col1+1] == 'k')){// pawen eats right
    rect((col1+1)*100,(row1+1)*100,100,100);
    ClickOptions[row1+1][col1+1] = true;
  }
  if (col1 != 0 && (grid[row1+1][col1-1] == 'p' || grid[row1+1][col1-1] == 'r' || grid[row1+1][col1-1] == 'n' || grid[row1+1][col1-1] == 'b' || grid[row1+1][col1-1] == 'q' || grid[row1+1][col1-1] == 'k')){// pawn eats left
    rect((col1-1)*100,(row1+1)*100,100,100);
    ClickOptions[row1+1][col1-1] = true;
  }
  if (grid[row1+1][col1] == ' '){// pawn go 1 step
    rect(col1*100,(row1+1)*100,100,100);
    ClickOptions[row1+1][col1] = true;
  }
}
//============================================================================================

void RookPossibleSteps(){
  for (int yUp = 1; yUp < row1+1; yUp++){// Vertical Up Possible Steps
    if (grid[row1-yUp][col1] == ' ' || grid[row1-yUp][col1] == 'p' || grid[row1-yUp][col1] == 'r' || grid[row1-yUp][col1] == 'n' ||grid[row1-yUp][col1] == 'b' || grid[row1-yUp][col1] == 'q' || grid[row1-yUp][col1] == 'k'){
      rect(col1*100,(row1-yUp)*100,100,100);
      ClickOptions[row1-yUp][col1] = true;
      if(grid[row1-yUp][col1] == 'p' || grid[row1-yUp][col1] == 'r' || grid[row1-yUp][col1] == 'n' ||grid[row1-yUp][col1] == 'b' || grid[row1-yUp][col1] == 'q' || grid[row1-yUp][col1] == 'k'){
        break;
      }
    }
    else {
     break;
    }
  }
  for (int yDown = 1; yDown < 8-row1; yDown++){// Vertical Down Possible Steps
    if (grid[row1+yDown][col1] == ' ' || grid[row1+yDown][col1] == 'p' || grid[row1+yDown][col1] == 'r' || grid[row1+yDown][col1] == 'n' ||grid[row1+yDown][col1] == 'b' || grid[row1+yDown][col1] == 'q' || grid[row1+yDown][col1] == 'k'){
      rect(col1*100,(row1+yDown)*100,100,100);
      ClickOptions[row1+yDown][col1] = true;
      if (grid[row1+yDown][col1] == 'p' || grid[row1+yDown][col1] == 'r' || grid[row1+yDown][col1] == 'n' ||grid[row1+yDown][col1] == 'b' || grid[row1+yDown][col1] == 'q' || grid[row1+yDown][col1] == 'k'){
        break;
      }
    }
    else {
     break;
    }
  }
  for (int xRight = 1; xRight < 8-col1; xRight++){// Horizontal Right Possible Steps
    if (grid[row1][col1+xRight] == ' ' || grid[row1][col1+xRight] == 'p' || grid[row1][col1+xRight] == 'r' || grid[row1][col1+xRight] == 'n' ||grid[row1][col1+xRight] == 'b' || grid[row1][col1+xRight] == 'q' || grid[row1][col1+xRight] == 'k'){
      rect((col1+xRight)*100,(row1)*100,100,100);
      ClickOptions[row1][col1+xRight] = true;
      if (grid[row1][col1+xRight] == 'p' || grid[row1][col1+xRight] == 'r' || grid[row1][col1+xRight] == 'n' ||grid[row1][col1+xRight] == 'b' || grid[row1][col1+xRight] == 'q' || grid[row1][col1+xRight] == 'k'){
        break;
      }
    }
    else {
     break;
    }
  }
  for (int xLeft = 1; xLeft < col1+1; xLeft++){// Horizontal Left Possible Steps
    if (grid[row1][col1-xLeft] == ' ' || grid[row1][col1-xLeft] == 'p' || grid[row1][col1-xLeft] == 'r' || grid[row1][col1-xLeft] == 'n' ||grid[row1][col1-xLeft] == 'b' || grid[row1][col1-xLeft] == 'q' || grid[row1][col1-xLeft] == 'k'){
      rect((col1-xLeft)*100,(row1)*100,100,100);
      ClickOptions[row1][col1-xLeft] = true;
      if (grid[row1][col1-xLeft] == 'p' || grid[row1][col1-xLeft] == 'r' || grid[row1][col1-xLeft] == 'n' ||grid[row1][col1-xLeft] == 'b' || grid[row1][col1-xLeft] == 'q' || grid[row1][col1-xLeft] == 'k'){
        break;
      }
    }
    else {
     break;
    }
  }
}
//============================================================================================

void KnightPossibleSteps(){
  if (row1 >= 2 && col1 <= 6){ // Top Top Right
    if (grid[row1-2][col1+1] == ' ' || grid[row1-2][col1+1] == 'p' || grid[row1-2][col1+1] == 'r' || grid[row1-2][col1+1] == 'n' ||grid[row1-2][col1+1] == 'b' || grid[row1-2][col1+1] == 'q' || grid[row1-2][col1+1] == 'k'){
      rect((col1+1)*100,(row1-2)*100,100,100);
      ClickOptions[row1-2][col1+1] = true;
    }
  }
  if (row1 >= 1 && col1 <= 5){// Right Top Right
    if (grid[row1-1][col1+2] == ' ' || grid[row1-1][col1+2] == 'p' || grid[row1-1][col1+2] == 'r' || grid[row1-1][col1+2] == 'n' ||grid[row1-1][col1+2] == 'b' || grid[row1-1][col1+2] == 'q' || grid[row1-1][col1+2] == 'k'){
      rect((col1+2)*100,(row1-1)*100,100,100);
      ClickOptions[row1-1][col1+2] = true;
    }
  }
  if (row1 <= 6 && col1 <= 5){// Right Bottom Right
    if (grid[row1+1][col1+2] == ' ' || grid[row1+1][col1+2] == 'p' || grid[row1+1][col1+2] == 'r' || grid[row1+1][col1+2] == 'n' ||grid[row1+1][col1+2] == 'b' || grid[row1+1][col1+2] == 'q' || grid[row1+1][col1+2] == 'k'){
      rect((col1+2)*100,(row1+1)*100,100,100);
      ClickOptions[row1+1][col1+2] = true;
    }
  }
  if (row1 <= 5 && col1 <= 6){// Bottom Bottom Right
    if (grid[row1+2][col1+1] == ' ' || grid[row1+2][col1+1] == 'p' || grid[row1+2][col1+1] == 'r' || grid[row1+2][col1+1] == 'n' ||grid[row1+2][col1+1] == 'b' || grid[row1+2][col1+1] == 'q' || grid[row1+2][col1+1] == 'k'){
      rect((col1+1)*100,(row1+2)*100,100,100);
      ClickOptions[row1+2][col1+1] = true;
    }
  }
  if (row1 >= 2 && col1 >= 1){// Top Top Left
    if (grid[row1-2][col1-1] == ' ' || grid[row1-2][col1-1] == 'p' || grid[row1-2][col1-1] == 'r' || grid[row1-2][col1-1] == 'n' ||grid[row1-2][col1-1] == 'b' || grid[row1-2][col1-1] == 'q' || grid[row1-2][col1-1] == 'k'){
      rect((col1-1)*100,(row1-2)*100,100,100);
      ClickOptions[row1-2][col1-1] = true;
    }
  }
  if (row1 >= 1 && col1 >= 2){// Left top Left
    if (grid[row1-1][col1-2] == ' ' || grid[row1-1][col1-2] == 'p' || grid[row1-1][col1-2] == 'r' || grid[row1-1][col1-2] == 'n' ||grid[row1-1][col1-2] == 'b' || grid[row1-1][col1-2] == 'q' || grid[row1-1][col1-2] == 'k'){
      rect((col1-2)*100,(row1-1)*100,100,100);
      ClickOptions[row1-1][col1-2] = true;
    }
  }
  if (row1 <= 6 && col1 >= 2){// Left Bottom Left
    if (grid[row1+1][col1-2] == ' ' || grid[row1+1][col1-2] == 'p' || grid[row1+1][col1-2] == 'r' || grid[row1+1][col1-2] == 'n' ||grid[row1+1][col1-2] == 'b' || grid[row1+1][col1-2] == 'q' || grid[row1+1][col1-2] == 'k'){
      rect((col1-2)*100,(row1+1)*100,100,100);
      ClickOptions[row1+1][col1-2] = true;
    }
  }
  if (row1 <= 5 && col1 >= 1){// Bottom Bottom Left
    if (grid[row1+2][col1-1] == ' ' || grid[row1+2][col1-1] == 'p' || grid[row1+2][col1-1] == 'r' || grid[row1+2][col1-1] == 'n' ||grid[row1+2][col1-1] == 'b' || grid[row1+2][col1-1] == 'q' || grid[row1+2][col1-1] == 'k'){
      rect((col1-1)*100,(row1+2)*100,100,100);
      ClickOptions[row1+2][col1-1] = true;
    }
  }
}
//============================================================================================

void BishopPossibleSteps(){
  int TopRightLimit;
  if ((7-col1) < row1){
    TopRightLimit = 7-col1;
  }
  else {
    TopRightLimit = row1;
  }  
  for (int TopRight = 1; TopRight <= TopRightLimit; TopRight++){// TopLeft 
    if (grid[row1-TopRight][col1+TopRight] == ' ' || grid[row1-TopRight][col1+TopRight] == 'p' || grid[row1-TopRight][col1+TopRight] == 'r' || grid[row1-TopRight][col1+TopRight] == 'n' ||grid[row1-TopRight][col1+TopRight] == 'b' || grid[row1-TopRight][col1+TopRight] == 'q' || grid[row1-TopRight][col1+TopRight] == 'k'){
      rect((col1+TopRight)*100,(row1-TopRight)*100,100,100);   
      ClickOptions[row1-TopRight][col1+TopRight] = true;
      if (grid[row1-TopRight][col1+TopRight] == 'p' || grid[row1-TopRight][col1+TopRight] == 'r' || grid[row1-TopRight][col1+TopRight] == 'n' ||grid[row1-TopRight][col1+TopRight] == 'b' || grid[row1-TopRight][col1+TopRight] == 'q' || grid[row1-TopRight][col1+TopRight] == 'k'){
        break;
      }
    }
    else {
      break;
    }
  }
  int TopLeftLimit;
  if (col1 < row1){
    TopLeftLimit = col1;
  }
  else {
    TopLeftLimit = row1;
  }
  for (int TopLeft = 1; TopLeft <= TopLeftLimit; TopLeft++){
    if (grid[row1-TopLeft][col1-TopLeft] == ' ' || grid[row1-TopLeft][col1-TopLeft] == 'p' || grid[row1-TopLeft][col1-TopLeft] == 'r' || grid[row1-TopLeft][col1-TopLeft] == 'n' ||grid[row1-TopLeft][col1-TopLeft] == 'b' || grid[row1-TopLeft][col1-TopLeft] == 'q' || grid[row1-TopLeft][col1-TopLeft] == 'k'){
      rect((col1-TopLeft)*100,(row1-TopLeft)*100,100,100);   
      ClickOptions[row1-TopLeft][col1-TopLeft] = true;
      if (grid[row1-TopLeft][col1-TopLeft] == 'p' || grid[row1-TopLeft][col1-TopLeft] == 'r' || grid[row1-TopLeft][col1-TopLeft] == 'n' ||grid[row1-TopLeft][col1-TopLeft] == 'b' || grid[row1-TopLeft][col1-TopLeft] == 'q' || grid[row1-TopLeft][col1-TopLeft] == 'k'){
        break;
      }
    }
    else {
      break;
    }
  }
  int BottomRightLimit;
  if ((7-col1) < (7-row1)){
    BottomRightLimit = 7-col1;
  }
  else {
    BottomRightLimit = 7-row1;
  }
  for (int BottomRight = 1; BottomRight <= BottomRightLimit; BottomRight++){
    if (grid[row1+BottomRight][col1+BottomRight] == ' ' || grid[row1+BottomRight][col1+BottomRight] == 'p' ||grid[row1+BottomRight][col1+BottomRight] == 'r' || grid[row1+BottomRight][col1+BottomRight] == 'n' ||grid[row1+BottomRight][col1+BottomRight] == 'b' || grid[row1+BottomRight][col1+BottomRight] == 'q' || grid[row1+BottomRight][col1+BottomRight] == 'k'){
      rect((col1+BottomRight)*100,(row1+BottomRight)*100,100,100);
      ClickOptions[row1+BottomRight][col1+BottomRight] = true;
      if (grid[row1+BottomRight][col1+BottomRight] == 'p' ||grid[row1+BottomRight][col1+BottomRight] == 'r' || grid[row1+BottomRight][col1+BottomRight] == 'n' ||grid[row1+BottomRight][col1+BottomRight] == 'b' || grid[row1+BottomRight][col1+BottomRight] == 'q' || grid[row1+BottomRight][col1+BottomRight] == 'k'){
        break;
      }
    }
    else {
      break;
    }
  }
  int BottomLeftLimit;
  if ((7-row1) < col1){
    BottomLeftLimit = 7-row1;
  }
  else{
    BottomLeftLimit = col1;
  }
  for (int BottomLeft = 1; BottomLeft <= BottomLeftLimit; BottomLeft++){
    if (grid[row1+BottomLeft][col1-BottomLeft] == ' ' || grid[row1+BottomLeft][col1-BottomLeft] == 'p' ||grid[row1+BottomLeft][col1-BottomLeft] == 'r' || grid[row1+BottomLeft][col1-BottomLeft] == 'n' ||grid[row1+BottomLeft][col1-BottomLeft] == 'b' || grid[row1+BottomLeft][col1-BottomLeft] == 'q' || grid[row1+BottomLeft][col1-BottomLeft] == 'k'){
      rect((col1-BottomLeft)*100,(row1+BottomLeft)*100,100,100);   
      ClickOptions[row1+BottomLeft][col1-BottomLeft] = true;
      if (grid[row1+BottomLeft][col1-BottomLeft] == 'p' ||grid[row1+BottomLeft][col1-BottomLeft] == 'r' || grid[row1+BottomLeft][col1-BottomLeft] == 'n' ||grid[row1+BottomLeft][col1-BottomLeft] == 'b' || grid[row1+BottomLeft][col1-BottomLeft] == 'q' || grid[row1+BottomLeft][col1-BottomLeft] == 'k'){
        break;
      }
    }
    else {
      break;
    }
  }
}
//============================================================================================

void QueenPossibleSteps(){
  BishopPossibleSteps();
  RookPossibleSteps();
}
//============================================================================================

void KingPossibleSteps(){
  if (col1 > 0){// Left
    if (grid[row1][col1-1] == ' ' || grid[row1][col1-1] == 'p' ||grid[row1][col1-1] == 'r' || grid[row1][col1-1] == 'n' ||grid[row1][col1-1] == 'b' || grid[row1][col1-1] == 'q' || grid[row1][col1-1] == 'k'){
      rect((col1-1)*100,(row1)*100,100,100);   
      ClickOptions[row1][col1-1] = true;
    }
  }
  if (col1 < 7){// Rright
    if (grid[row1][col1+1] == ' ' || grid[row1][col1+1] == 'p' ||grid[row1][col1+1] == 'r' || grid[row1][col1+1] == 'n' ||grid[row1][col1+1] == 'b' || grid[row1][col1+1] == 'q' || grid[row1][col1+1] == 'k'){
      rect((col1+1)*100,(row1)*100,100,100);  
      ClickOptions[row1][col1+1] = true;
    }
  }
  if (row1 > 0){// Top
    if (grid[row1-1][col1] == ' ' || grid[row1-1][col1] == 'p' ||grid[row1-1][col1] == 'r' || grid[row1-1][col1] == 'n' ||grid[row1-1][col1] == 'b' || grid[row1-1][col1] == 'q' || grid[row1-1][col1] == 'k'){
      rect((col1)*100,(row1-1)*100,100,100);  
      ClickOptions[row1-1][col1] = true;
    }
  }
  if (row1 < 7){// Bottom
    if (grid[row1+1][col1] == ' ' || grid[row1+1][col1] == 'p' ||grid[row1+1][col1] == 'r' || grid[row1+1][col1] == 'n' ||grid[row1+1][col1] == 'b' || grid[row1+1][col1] == 'q' || grid[row1+1][col1] == 'k'){
      rect((col1)*100,(row1+1)*100,100,100);   
      ClickOptions[row1+1][col1] = true;
    }
  }
  if (col1 > 0 && row1 > 0){// Top Left
    if (grid[row1-1][col1-1] == ' ' || grid[row1-1][col1-1] == 'p' ||grid[row1-1][col1-1] == 'r' || grid[row1-1][col1-1] == 'n' ||grid[row1-1][col1-1] == 'b' || grid[row1-1][col1-1] == 'q' || grid[row1-1][col1-1] == 'k'){
      rect((col1-1)*100,(row1-1)*100,100,100);  
      ClickOptions[row1-1][col1-1] = true;
    }
  }
  if (col1 > 0 && row1 < 7){// Left Bottom
    if (grid[row1+1][col1-1] == ' ' || grid[row1+1][col1-1] == 'p' ||grid[row1+1][col1-1] == 'r' || grid[row1+1][col1-1] == 'n' ||grid[row1+1][col1-1] == 'b' || grid[row1+1][col1-1] == 'q' || grid[row1+1][col1-1] == 'k'){
      rect((col1-1)*100,(row1+1)*100,100,100);   
      ClickOptions[row1+1][col1-1] = true;
    }
  }
  if (col1 < 7 && row1 > 0){// Right Top
    if (grid[row1-1][col1+1] == ' ' || grid[row1-1][col1+1] == 'p' ||grid[row1-1][col1+1] == 'r' || grid[row1-1][col1+1] == 'n' ||grid[row1-1][col1+1] == 'b' || grid[row1-1][col1+1] == 'q' || grid[row1-1][col1+1] == 'k'){
      rect((col1+1)*100,(row1-1)*100,100,100);  
      ClickOptions[row1-1][col1+1] = true;
    }
  }
  if (col1 < 7 && row1 < 7){// Right Bottom
    if (grid[row1+1][col1+1] == ' ' || grid[row1+1][col1+1] == 'p' ||grid[row1+1][col1+1] == 'r' || grid[row1+1][col1+1] == 'n' ||grid[row1+1][col1+1] == 'b' || grid[row1+1][col1+1] == 'q' || grid[row1+1][col1+1] == 'k'){
      rect((col1+1)*100,(row1+1)*100,100,100);   
      ClickOptions[row1+1][col1+1] = true;
    }
  } 
}
