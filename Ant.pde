class Ant extends Bug {
  float x; // ant x position
  float y; // ant y position
  float h; // ant height
  float w; // ant width
  float speed; // move speed

  PImage img_ant_left_one; // left image 1
  PImage img_ant_right_one; // right image one
  PImage img_ant_left_two; // left image two
  PImage img_ant_right_two; // right image two
  PImage img_ant_hit_left; // left hit image
  PImage img_ant_hit_right; // right hit image
 
  int costume_id;  // id to keep track of costumes

  boolean immobile; // used to stop movement if something happens to the ant
  int animationDelay; // used to set a number of frames between costume switches

  boolean isHitByTongue; // checks if the frog's tongue has hit the ant
  boolean isEaten; // used to flag when the ant gets eaten by the frog
  boolean isFacingRight; // checks if the ant is facing right to know which costume to start with
  boolean isVisible; // used to either show or not show the ant
  boolean hitFrog; // used to flag whether or not frog has been hit

  // takes in x, y, speed, and isFacingRight so that the Gamecontroller can set it to start on either the right or left side of screen
  Ant(float x, float y, float speed, boolean isFacingRight) {
    this.x = x;
    this.y = y;
    this.speed = speed;
    this.w = 100;
    this.h = 70;
    this.img_ant_left_one = loadImage("ant_left_one.png");
    this.img_ant_right_one = loadImage("ant_right_one.png");
    this.img_ant_left_two = loadImage("ant_left_two.png");
    this.img_ant_right_two = loadImage("ant_right_two.png");
    this.img_ant_hit_left = loadImage("ant_hit_left.png");
    this.img_ant_hit_right = loadImage("ant_hit_right.png");
    this.immobile = false;
    this.animationDelay = 7;
    this.isHitByTongue = false;
    this.isEaten = false;
    this.isVisible = true;
    this.isFacingRight = isFacingRight;
    // sets the costume depending on which direction it is moving
    if (isFacingRight) {
      this.costume_id = 1;
    } else {
      this.costume_id = 0;
    }
    this.hitFrog = false;
  }

  // displays the image
  void display() {
    if (isVisible) {
      imageMode(CENTER);
      image(useCostume(), x, y, w, h);
    }
  }

  // returns costume image depending on current costume_id
  PImage useCostume() {
    switch(costume_id) {
    case 0:
      return img_ant_left_one;
    case 1:
      return img_ant_right_one;
    case 2:
      return img_ant_left_two;
    case 3:
      return img_ant_right_two;
    case 4:
      return img_ant_hit_left;
    case 5:
      return img_ant_hit_right;
    default:
      return null;
    }
  }

  // calls the appropriate moveLeft or moveRight method.  Made this here to reduce code inside of GameController
  void move() {
    if (!isFacingRight && !immobile) {
      moveLeft();
    } else if (isFacingRight && !immobile) {
      moveRight();
    }
  }

  // Moves the ant left and changes the costume to mimic animation
  void moveLeft() {
    if (!immobile) {
      x -= speed;

      // changes the costume to mimic animaton
      if (frameCount % animationDelay == 0) {
        switch(costume_id) {
        case 0:
          costume_id = 2;
          break;
        case 2:
          costume_id = 0;
          break;
        }
      }
    }
  }

  // Moves the ant right and changes the costume to mimic animation
  void moveRight() {
    if (!immobile) {
      x += speed;

      // changes the costume to mimic animaton
      if (frameCount % animationDelay == 0) {
        switch(costume_id) {
        case 1:
          costume_id = 3;
          break;
        case 3:
          costume_id = 1;
          break;
        }
      }
    }
  }

  // checks for tongue hit
  boolean isHit(float tongueX, float tongueY, float tongueRadius) {
    float distance = dist(x, y, tongueX, tongueY); // calculates the distance between the bug and the tongue
    return distance < min(w, h) / 2 + tongueRadius; // if the tongue is touching, return true, so the tongue has hit the bug
  }

  // switches hitByTongue to true when the user clicks on the ant and imobilizes it before moving.
  // switches the costume to the hit image for the proper direction
  void hitByTongue() {
    immobile = true;
    isHitByTongue = true;
    switch(costume_id) {
    case 0:
      costume_id = 4;
      break;
    case 2:
      costume_id = 4;
      break;
    case 1:
      costume_id = 5;
      break;
    case 3:
      costume_id = 5;
      break;
    }
  }

  
  // moves the fly to the frog when it has been hit by the tongue
  void moveToFrog(float frogX, float frogY, float tongueSpeed) {
    float dx = frogX - x; // x distance to frog
    float dy = frogY - y; // y distance to frog
    float distance = dist(x, y, frogX, frogY); // total distance using x and y positions

    // calculate the speed of movement based on the tongue speed so they match up movement
    if (distance > tongueSpeed) {
      float angle = atan2(dy, dx);
      x += cos(angle) * tongueSpeed;
      y += sin(angle) * tongueSpeed;
    } else {
      // returned to frog
      x = frogX;
      y = frogY;
      isEaten = true; // Set flag to true when reaching frog
      isVisible = false; // turn invisible when hitting frog
    }
  }

  // checks for collision with frog
  boolean checkCollisionWithFrog(Frog frog) {
    float frogLeft = frog.x - frog.w / 2; // left side of frog
    float frogRight = frog.x + frog.w / 2; // right side of frog
    float frogTop = frog.y - frog.h / 2; // top of frog
    float frogBottom = frog.y + frog.h / 2; // bottom of frog

    float antLeft = x - w / 2; // left side of ant
    float antRight = x + w / 2; // right side of ant
    float antTop = y - h / 2; // top of ant
    float antBottom = y + h / 2; // bottom of ant
    
    // returns true if any of the sides overlap with each other
    return !(frogLeft > antRight || frogRight < antLeft || frogTop > antBottom || frogBottom < antTop);
  }
}
