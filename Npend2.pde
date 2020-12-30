import java.util.Random;

Random randa = new Random();
int numberOfNpendulum = 1, frameStartTime, frameEndTime;
float delta_time, now = System.nanoTime();
boolean stop = true;
NPendulum nPend;

void setup() {   
  size(1920, 1060, P2D);

  ArrayList<Float> nPendLenghts = new ArrayList<Float>(numberOfNpendulum);
  ArrayList<Float> nPendAngles  = new ArrayList<Float>(numberOfNpendulum);

  //creating a random npendulum
  for (int i = 0; i<numberOfNpendulum; i++)
  {
    nPendLenghts.add(random(45,150));
    nPendAngles.add(random(TWO_PI));
  }

  nPend = new NPendulum(numberOfNpendulum, nPendLenghts, nPendAngles);
}

void keyPressed() 
{
  if ((key >= 'A' && key <= 'Z') || (key >= 'a' && key <= 'z')) 
  {
    if (key == 'n' ||key == 'N')
    {
      nPend.reset(numberOfNpendulum);
    } else if(key == 's' ||key == 'S')
    {
      stop = !stop;
    }
  }
}

void calc_delta_time() {
  delta_time = (System.nanoTime()-now)/100000000;
  now = System.nanoTime();
}

void draw() {
  background(120);
  
  if (stop)
  {
    nPend.calculateAcceleration();
     nPend.calculatePosition();
  }
  nPend.show();
  
  String advice =" Reset - N\n Zatrzymanie programu - S";
  fill(0);
  textSize(20);
  text(advice,0,0, 660, 330);
  frameStartTime = millis();
}
