class ScoreBoard {
  float x; // x coordinate
  float y; // y coordinate
  int totalPoints; // total points from all of the bugs eaten
  
  // instantiates the scoreboard and sets the x and y 2 pixels from the edge
  ScoreBoard(){
    this.x = width - 20;
    this.y = 20;
    this.totalPoints = 0;
  }
  
  // displays the score in the top right of the screen and adjusts based on how many digits there are
  void display(){
    fill(255);
    textAlign(RIGHT, TOP);
    textSize(80);
    text("Total Points: " + totalPoints, x , y);
  }
  
  // updates the total points
  void updatePoints(int totalPoints){
    this.totalPoints = totalPoints;
  }
}
