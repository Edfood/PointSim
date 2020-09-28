
/******************** Parameters *****************************************************************/
final int NUM_POINTS = 30;                 // Number of Point
final int WIDTH = 750;                     // Width of window size
final int HEIGHT = 750;                    // Height of window size
final int EXPANSION_RATE = 3;              // Expansion rate of Point
final float RESTITUTION_COEFFICIENT = 0.8; // Restitution coefficient when the point hits the wall
final float MAX_SPEED = 9;                 // Max speed of Point
final float FRICTION_COEFFICIENT = 0.003;  // Coefficient of friction
final float INHALATION_STRENGTH = 0.2;     // Strength of inhalation on click
final int INHALATION_RADIUS = 450;         // Inhalation radius
/************************************************************************************************/


PointM mesh = new PointM();

void settings()
{
  size(WIDTH, HEIGHT);
}

void setup()
{
  fill(155, 100);
  background(255);
  smooth();
  strokeWeight(0.5);
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


/* Point Manager */
class PointM
{
  float centX = WIDTH / 2;
  float centY = HEIGHT / 2;
  float x, y;
  float rnd;
  float distance;
  Point[] Points = new Point[NUM_POINTS];

  PointM()
  {
    for(int i = 0; i < NUM_POINTS; i++)
    {
      Points[i] = new Point();
    }
  }

  /* draw all the Points and connecting lines between them. */
  void drawShape()
  {

    for(int i = 0; i < NUM_POINTS; i++)
    {
      float alpha = 0;  // Alpha of Point

      // From the distances between the Points, calculate transparency of each line
      // connecting them and the transparency alpha of the Points.
      for(int j = i; j < NUM_POINTS; j++)
      {
        if(i == j) continue;
        distance = PointDistance(Points[i], Points[j]);
        if(distance > 255)  continue;


        stroke(0, (255 - distance));  // set the  transparency of the lines connecting the Points
        line(Points[i].position.x, Points[i].position.y, Points[j].position.x, Points[j].position.y);
        alpha += 255 - distance;
      }

      alpha /= 60;  // adjust alpha
      fill(0, alpha + 10);     // Inner transparency

      stroke(0, alpha);        // Outline transparency
      float radius = alpha * EXPANSION_RATE;
      ellipse(Points[i].position.x, Points[i].position.y, radius, radius);
    }
  }

  /* update all Points position */
  void updatePoint()
  {
    for(int k = 0; k < NUM_POINTS; k++)
    {
      Points[k].updateMe();
    }
  }

  /* return distance between 2 Points. */
  float PointDistance(Point a, Point b)
  {
    return sqrt(sq(a.position.x - b.position.x) + sq(a.position.y - b.position.y));
  }

  /* when mouse is clicked */
  void press()
  {
    for(int i = 0; i < NUM_POINTS; i++)
    {
      Points[i].inhale();      // inhale Points
    }
  }
}


/* Point class */
class Point
{
  float centX;
  float centY;
  PVector position;
  PVector speed;

  Point()
  {
    centX = WIDTH / 2 + random(WIDTH / 3) - WIDTH / 6;
    centY = HEIGHT / 2 + random(HEIGHT / 3) - HEIGHT / 6;
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
    if(position.x > WIDTH)
    {
      position.x = WIDTH;
      speed.x *= -RESTITUTION_COEFFICIENT;
    }
    else if(position.x < 0)
    {
      position.x = 0;
      speed.x *= -RESTITUTION_COEFFICIENT;;

    }
    if(position.y > HEIGHT)
    {
      position.y = HEIGHT;
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
    float tempx, tempy;
    float distx = mouseX - position.x;
    float disty = mouseY - position.y;
    
    float distance = sqrt(sq(mouseX - position.x) + sq(mouseY - position.y));
    if (distance < 0.01) distance = 0.01;
    tempx = (distx / (distance))  / (distance / INHALATION_RADIUS);
    tempy = (disty / (distance))  / (distance / INHALATION_RADIUS);
    
    speed.x += INHALATION_STRENGTH * tempx * random(1);
    speed.y += INHALATION_STRENGTH * tempy * random(1);
  }
}