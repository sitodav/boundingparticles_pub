int END_PLAY_TO ;
int START_PLAY_FROM = 0;
PVector startMouseRegionDrag, endMouseRegionDrag;

class KeyStepElement
{
  public PVector uL;
  public float h, w;
  public int i, j;
  String evento = null;
  Boolean lampeggiaOn_keyEvent = false;
  Boolean lampeggiaOn_playMode = false;
  long internalClock = 0;
  public char keyAssociata = 0;
  public float valueAssociato = 0.0;



  public KeyStepElement(PVector uL, float w, float h, int i, int j)
  {
    this.uL = uL; 
    this.h = h; 
    this.w = w;
    this.i = i; 
    this.j = j;
  }


  public void disegnami(PGraphics buffer, int _mousex, int _mousey, boolean isAggiuntivo )
  {

    buffer.noFill();
    buffer.stroke(#1b4332, 100);  
    if (j <1  && i < 2)
    {
      buffer.stroke(#007f5f);
    } else if (i == 2 || i == 3)
    {
      buffer.stroke(#007f5f);
    }
    buffer.rect(uL.x, uL.y, w, h);

    if (keyAssociata > 0)
    {
      buffer.fill(#55a630, 50);
      buffer.rect(uL.x, uL.y, w, h);
      buffer.textMode(CENTER); 
      buffer.textSize(18);
      buffer.textAlign(CENTER, CENTER); 

      buffer.fill(#000000, 255);
      String angleLab = i == 0 ? "α" : "ß";
      buffer.text(keyAssociata== 's' ? "sin("+angleLab+")" : "cos("+angleLab+")", uL.x+ 0.5 * w, uL.y + 0.36 * h); 
      buffer.fill(#008bf8, 50);
    } else if (this.evento != null)
    {
      if ("click".equals(this.evento)  )
      {

        if (lampeggiaOn_keyEvent) {  
          buffer.fill(#04e762, 255);
        } else {
          buffer.fill(250, 250, 250, 255);
        }
        if (internalClock % 10 == 0)
          this.lampeggiaOn_keyEvent = !this.lampeggiaOn_keyEvent;  

        internalClock++;
        buffer.rect(uL.x, uL.y, w, h);
      }
    } else
    {
      if (this.mouseIn(_mousex, _mousey))
      {
        buffer.fill(#04e762, 50); 
        buffer.rect(uL.x, uL.y, w, h);
      }
    }

    float tMinRange = 0;
    float tMaxRange = 0.1;
    if (isAggiuntivo)
    {
      if (j==0)
      {
        tMinRange = 0;
        tMaxRange = 255;
      } else if (j== 1 || j== 2)
      {
        tMinRange = 0;
        tMaxRange = 0.01;
      } else if (j== 3)
      {
        tMinRange = 0;
        tMaxRange = 500;
      }
    }

    if (valueAssociato > 0)
    {
      float t = map( valueAssociato, tMinRange, tMaxRange, 0, h );
      buffer.fill(255, 0, 0, 120);
      buffer.rect(uL.x, uL.y+h, w, -t);
      buffer.fill(#000000, 255);
      if (!isAggiuntivo) 
        buffer.text(i==2 ? "α" : "ß", uL.x+ 0.5 * w, uL.y + 0.36 * h); 
      else
        buffer.text(""+j, uL.x+ 0.5 * w, uL.y + 0.36 * h);
      buffer.fill(#008bf8, 50);
    } 


    if (this.lampeggiaOn_playMode)
    {
      if (internalClock % 10 == 0)
      {
        buffer.fill(#f5b700, 255);
        buffer.stroke(#f5b700, 100);
      } else
      {    
        buffer.noFill();
        buffer.stroke(#f5b700, 100);
      }

      internalClock++;
    } 
    buffer.rect(uL.x, uL.y, w, h);
  }



  public boolean mouseIn( int _mousex, int _mousey )
  {
    if (uL.x < _mousex && _mousex < uL.x+w && uL.y < _mousey && _mousey < uL.y+h)
      return true;
    return false;
  }
}


class KeysStepSequencer
{
  PVector uL;
  int w;
  int h; 
  int numElemsX; 
  int numElemsY;
  float elemW  ;
  float elemH  ; 
  PVector idxMouseIn = new PVector(-1, -1);
  Boolean playMode = false;

  int linearIdxSelectedElm = -1;
  PVector elemAggiuntiviUL ;
  KeyStepElement[][] elementi= null;
  KeyStepElement[][] elementiAggiuntivi = null; 
  float elemAggiuntiviH = 100;
  public KeysStepSequencer(PVector uL, int w, int h, int numElemsX)
  {
    this.uL = uL; 
    this.w = w; 
    this.h = 250; 
    this.numElemsX = numElemsX; 
    this.numElemsY = 4;
    this.elementi = new KeyStepElement[numElemsY][numElemsX];
    this.elemW = w/(float)numElemsX;
    this.elemH = this.h/(float)numElemsY;
    END_PLAY_TO = numElemsX - 1;
    elemAggiuntiviUL = new PVector(29, this.h + 20); 

    for (int i = 0; i< numElemsY; i++)
    {
      for (int j = 0; j< numElemsX; j++)
      {
        elementi[i][j] = new KeyStepElement( new PVector(this.uL.x + j * elemW, this.uL.y + i*elemH), elemW, elemH, i, j);
        if (i == 0 && j == 0)
        {
          elementi[i][j].keyAssociata = 'c';
        } else if (i == 1 && j== 0)
        {
          elementi[i][j].keyAssociata = 's';
        }
      }
    }
    elementiAggiuntivi = new KeyStepElement[1][4]; 

    for (int i = 0; i< 4; i++)
    {
      elementiAggiuntivi[0][i] = new KeyStepElement(new PVector(elemAggiuntiviUL.x + i * elemW, elemAggiuntiviUL.y), elemW, elemAggiuntiviH, 0, i);
    }

    elementiAggiuntivi[0][0].valueAssociato = BACKGROUND_ALPHA;
    elementiAggiuntivi[0][1].valueAssociato = _NEIGH_ATTR_FACTOR;
    elementiAggiuntivi[0][2].valueAssociato = _PUNTIRIF_ATTR_FACTOR;
    elementiAggiuntivi[0][3].valueAssociato = MAX_RAY;
  }

  
  public void checkEventoMouse(int _mousex, int _mousey, String evento)
  {

    this.idxMouseIn = new PVector(-1, -1);

    if (elementi != null && "click".equals(evento) ) //check per evento per registrare singolo key element (click)
    {
      for (int i = 0; i< numElemsY; i++)
      {
        for (int j = 0; j< numElemsX; j++)
        { 
          if (i < 2 && j == 0)
            continue;
          if (!elementi[i][j].mouseIn(_mousex, _mousey))
            elementi[i][j].evento = null; 
          else 
          {
            elementi[i][j].evento = evento; 
            elementi[i][j].keyAssociata = 0;
          }
        }
      }
      for (int j = 0; j< 4; j++)
      {

        if (!elementiAggiuntivi[0][j].mouseIn(_mousex, _mousey))
          elementiAggiuntivi[0][j].evento = null; 
        else 
        {
          elementiAggiuntivi[0][j].evento = evento; 
          elementiAggiuntivi[0][j].keyAssociata = 0;
        }
      }
    } else if (elementi != null && "dragArea".equals(evento)) //check per selezione multipla 
    {
      //individuo prima starting ed ending element */
      int istart=-1, jstart=-1, iend=-1, jend=-1;

      for (int i = 0; i< numElemsY && (istart== -1 || iend==-1); i++)
      {
        for (int j = 0; j< numElemsX && (istart== -1 || iend==-1); j++)
        { 

          if (elementi[i][j].mouseIn((int)startMouseRegionDrag.x, (int)startMouseRegionDrag.y))
          {
            istart=i; 
            jstart= j;
          } else if (elementi[i][j].mouseIn((int)endMouseRegionDrag.x, (int)endMouseRegionDrag.y))
          {
            iend=i; 
            jend= j;
          }
        }
      }

      //assegno a quelli nella regione evento di attesa di click
      for (int i = 0; i< numElemsY; i++)
      {
        for (int j = 0; j< numElemsX; j++)
        { 
          if (i < 2 && j == 0)
            continue;

          if (!(i>= istart && i<=iend && j>=jstart && j<=jend))
            elementi[i][j].evento = null; 
          else 
          {
            elementi[i][j].evento = "click"; 
            elementi[i][j].keyAssociata = 0;
          }
        }
      }
    }
  }


  public void checkEventoKey(char _key, int _keyCode, String evento)
  {

    this.idxMouseIn = new PVector(-1, -1);
    if (elementi != null)
    {
      for (int i = 0; i< 2; i++)
      {
        for (int j = 1; j< numElemsX; j++)
        { 
          if ( "click".equals(elementi[i][j].evento))
          {
            if (_key == 's' || _key == 'c')
            {
              elementi[i][j].keyAssociata = _key;
              elementi[i][j].evento = null;
            }
          }
        }
      }


      for (int j= 0; j< numElemsX; j++)
      {
        if ( "click".equals(elementi[2][j].evento))
        {
          if (_keyCode == UP || _keyCode == DOWN)
          {
            functionsAnglesVels[j] =  constrain(functionsAnglesVels[j]  + ( _keyCode == UP ? 0.001 : -0.001 ), 0, 1.0);
            elementi[2][j].valueAssociato = constrain(functionsAnglesVels[j] + ( _keyCode == UP ? 0.001 : -0.001 ), 0, 1.0);


            functionsAnglesY[j] = functionsAngles[j];
          }
        }
      }


      for (int j= 0; j< numElemsX; j++)
      {
        if ( "click".equals(elementi[3][j].evento))
        {
          if (_keyCode == UP || _keyCode == DOWN)
          {
            functionsAnglesVelY[j] =  constrain(functionsAnglesVelY[j]  + ( _keyCode == UP ? 0.001 : -0.001 ), 0, 1.0);
            elementi[3][j].valueAssociato = constrain(functionsAnglesVelY[j] + ( _keyCode == UP ? 0.001 : -0.001 ), 0, 1.0);


            functionsAngles[j] = functionsAnglesY[j];
          }
        }
      }


      for (int j = 0; j< 4; j++)
      {
        if ( "click".equals(elementiAggiuntivi[0][j].evento))
        {
          if (_keyCode == UP || _keyCode == DOWN)
          {
            if (j == 0)
            {
              BACKGROUND_ALPHA =  constrain(BACKGROUND_ALPHA  + ( _keyCode == UP ? 10 : -10 ), 0, 255);
              elementiAggiuntivi[0][j].valueAssociato = BACKGROUND_ALPHA;
            } else if (j == 1)
            {
              _NEIGH_ATTR_FACTOR =  constrain(_NEIGH_ATTR_FACTOR  + ( _keyCode == UP ? 0.001 : -0.001 ), 0, 0.01);
              elementiAggiuntivi[0][j].valueAssociato = _NEIGH_ATTR_FACTOR;
            } else if (j == 2)
            {
              _PUNTIRIF_ATTR_FACTOR =  constrain(_PUNTIRIF_ATTR_FACTOR  + ( _keyCode == UP ? 0.005 : -0.005 ), 0, 0.01);
              elementiAggiuntivi[0][j].valueAssociato = _PUNTIRIF_ATTR_FACTOR;
            } else if (j == 3)
            {
              MAX_RAY =  constrain(MAX_RAY  + ( _keyCode == UP ? 10 : -20 ), 0, 500);
              elementiAggiuntivi[0][j].valueAssociato = MAX_RAY;
            }
          }
        }
      }
    }
  }

  public void disegnami(PGraphics buffer, int _mousex, int _mousey)
  {
    buffer.background(255); 

    if (elementi != null)
    {
      for (int i = 0; i< numElemsY; i++)
      {
        for (int j = 0; j< numElemsX; j++)
        {
          elementi[i][j].disegnami(buffer, _mousex, _mousey, false );
          if (i < 2)
          {

            if (elementi[i][j].keyAssociata == 'c')
            {
              if (i==0)
                functions[j] = "cos";
              else 
              functionsy[j] = "cos";
            }

            if (elementi[i][j].keyAssociata == 's')
            {
              if (i==0)
                functions[j] = "sin";
              else 
              functionsy[j] = "sin";
            } else if (elementi[i][j].keyAssociata == 0)
            {
              if (i==0)
                functions[j] = null;
              else 
              functionsy[j] = null;
            }
          }
        }
      }
    }

    buffer.pushMatrix();
    buffer.translate(10, 70);
    buffer.rotate(-PI * 0.5);

    buffer.textMode(CENTER); 
    buffer.textSize(15);
    buffer.textAlign(CENTER, CENTER); 

    buffer.fill(#8d99ae, 255);

    buffer.text("FUNCTION", 0, 0);  
    buffer.translate(-110, 0);
    buffer.text("ANGLE", 0, 0);  

    buffer.popMatrix();


    buffer.pushMatrix();

    if (elementiAggiuntivi != null)
    {

      for (int j = 0; j< 4; j++)
      {
        elementiAggiuntivi[0][j].disegnami(buffer, _mousex, _mousey, true );
      }
    }




    buffer.popMatrix();
  }
}
