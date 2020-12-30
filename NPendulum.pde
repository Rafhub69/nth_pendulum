class NPendulum {
  
  int tier = 0;
  FloatList mass;  
  FloatList angles;
  FloatList lenghts;
  FloatList velocities;
  FloatList accelerations;
  float damping = 0.998, g = 0.981;
  PVector []position;

  NPendulum(int _tier)
  {
    tier = _tier;
    velocities = new FloatList(tier); 
    mass = new FloatList(tier);
    lenghts = new FloatList(tier);
    angles = new FloatList(tier);
    accelerations = new FloatList(tier);
    position = new PVector[tier];
    reset();
  }

  void reset()
  {
    mass.clear();
    angles.clear();
    lenghts.clear();
    velocities.clear();
    accelerations.clear();

    for (int i =0; i<tier; i++)
    {
      velocities.append(0);
      accelerations.append(0);
      mass.append(random(10, 50));
      angles.append(random(PI));
      lenghts.append(random(30, 150));
      position[i] = new PVector(lenghts.get(i) * sin(angles.get(i)), lenghts.get(i) * cos(angles.get(i)));
    }
  }

  void calculations()
  {
    float den = 0;
    float num1 = 0;
    float num2 = 0;
    float num3 = 0;

    for (int j = 0; j < tier; j++) {
      //denominator 
      for (int k = 0; k < tier; k++) {
        den += mass.get(k) * lenghts.get(k) * lenghts.get(k) * (j <= k? 1 : 0);
      }


      for (int k = 0; k < tier; k++) {
        //first numerator
        num1 = g * lenghts.get(j) * sin(angles.get(j)) * mass.get(j) * (j <= k? 1 : 0);

        //second numerator
        float inner_sum = 0;
        // inner sum
        for (int q = k+1; q < tier; q++) {
          inner_sum += mass.get(q) * (j <= q? 1 : 0);
        }
        num2 = inner_sum * lenghts.get(j) * lenghts.get(k) * sin(angles.get(j) - angles.get(k)) * velocities.get(j) * velocities.get(k);

        //Third numerator
        //The inner sum is the same as in the num2
        num3 = inner_sum * lenghts.get(j) * lenghts.get(k) * (sin(angles.get(k) - angles.get(j)) * (velocities.get(j) * velocities.get(k)) * velocities.get(k) + (j != k ? 1 : 0) * cos(angles.get(j) - angles.get(k))*accelerations.get(k));
      }
      float result = - (num1 + num2 + num3) / den;
      
      accelerations.set(j,result);
    }

    accToAngle();
  }

  void accToAngle()
  {
    velocities.set(0, velocities.get(0) + accelerations.get(0));
    angles.set(0, angles.get(0) + velocities.get(0));
    position[0].set(lenghts.get(0) * sin(angles.get(0)), lenghts.get(0) * cos(angles.get(0)));
    velocities.set(0, velocities.get(0) * damping);

    for (int i = 1; i < tier; i++)
    {
      velocities.set(i, velocities.get(i) + accelerations.get(i));
      angles.set(i, angles.get(i) + velocities.get(i));
      position[i].set(lenghts.get(i) * sin(angles.get(i)) + position[i - 1].x, lenghts.get(i) * cos(angles.get(i)) + position[i - 1].y);
      velocities.set(i, velocities.get(0) * damping);
    }
  }

  void drawing()
  {
    circle(0, 0, 20);
    line(0, 0, position[0].x, position[0].y);
    circle(position[0].x, position[0].y, 20);

    for (int i = 1; i<tier; i++)
    {
      line(position[i - 1].x, position[i - 1].y, position[i].x, position[i].y);
      circle(position[i].x, position[i].y, 20);
    }
  }
}
