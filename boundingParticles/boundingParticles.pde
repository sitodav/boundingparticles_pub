


float MAX_RAY = 250;
float MIN_RAY = 30;
ArrayList<ElemWrapper> elems = new ArrayList<ElemWrapper>();
color[] palettes = new color[]{#ef476f, #ffd166, #06d6a0, #118ab2, #073b4c};
long _CLOCK_MODULE = 300;
long _NUM_PARTICLES =   3550;
float _OPACITY = 255;
long _NUM_OV_MOVEMENTS_PERFRAME = 10;
float _NEIGH_ATTR_FACTOR = .008;
float _PUNTIRIF_ATTR_FACTOR = .005; 
float _MOUSE_ATTR_FACTOR = 0.005;
//PVector[] puntiRiferimento;
ArrayList<PVector[]> puntiRiferimentos;
float[] angoliInizialiPuntiRiferimento;
boolean _SHOWPUNTIRIFERIMENTO = true; 
float velRotGlob = 0;
float globalRotatAngle = 0;
float puntiRiferimentoRay = 20;
String[] functions = new String[]{"cos", null, null, null, null, null, null, null, null, null};
String[] functionsy = new String[]{"sin", null, null, null, null, null, null, null, null, null}; 
float[] functionsAngles = new float[]{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
float[] functionsAnglesY = new float[]{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0}; 
float[] functionsAnglesVels = new float[]{0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.1};
float[] functionsAnglesVelY = new float[]{0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.1}; 
float segnoPuntiRiferimentoRay = 1;
PVector influenzaInvisibile ;
boolean _SHOWLINES = true;
float BACKGROUND_ALPHA = 25;
ArrayList<PVector> windowCenterVects = new ArrayList<PVector>();
WindowForShittyConsole controllerSketch = null;


void mouseClicked()
{
  /*
  windowCenterVects.add(new PVector(mouseX, mouseY));
  puntiRiferimentos.add(new PVector[]{
    new PVector(windowCenterVects.get(windowCenterVects.size()-1).x, windowCenterVects.get(windowCenterVects.size()-1).y), 
    new PVector(windowCenterVects.get(windowCenterVects.size()-1).x, windowCenterVects.get(windowCenterVects.size()-1).y), 
    new PVector(windowCenterVects.get(windowCenterVects.size()-1).x, windowCenterVects.get(windowCenterVects.size()-1).y), 
    new PVector(windowCenterVects.get(windowCenterVects.size()-1).x, windowCenterVects.get(windowCenterVects.size()-1).y)});

  for (int idxCenterT = 0; idxCenterT< windowCenterVects.size(); idxCenterT++)
  {
    int iS = (int)( _NUM_PARTICLES / windowCenterVects.size() ) * idxCenterT;
    int iE = (int)( _NUM_PARTICLES / windowCenterVects.size() ) * (idxCenterT+1);
    initParticles(idxCenterT,iS, iE);
  }*/
}

void keyPressed()
{

  if (TAB == keyCode)
  {
    _SHOWPUNTIRIFERIMENTO = !_SHOWPUNTIRIFERIMENTO;
    _SHOWLINES = !_SHOWLINES;
  }
  if(keyCode == UP)
  {
    
    influenzaInvisibile = new PVector(influenzaInvisibile.x, influenzaInvisibile.y-200);
  }
  else if(keyCode == DOWN)
  {
    
    influenzaInvisibile = new PVector(influenzaInvisibile.x, influenzaInvisibile.y+200);
  }
  else if(keyCode == LEFT)
  {
    
    influenzaInvisibile = new PVector(influenzaInvisibile.x-200, influenzaInvisibile.y);
  }
  else if(keyCode == RIGHT)
  {
    
    influenzaInvisibile = new PVector(influenzaInvisibile.x+200, influenzaInvisibile.y);
  }
}
 

void mouseReleased()
{
   _MOUSE_ATTR_FACTOR = 0.005; 
}

void setup()
{

  size(420, 420, P3D);

  windowCenterVects.add( new PVector(width * 0.5, height * 0.5, 0));
  influenzaInvisibile = new PVector(width * 0.5, height *0.5);

  initParticles(0,0, (int)_NUM_PARTICLES);
  background(0);
  ellipseMode(CENTER);

  puntiRiferimentos = new ArrayList<PVector[]>();
  puntiRiferimentos.add(new PVector[]{
    new PVector(windowCenterVects.get(windowCenterVects.size()-1).x, windowCenterVects.get(windowCenterVects.size()-1).y), 
    new PVector(windowCenterVects.get(windowCenterVects.size()-1).x, windowCenterVects.get(windowCenterVects.size()-1).y), 
    new PVector(windowCenterVects.get(windowCenterVects.size()-1).x, windowCenterVects.get(windowCenterVects.size()-1).y), 
    new PVector(windowCenterVects.get(windowCenterVects.size()-1).x, windowCenterVects.get(windowCenterVects.size()-1).y)});

  angoliInizialiPuntiRiferimento = new float[]{0, PI*0.5, PI, 1.5*PI};

  controllerSketch = new WindowForShittyConsole(200, 200, 700, 550, this);
}

void draw()
{

  if(mousePressed)
  { 
     _MOUSE_ATTR_FACTOR += 0.001; 
  }
  for (int idxCenterT = 0; idxCenterT< windowCenterVects.size(); idxCenterT++)
  {
    int iS = (int)( _NUM_PARTICLES / windowCenterVects.size() ) * idxCenterT;
    int iE = (int)( _NUM_PARTICLES / windowCenterVects.size() ) * (idxCenterT+1);
    muoviParticelle(1, windowCenterVects.get(idxCenterT), iS, iE, iE >=  windowCenterVects.size(), idxCenterT);
    disegnaParticelle(1, idxCenterT);
    muoviParticelle(-1, windowCenterVects.get(idxCenterT), iS, iE, iE >=  windowCenterVects.size(), idxCenterT); 
    disegnaParticelle(-1, idxCenterT );
  }
  
  PImage partialSave = get(0,0,width,height);//get((int)(width*0.5 - 300),(int)(height * 0.5 - 300),(int)(width*0.5 + 300),(int)(height * 0.5 + 300));
  partialSave.save("pics/partialSave"+frameCount+".jpg"); 
}
