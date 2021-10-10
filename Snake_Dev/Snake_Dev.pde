//Dev Vora 
//1000072212
//**************Bugs/Incomplete*************//
//When the head collides with the body, the restart of game has a glitch
//The game complete part of code is remaining 
//There is no change in speed as the game progresses

//Initializing the class and creating a new object that we can call in setup and draw
snakeGame game = new snakeGame();

float cols;
float rows;



float gridSize;



void setup() {

  //Definig the grid size
  //cols * gridSize = 600
  //rows * gridSize = 600
  cols= 20;
  rows= 20;

  gridSize= 30;

  size(600, 600);
  //frameRate(7);

  //Calling Initial Snake
  game.initialiseSnake();
}



void draw() {
  stroke(0);
  strokeWeight(2);

  //To draw the grid
  game.drawGrid();
  //To draw the apples
  game.drawApples();
  //To draw the snake 
  game.drawSnake();
  game.movement(); 
  if (frameCount%15 == 0) {
    //This part is used to move the snake 
    game.snakeMove();
  }
  //To check when the snake eats the apple
  game.checkApples();
  //To check whether the snake has hit his own body
  game.checkBody();

  //To check whether the snake hits the borders
  game.checkBorders();
  //To reset the game when the game is either completed or over
  //game.reset();
}




class snakeGame {

  int snakeSize = 1;
  int maxSnakeLength = 10;

  //Defining an aray with the maximum size of the snake, as it cannot go over the certain limit(10)
  PVector[] snake = new PVector[maxSnakeLength];

  //Defining a pvector for the speed(movement of the snake)
  PVector speed = new PVector();

  int gridSize = 30;
  float width = 600;
  float height = 600;

  //Defines the position where we want the apple to show up
  PVector apple = new PVector((int)random(width/gridSize)*gridSize, (int)random(height/gridSize)*gridSize);

  int score = 0;

  //This is for gamestate
  boolean playGame = true;



  void drawGrid() {
    for (int c=0; c<cols; c++) {//for the columns
      for (int r=0; r<rows; r++) {//for the rows
        fill(255, 255, 255);
        rect(c*gridSize, r*gridSize, gridSize, gridSize);//making a grid of size of 30
      }
    }
  }


  //This method wil draw the apple in the game
  void drawApples() {
    ellipseMode(CORNER);
    fill(255, 51, 51);
    ellipse(apple.x, apple.y, gridSize, gridSize);
  }


  void initialiseSnake() {
    //This is for the head of the snake, it will be always made at the first box in the grid from the origin
    snake[0] = new PVector(0, 0); //head of the snake

    //for (int i=1; i<maxSnakeLength-1; i++) {
    //  snake[i] = snake[0];
    //}

    //for (int i=snakeSize-1; i>0; i--) {
    //  snake[i] = new PVector(snake[i-1].x, snake[i-1].y);
    //}
  }

  //This method will be used to draw the snake body, once the apple is eaten, 
  //therefore increasing the size of the snake by 1 unit
  void drawSnake() {
    for (int i=0; i<snakeSize; i++) {
      fill(56, 168, 50);
      ellipse(snake[i].x, snake[i].y, gridSize, gridSize);
      //snake[i].add(speed);
    }
  }



  void movement() {
    // This part of code will be used to change the direction of the snake
    if (keyPressed == true) {
      if (keyCode==UP) {
        if (!(speed.x == 0 && speed.y == gridSize)) { 
          //To restrict snake's movement back in the opposite direction
          speed.x=0;
          speed.y=-gridSize;
        }
      } else if (keyCode==DOWN) {
        if (!(speed.x == 0 && speed.y == -gridSize)) { 
          //To restrict snake's movement back in the opposite direction
          speed.x=0;
          speed.y=gridSize;
        }
      } else if (keyCode==LEFT) {
        if (!(speed.x == gridSize && speed.y == 0)) { 
          //To restrict snake's movement back in the opposite direction
          speed.x=-gridSize;
          speed.y=0;
        }
      } else if (keyCode==RIGHT) {
        if (!(speed.x == -gridSize && speed.y == 0)) { 
          //To restrict snake's movement back in the opposite direction
          speed.x=gridSize;
          speed.y=0;
        }
      }
    }
  }

  void snakeMove() {

    //This part of the code will be used to follow the direction of the head
    followHead();

    //This part of the code is to give the direction of the head
    snake[0].x = snake[0].x + speed.x;
    snake[0].y = snake[0].y + speed.y;
  }

  void checkApples() {
    if (snake[0].x == apple.x && snake[0].y == apple.y) {
      if (apple.x == snake[snakeSize-1].x && apple.y == snake[snakeSize-1].y) { // to avaoid overlapping of apples and snake.
        apple.x = (int)random(width/gridSize)*gridSize;
        apple.y = (int)random(width/gridSize)*gridSize;
      }

      apple.x = (int)random(width/gridSize)*gridSize;
      apple.y = (int)random(width/gridSize)*gridSize;


      score++;
      snakeSize++; // increasing the size of the snake as it eats apples
      // This will be used to check whether the game is complete or create a new PVector when the apple is eaten
      snakeGrowth();
    }
  }

  void snakeGrowth() {

    //for(int i=snakeSize-1;i>0;i--){ // why snakeSize-1? after incrementing the snakeSize in checkApples snakeSize becomes 2 so snakeSize(2)-1 =1 i.e. snake[1] = snake[0].x,snake[0].y, it will create a body at that position.

    if (snakeSize >= maxSnakeLength-1) {
    } else {
      snake[snakeSize-1] = new PVector(snake[(snakeSize-1)-1].x, snake[(snakeSize-1)-1].y);
    }
  }


  //This part of code will help the snake body follow the head
  void followHead() { //movement of body
    for (int i=snakeSize-1; i>0; i--) {
      snake[i].x = snake[i-1].x;
      snake[i].y = snake[i-1].y;
    }
  }

  //This part of the code will check the snake head with the borders
  void checkBorders() {
    if (snake[0].x>width || snake[0].x<0 || snake[0].y>height || snake[0].y<0) {
      playGame = false;
      gameOver();
    }
  }

  // If the snake head hits its own body then Game Over
  void checkBody() {
    if (snakeSize>3) {
      for (int i=2; i<snakeSize-1; i++) { 
        if (snake[0].x == snake[i].x && snake[0].y == snake[i].y) {
          speed.x=0;
          speed.y=0;
          //gameOver();
        }
      }
    }
  }

  void gameOver() {
    background(0);
    fill(0);
    rect(0, 0, width, height);

    int txtsizeScore = 40;
    int txtsizeGameOver = 50;
    int txtsizePlayAgain = 20;

    textSize(txtsizeScore);
    fill(255);
    text("Your Score: " + score, (width/3)-40, (height/2));

    textSize(txtsizeGameOver);
    fill(220, 47, 2);
    text("Game Over! ", (width/3)-50, (height/2)-150); 

    textSize(txtsizePlayAgain);
    fill(255);
    text("Game Over! Press 'Enter' to play again!!", (width/3)-90, (height/2)+150);
    reset();
  }

  void reset() {
    if (keyCode == ENTER) {
      snake[0] = new PVector(0, 0);
      score = 0;
      apple.x = (int)random(width/gridSize)*gridSize;
      apple.y = (int)random(height/gridSize)*gridSize;
      playGame=true;
    }
  }
}
