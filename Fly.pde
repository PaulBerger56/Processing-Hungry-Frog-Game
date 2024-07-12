class Fly extends Bug {
  float x; // x coordinate
  float y; // y coordinate
  float h; //height
  float w; // width
  float speed; // movement speed

  PImage img_fly_wings_down; // wings down image
  PImage img_fly_wings_up;  // wings up image
  PImage img_fly_wings_neutral; // wings neutral image

  int costume_id; // used to set specific costumes

  boolean immobile; // used to stop movement
  int animationDelay; // used to set a number of frames between costume switches
  float initialY; // used to set the initial Y position so that the fly can move upwards and downwards within a certain range of it
  boolean allowUp; // checks if the wing up costume can be used
  boolean movingUp; // checks if the fly is moving up while moving across the screen

  boolean isHitByTongue; // checks if the frog's tongue has hit the fly
  boolean isEaten; // used to flag when the fly gets eaten by the frog
  boolean isVisible; // used to show or not show image

  boolean movingRight; // used to set whether the fly is moving right or left

  // Intantiates the fly and takes in the x and y positions, movement speed, and moveRight.  The x is set on either the left or right side of the window depending on movingRight.
  Fly(float x, float y, float speed, boolean movingRight) {
    this.x = x;
    this.y = y;
    this.speed = speed;
    this.w = 111.8;
    this.h = 56.4;
    this.img_fly_wings_down = loadImage("fly_wings_down.png");
    this.img_fly_wings_up = loadImage("fly_wings_up.png");
    this.img_fly_wings_neutral = loadImage("fly_wings_neutral.png");
    this.costume_id = 1;
    this.immobile = false;
    this.animationDelay = 7;
    this.initialY = y;
    this.allowUp = true;
    this.movingUp = false;
    this.isHitByTongue = false;
    this.isEaten = false;
    this.isVisible = true;
    this.movingRight = movingRight;
  }

  // displays the image if isVisible is true
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
      return img_fly_wings_up;
    case 1:
      return img_fly_wings_neutral;
    case 2:
      return img_fly_wings_down;
    default:
      return null;
    }
  }
  
  // calls the appropriate moveLeft or moveRight method.  Made this here to reduce code inside of GameController
  void move() {
    if (movingRight) {
      moveRight();
    } else {
      moveLeft();
    }
  }
  
  // Moves the fly left and changes the costume to mimic animation
  void moveLeft() {
    if (!immobile) {
      x -= speed;

      // allows the fly to move up and down while staying within 50 pixels of the initial y position
      if (movingUp) {
        y -= speed;
        if (y <= initialY - 50) {
          movingUp = false;
        }
      } else {
        y += speed;
        if (y >= initialY + 50) {
          movingUp = true;
        }
      }

      // switches the costumes on a delay to give the impression of movement
      if (frameCount % animationDelay == 0) {
        switch(costume_id) {
        case 0:
          costume_id = 1;
          // if the wings have been in the up position,set allowUp to false so they can't go up again until down
          allowUp = false;
          break;
        case 1:
          if (!allowUp) {
            costume_id = 2;
            allowUp = true;
            break;
          } else {
            costume_id = 0;
          }
          break;
        case 2:
          costume_id = 1;
          break;
        }
      }
    }
  }

  // Moves the fly right and changes the costume to mimic animation
  void moveRight() {
    if (!immobile) {
      x += speed;

      // allows the fly to move up and down while staying within 50 pixels of the initial y position
      if (movingUp) {
        y -= speed;
        if (y <= initialY - 50) {
          movingUp = false;
        }
      } else {
        y += speed;
        if (y >= initialY + 50) {
          movingUp = true;
        }
      }

      // switches the costumes on a delay to give the impression of movement
      if (frameCount % animationDelay == 0) {
        switch(costume_id) {
        case 0:
          costume_id = 1;
          // if the wings have been in the up position,set allowUp to false so they can't go up again until down
          allowUp = false;
          break;
        case 1:
          if (!allowUp) {
            costume_id = 2;
            allowUp = true;
            break;
          } else {
            costume_id = 0;
          }
          break;
        case 2:
          costume_id = 1;
          break;
        }
      }
    }
  }

  // switches hitByTongue to true when the user clicks on the fly and imobilizes it before moving
  void hitByTongue() {
    immobile = true;
    isHitByTongue = true;
  }

  // checks for tongue hit
  boolean isHit(float tongueX, float tongueY, float tongueRadius) {
    float distance = dist(x, y, tongueX, tongueY); // calculates the distance between the bug and the tongue
    return distance < min(w, h) / 2 + tongueRadius; // if the tongue is touching, return true, so the tongue has hit the bug
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
}
