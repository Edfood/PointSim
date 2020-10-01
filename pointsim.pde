/******************** Parameters *****************************************************************/
final int NUM_POINTS = 30;                 // Number of Point
final int WIDTH = 750;                     // Width of window size
final int HEIGHT = 750;                    // Height of window size
final float RESTITUTION_COEFFICIENT = 0.8; // Restitution coefficient when the point hits the wall
final float MAX_SPEED = 9;                 // Max speed of Point
final float FRICTION_COEFFICIENT = 0.003;  // Coefficient of friction
final float INHALATION_STRENGTH = 0.2;     // Strength of inhalation on click
final int INHALATION_RADIUS = 450;         // Inhalation radius
/************************************************************************************************/

void settings()
{
  size(WIDTH, HEIGHT);
}

PointM mesh;
void setup()
{
  fill(155, 100);
  background(255);
  smooth();
  strokeWeight(0.5);
  mesh = new PointM(NUM_POINTS); // If it is not defined here, width and height are not initialized.
}


void draw()
{
  background(255);
  if(mousePressed)
  {
    mesh.press();
  }
  mesh.drawShape();
  mesh.updatePoint();
}

/* Point class */
class Point
{
  PVector position;
  PVector speed;

  Point()
  {
    float centX = width / 2 + random(width / 3) - width / 6;
    float centY = height / 2 + random(height / 3) - height / 6;
    position = new PVector(centX + random(50) - 25, centY + random(50) - 25);
    speed = new PVector(0, 0);
    speed.x = random(3) - 1.5;
    speed.y = random(3) - 1.5;
  }

  void updateMe()
  {
    speed.x -= speed.x > 0 ? FRICTION_COEFFICIENT : -FRICTION_COEFFICIENT;
    speed.y -= speed.y > 0 ? FRICTION_COEFFICIENT : -FRICTION_COEFFICIENT;
    /* Restriction of Point speed */
    if(abs(speed.x) > MAX_SPEED) speed.x = (speed.x > 0 ? MAX_SPEED : -MAX_SPEED);
    if(abs(speed.y) > MAX_SPEED) speed.y = (speed.y > 0 ? MAX_SPEED : -MAX_SPEED);

    /* Restrict the Point from going outside the window. */
    if(position.x > width)
    {
      position.x = width;
      speed.x *= -RESTITUTION_COEFFICIENT;
    }
    else if(position.x < 0)
    {
      position.x = 0;
      speed.x *= -RESTITUTION_COEFFICIENT;;

    }
    
    if(position.y > height)
    {
      position.y = height;
      speed.y *= -RESTITUTION_COEFFICIENT;
    }
    else if(position.y < 0)
    {
      position.y = 0;
      speed.y *= -RESTITUTION_COEFFICIENT;
    }

    position = PVector.add(position, speed);  // Add moving distance
  }

  /* Inhale Point when mouse clicked */
  void inhale()
  {
    float distx = mouseX - position.x;
    float disty = mouseY - position.y;
    
    float distance = sqrt(sq(mouseX - position.x) + sq(mouseY - position.y));
    if (distance < 0.01) distance = 0.01;
    float tempx = (distx / (distance))  / (distance / INHALATION_RADIUS);
    float tempy = (disty / (distance))  / (distance / INHALATION_RADIUS);
    
    speed.x += INHALATION_STRENGTH * tempx * random(1);
    speed.y += INHALATION_STRENGTH * tempy * random(1);
  }
}
