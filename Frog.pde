class Frog {

  float x; // x coordinate
  float y; // y coordinate
  float speed; // movement speed
  float w; // width
  float h; // height

  PImage img_frog_sit_left; // sitting position facing left
  PImage img_frog_sit_right; // sitting position facing right
  PImage img_frog_move_left_one; // first moving left 
  PImage img_frog_move_left_two; // second moving left
  PImage img_frog_move_right_one; // first moving right
  PImage img_frog_move_right_two; // second moving right
  PImage img_frog_eat_left; // eating left
  PImage img_frog_eat_right; // eating right
  PImage img_frog_hit_left; // getting hit left
  PImage img_frog_hit_right; // getting hit right
  int costume_id; // id to keep track of costumes

  boolean moving; // used to track if the frog is currently moving
  int animationDelay; // used to set a number of frames between costume switches
  int immobileTimer; // used to count the frames that the frog is immobile
  int previousCostumeId; // used to return to the previous costume when an animation finishes
  boolean immobile; // used to stop movement if something happens to the frog

  boolean facingRight; // used to check which direction the frog is facing

  FrogSounds frogSounds; // used to hold all of the sounds the frog will make

  // instantiates the frog and takes in the PApplet which is an instance of the main window.  Needed to load sounds, so it is passed to frogSounds
  Frog(PApplet parent) {
    this.speed = 5;
    this.w = 90;
    this.h = 104;
    this.x = width/2;
    this.y = height - h/2;
    this.img_frog_sit_left = loadImage("frog_sit_left.png");
    this.img_frog_sit_right = loadImage("frog_sit_right.png");
    this.img_frog_move_left_one = loadImage("frog_move_left_one.png");
    this.img_frog_move_right_one = loadImage("frog_move_right_one.png");
    this.img_frog_move_left_two = loadImage("frog_move_left_two.png");
    this.img_frog_move_right_two = loadImage("frog_move_right_two.png");
    this.img_frog_eat_left = loadImage("frog_eat_left.png");
    this.img_frog_eat_right = loadImage("frog_eat_right.png");
    this.img_frog_hit_left = loadImage("frog_hit_left.png");
    this.img_frog_hit_right = loadImage("frog_hit_right.png");
    this.moving = false;
    this.costume_id = 0;
    this.animationDelay = 7;
    this.immobileTimer = 0;
    this.previousCostumeId = 0;
    this.immobile = false;
    this.frogSounds = new FrogSounds(parent); // takes in parent to have an instance of the main window
    this.facingRight = false;
  }

  // displays the frog with the current costume
  void display() {
    // checks if the frog is sitting still in case it is in the middle of an animation
    checkMovement();
    imageMode(CENTER);
    image(useCostume(), x, y, w, h);
  } 
  

  // moves the frog left
  void moveLeft() {
    // if the frog is in the immobile state, do not allow movement
    if (!immobile) {
      x -= speed;
      // once the frames hit a certain threshold, start the switch case
      if (frameCount % animationDelay == 0) {
        switch(costume_id) {
        case 2:
          costume_id = 4;
          break;
        case 4:
          costume_id = 0;
          break;
        default:
          // set default to move left 1 so that it changes to this to start the animation cycle
          costume_id = 2;
          break;
        }
      }
    }
  }

  // moves the frog right
  void moveRight() {
    // if the frog is in the immobile state, do not allow movement
    if (!immobile) {
      x += speed;
      // once the frames hit a certain threshold, start the switch case
      if (frameCount % animationDelay == 0) {
        switch(costume_id) {
        case 3:
          costume_id = 5;
          break;
        case 5:
          costume_id = 1;
          break;
        default:
          // set default to move_left_1 so that it changes to this to start the animation cycle
          costume_id = 3;
          break;
        }
      }
    }
  }

  // if the movement stops mid animation, reset the frog to sitting position facing the proper direction
  void checkMovement() {
    if (!this.moving) {
      if (costume_id == 2 || costume_id == 4) {
        costume_id = 0;
      } else if (costume_id == 3 || costume_id == 5)
        costume_id = 1;
    }
  }

  // if the frog is hit, make the animation in the proper direction and play a sound
  void getHit() {
    // gets a random hit sound from the arraylist
    frogSounds.getFrogHitSounds().get(int(random(0, frogSounds.getFrogHitSounds().size()))).play();
    this.immobile = true;
    if (immobileTimer == 0) {
      previousCostumeId = costume_id; // saves a copy of the costume id when the animation starts
      if (costume_id == 0 || costume_id == 2 || costume_id == 4 || costume_id == 6) {
        costume_id = 8;
      } else if (costume_id == 1 || costume_id == 3 || costume_id == 5 || costume_id == 7) {
        costume_id = 9;
      }
      immobileTimer = 15; // sets the immobile timer to 15 frames
    }
  }

  // puts the frog in the "eating state"  
  void shootTongue() {
    this.immobile = true;
    if (immobileTimer == 0) {
      previousCostumeId = costume_id; // once the immobileTimer counts all the way down, set the costume back to the previous costume
      // checks if the croshair is to the left or right of the current location and shows the appropriate costume
      if (mouseX <= x) {
        costume_id = 6;
      } else if (mouseX > x) {
        costume_id = 7;
      }
      immobileTimer = 5; // sets the immobileTimer to 5 frames
    }
  }

  // causes a delay when the frog is hit and sets the hit status back to false at the end of the animation so the frog can move again
  // takes in the tongue object to check if isShooting or isRetracting is true.  If so, the countdown does not start so the frog is immobile until the
  // animation is complete.
  void immobileUpdate(Tongue tongue) {
    if (tongue.isShooting || tongue.isRetracting) {
      return;
    } else {
      // counts down frame by frame keeping the frog immobile until an animation finishes
      if (immobileTimer > 0) {
        immobileTimer --;
        // this gets hit once the timer hits 0
        if (immobileTimer == 0) {
          costume_id = previousCostumeId; // returns to previous costume
          this.immobile = false; // allows movement again
        }
      }
    }
  }

  // Changes the costume depending on the costume_id
  PImage useCostume() {
    switch(costume_id) {
    case 0:
      facingRight = false;
      return img_frog_sit_left;
    case 1:
      facingRight = true;
      return img_frog_sit_right;
    case 2:
      facingRight = false;
      return img_frog_move_left_one;
    case 3:
      facingRight = true;
      return img_frog_move_right_one;
    case 4:
      facingRight = false;
      return img_frog_move_left_two;
    case 5:
      facingRight = true;
      return img_frog_move_right_two;
    case 6:
      facingRight = false;
      return img_frog_eat_left;
    case 7:
      facingRight = true;
      return img_frog_eat_right;
    case 8:
      facingRight = false;
      return img_frog_hit_left;
    case 9:
      facingRight = true;
      return img_frog_hit_right;
    default:
      return null;
    }
  }
}
