abstract class Bug {
  // This class was used so that I could check for collision with each type of bug without having to write repetitive code.
  // If I had more time, I would put more shared methods in here rather than repeating in each bug
  float w; // width
  float h; // height
  float x; // x position
  float y; // y position 
  
  // checks if there is a collision between the tongue and the current bug
  boolean isHit(float tongueX, float tongueY, float tongueRadius) {
    float distance = dist(x, y, tongueX, tongueY); // calculates the distance between the bug and the tongue
    return distance < min(w, h) / 2 + tongueRadius; // if the tongue is touching, return true, so the tongue has hit the bug
  }
 
}
