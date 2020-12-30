class NPendulum {
  ArrayList<Circum> bob = new ArrayList<Circum>();
  FloatList angleAcceleration = new FloatList();
  FloatList angleVelocity = new FloatList();
  FloatList lenghts = new FloatList();
  FloatList angles = new FloatList();
  PVector origin = new PVector(width / 2, height/3); 
  float g = 0.0004905000, damping = 0.998;
  int amount = 0;

  NPendulum(int amount_, ArrayList<Float> lenghts_, ArrayList<Float> angles_)
  {
    amount = amount_;
    float mass = 10, radius = 20;

    for (int i = 0; i <lenghts_.size(); i++)
    {
      lenghts.append(lenghts_.get(i));
    }  

    for (int i = 0; i <angles_.size(); i++)
    {
      angles.append(angles_.get(i));
    }   

    mass = random(10, 30);
    radius = mass * 2;
    bob.add(new Circum(lenghts.get(0) * sin(angles.get(0)), lenghts.get(0) * cos(angles.get(0)), radius, mass));
    bob.get(0).point.add(origin);
    angleAcceleration.append(0);
    angleVelocity.append(0);

    for (int i = 1; i <amount - 1; i++)
    {
      mass = random(10, 30);
      radius = mass * 2;
      bob.add(new Circum(lenghts.get(i) * sin(angles.get(i)), lenghts.get(i) * cos(angles.get(i)), radius, mass));
      bob.get(i).point.add(bob.get(i - 1).point);
      angleAcceleration.append(0);
      angleVelocity.append(0);
    }
  }

  void reset(int number)
  {
    float mass = 10, radius = 20;

    lenghts.clear();
    angles.clear();

    for (int i = bob.size() - 1; i >= 0; i--)
    {
      bob.remove(i);
    }

    bob.add(new Circum(origin.x, origin.y, radius, mass));
    lenghts.append(random(radius * 2, 150));
    angles.append(random(TWO_PI));

    for (int i = 1; i <number; i++)
    {      
      lenghts.append(random(bob.get(i - 1).radius * 2, 150));
      angles.append(random(TWO_PI));
      mass = 8 * randa.nextFloat() + 4;
      radius = mass * 4;

      bob.add(new Circum(lenghts.get(i) * sin(angles.get(i)), lenghts.get(i) * cos(angles.get(i)), radius, mass));
      bob.get(i).point.add(bob.get(i - 1).point);
      bob.get(i).acceleration.set(0, 0);
      bob.get(i).velocity.set(0, 0);
    }
  }

  void calculateAcceleration()
  {
    float[] copyAcceleration = new float[bob.size()];
    float num1 = 5, num2 = 7, num3 = 2;
    float den = 0;

    for (int j = 0; j < amount; j++) {
      //denominator 
      for (int k = 0; k < amount; k++) {
        den += bob.get(k).mass * lenghts.get(k) * lenghts.get(k) * (j <= k? 1 : 0);
      }


      for (int k = 0; k < amount; k++) {
        //first numerator
        num1 = g * lenghts.get(j) * sin(angles.get(j)) * bob.get(k).mass * (j <= k? 1 : 0);

        //second numerator
        float inner_sum = 0;
        // inner sum
        for (int q = k+1; q < amount; q++) {
          inner_sum += bob.get(q).mass * (j <= q? 1 : 0);
        }
        num2 = inner_sum * lenghts.get(j) * lenghts.get(k) * sin(angles.get(j) - angles.get(k)) * angleVelocity.get(j) * angleVelocity.get(k);

        //Third numerator
        //The inner sum is the same as in the num2
        num3 = inner_sum * lenghts.get(j) * lenghts.get(k) * (sin(angles.get(k) - angles.get(j)) * (angleVelocity.get(j) * angleVelocity.get(k)) * angleVelocity.get(k) + (j != k ? 1 : 0) * cos(angles.get(j) - angles.get(k))*angleAcceleration.get(k));
      }

      copyAcceleration[j] = - (num1 + num2 + num3) / den;
      println("2 Index: ", j, " num1: ", num1, " num2: ", num2, " num3: ", num3, " copyAcceleration[j]: ", copyAcceleration[j]);
    }

    for (int i = 0; i <bob.size() - 1; i++)
    {
      angleAcceleration.set(i, copyAcceleration[i]);
      println("Index: ", i," copyAcceleration[i]: ", copyAcceleration[i]);
    }
  }

  void calculatePosition()
  {
    for (int i = 1; i <bob.size() - 1; i++)
    {
      bob.get(i).point.set(lenghts.get(i) * sin(angles.get(i)), lenghts.get(i) * cos(angles.get(i)));
      bob.get(i).point.add(bob.get(i - 1).point);
      angleVelocity.add(i, angleAcceleration.get(i));
      angles.add(i, angleVelocity.get(i));
    }
  }  

  void show()
  {

    circle(origin.x, origin.y, 20);

    for (int i = 0; i <bob.size() - 2; i++)
    {
      line(bob.get(i).point.x, bob.get(i).point.y, bob.get(i + 1).point.x, bob.get(i + 1).point.y);
      bob.get(i).drawing();
    }
  }
}

class Circum {
  int max_velocity = 15;
  float radius, mass, ref = 0.5, springness = 0.9999;
  PVector  point = new PVector(0, 0);
  PVector  acceleration = new PVector(0, 0);
  PVector  velocity = new PVector(new Random().nextInt(max_velocity) + 0.05, -1 * (new Random().nextInt(max_velocity) + 0.05));
  PVector gre = new PVector(0, 0);

  Circum() {
    mass = 5 * new Random().nextFloat() + 1;
    radius = mass * 4;
    point.x = (width * new Random().nextFloat()) - radius;
    point.y = (height * new Random().nextFloat()) - radius;
  }

  Circum(float x_, float y_, float radius_, float mass_) {
    this();
    point.x = x_;
    point.y = y_;
    radius = radius_;
    mass = mass_;
  }

  void setSpeed(PVector force) {
    PVector f = force.copy();
    acceleration.add(PVector.div( f, mass));
    velocity.add(acceleration);
    point.add(velocity);
    gre = acceleration.copy();

    // If out of bounds
    if (point.y - radius <= 0) 
    {
      velocity.y *= -springness;
      point.y = 0 + radius;
    } else if (point.y + radius >= height) 
    {
      velocity.y *= -springness;
      point.y = height - radius ;
    }
    if (point.x - radius <= 0)
    {
      velocity.x *= -springness;
      point.x = 0 + radius;
    } else if (point.x + radius >= width)
    {
      velocity.x *= -springness;
      point.x = width - radius;
    }
    acceleration.mult(0);
  }

  void drawing() {

    fill((map(velocity.y, 8.05, 0.015, 60, 255)), (map(gre.y, - 0.015, 0.015, 50, 100)), (map(point.y, - 55.01, 0.015, 1, 255)));
    stroke((map(point.x, 104, 0.015, 100, 255)), (map(gre.x, - 0.015, 0.015, 60, 110)), (map(velocity.x, 15, 0.015, 50, 255)));
    circle(point.x, point.y, 2 * radius);

    strokeWeight(2);
    stroke(255, 255, 255);
    PVector dir = velocity.copy();
    dir.normalize().mult(radius);
    dir = PVector.add(dir, point);
    line(point.x, point.y, dir.x, dir.y);
  }
}
