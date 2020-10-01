/******************** Parameters *****************************************************************/
final int EXPANSION_RATE = 3;              // Expansion rate of Point
/************************************************************************************************/

/* Point Manager */
class PointM
{
  int n;
  float x, y;
  float distance;
  Point[] Points ;

  PointM(int num)
  {
    n = num;
    Points = new Point[n];
    for(int i = 0; i < n; i++)
    {
      Points[i] = new Point();
    }
  }

  /* draw all the Points and connecting lines between them. */
  void drawShape()
  {

    for(int i = 0; i < n; i++)
    {
      float alpha = 0;  // Alpha of Point

      // From the distances between the Points, calculate transparency of each line
      // connecting them and the transparency alpha of the Points.
      // j is initialized with i to reduce cpu usage and to make it look good.
      for(int j = i; j < n; j++)
      {
        if(i == j) continue;
        distance = PointDistance(Points[i], Points[j]);
        if(distance > 255)  continue;  // reduce CPU usage

        stroke(0, (255 - distance));  // set the  transparency of the lines connecting the Points
        line(Points[i].position.x, Points[i].position.y,
                Points[j].position.x, Points[j].position.y);
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
    for(int k = 0; k < n; k++)
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
    for(int i = 0; i < n; i++)
    {
      Points[i].inhale();      // inhale Points
    }
  }
}
