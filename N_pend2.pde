boolean stopStart = false;
NPendulum nPend;


void setup() {
  size(700, 700, P2D);

  nPend = new NPendulum(5);
}


void keyPressed() 
{
  if ((key >= 'A' && key <= 'Z') || (key >= 'a' && key <= 'z')) 
  {
    if (key == 'n' ||key == 'N')
    {
      nPend.reset();
    } else if (key == 's' ||key == 'S')
    {
      stopStart = !stopStart;
    }
  }
}

void draw() {
  translate(width / 2, height/2);
  background(200);

  if (stopStart)
  {
    nPend.calculations();
  }
  nPend.drawing();
}
