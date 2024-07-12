class Heart {
  
  float x; // x coordinate
  float y; // y coordinate
  float w; // width
  float h; // height
  
  PImage img_heart; // image of the heart
  
  // instantiates the heart and takes in the x, y, width, and height so that it can be controlled by the health class
  Heart(float x, float y, float w, float h){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.img_heart = loadImage("heart.png");
  }
  
  // Displays a single heart image 
  void display(){
    imageMode(CORNER);
    image(img_heart, x, y, w, h);
  }
}
