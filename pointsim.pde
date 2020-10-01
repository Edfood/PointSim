/******************** Parameters ********************************************/
final int NUM_POINTS = 30;                 // Number of Point
final int WIDTH = 750;                     // Width of window size
final int HEIGHT = 750;                    // Height of window size
/****************************************************************************/

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
