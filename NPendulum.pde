class NPendulum {
  ArrayList<Circum> circles = new ArrayList<Circum>();
  FloatList lenghts = new FloatList();
  FloatList angles = new FloatList();
  PVector origin = new PVector(width / 2, height/3); 
  float g = 0.0004905000, damping = 0.998;
  int amount = 0;

  NPendulum(int amount_, ArrayList<Float> lenghts_, ArrayList<Float> angles_)
  {
    amount = amount_ + 1;

    for (int i = 0; i <lenghts_.size(); i++)
    {
      lenghts.append(lenghts_.get(i));
    }  

    for (int i = 0; i <angles_.size(); i++)
    {
      angles.append(angles_.get(i));
    }   

    for (int i = 0; i <amount; i++)
    {
      mass = 20;
      radius = mass * 2;
      circles.add(new Circum(lenghts.get(i) * sin(angles.get(i)), lenghts.get(i) * cos(angles.get(i)), radius, mass));
      
    }
  }

  void reset(int number)
  {
    float mass = 20, radius = 20;

    lenghts.clear();
    angles.clear();

    for (int i = circles.size() - 1; i >= 0; i--)
    {
      circles.remove(i);
    }

    number++;
    lenghts.append(0.0);
    angles.append(0.0);

    circles.add(new Circum(origin.x, origin.y, radius, mass));
    
    for (int i = 1; i <number; i++)
    {      
      lenghts.append(random(circles.get(i - 1).radius * 2, 150));
      angles.append(random(TWO_PI));
      mass = 8 * randa.nextFloat() + 4;
      radius = mass  * 4;

      circles.add(new Circum(lenghts.get(i) * sin(angles.get(i)), lenghts.get(i) * cos(angles.get(i)), radius, mass));
      circles.get(i).point.add(circles.get(i - 1).point);
    }
  }

  void calculations()
  {

    for (int i = 1; i <circles.size(); i++)
    {     
      circles.get(i).acceleration.set(0, (-g / lenghts.get(i)) * sin(angles.get(i)));

      circles.get(i).velocity.add(circles.get(i).acceleration);
      angles.add(i, circles.get(i).velocity.mag());

      circles.get(i).point.set(lenghts.get(i)*sin(angles.get(i)), lenghts.get(i)*cos(angles.get(i)));
      circles.get(i).point.add(circles.get(i - 1).point);   
      circles.get(i).velocity.mult(damping);
    }
  }

  void drawing()
  {
    circles.get(0).drawing();

    for (int i = 1; i <circles.size(); i++)
    {
      line(circles.get(i - 1).point.x, circles.get(i - 1).point.y, circles.get(i).point.x, circles.get(i).point.y);
      circles.get(i).drawing();
    }
  }
}
