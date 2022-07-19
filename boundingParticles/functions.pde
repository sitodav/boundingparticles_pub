

public void muoviParticelle(int direzione, PVector centerRiferimento, int iStart, int iEnd, boolean alterGlobVars, int idxCenterT)
{
  for (int i = iStart; i< iEnd; i++)
  { 
    _moveMe(elems.get(i), idxCenterT);
  }

  for (int i = iStart; i< iEnd; i++)
  { 
    _subisciInfluenza(elems.get(i));
  }
  
  float _mouseX = mouseX ;
  float _mouseY = mouseY ;
  /*for (int i = iStart; i< iEnd; i++)
  { 
     if(!mousePressed)
       break;
    _subisciInfluenzaMouse(_mouseX,_mouseY,elems.get(i));
  } */
  
   for (int i = iStart; i< iEnd; i++)
  { 
     if(!mousePressed)
       break;
    _subisciInfluenzaInvisibile(elems.get(i));
  } 

  updatePuntiRiferimento(direzione, centerRiferimento, alterGlobVars, idxCenterT);

  if (alterGlobVars && direzione > 0)
    globalRotatAngle += velRotGlob;
}

public void disegnaParticelle(int direzione, int idxCenterT)
{

  pushMatrix();
  translate(width * 0.5, height * 0.5);
  //rotateX(PI*0.3f);
  rotate(direzione * globalRotatAngle);
  translate(-width * 0.5, -height * 0.5);
  fill(255, BACKGROUND_ALPHA); 
  rect(0, 0, width, height);
  //background(255);
  for (int i = 0; i< elems.size(); i++)
  { 
    _drawMe(elems.get(i), direzione);
  }



  if (_SHOWPUNTIRIFERIMENTO)
  {
    for (int ii = 0; ii < puntiRiferimentos.get(idxCenterT).length; ii++)
    {
      pushMatrix();
      translate(puntiRiferimentos.get(idxCenterT)[ii].x, puntiRiferimentos.get(idxCenterT)[ii].y);
      //noFill();
      stroke(0, 0, 0, 120);
      ellipse(0, 0, 2, 2);
      popMatrix();
    }
  }

  popMatrix();
}



public void _moveMe(ElemWrapper elm, int idxCenterT)
{
  elm.internalClock +=1;
  for (int i = 0; i < _NUM_OV_MOVEMENTS_PERFRAME; i++)
  {
    if (abs(elm.goToVect.x) > 1.5 || abs(elm.goToVect.y) > 1.5 || abs(elm.goToVect.z) > 1.5)
    {
      float delta = _PUNTIRIF_ATTR_FACTOR * elm.goToVect.x;
      elm.x += delta;
      elm.goToVect.x -= delta;

      delta = _PUNTIRIF_ATTR_FACTOR* elm.goToVect.y;
      elm.y +=delta;
      elm.goToVect.y -= delta;
    } else
    {
      elm.goToVect.x = puntiRiferimentos.get(idxCenterT)[elm.myRefRegion].x - elm.x;
      elm.goToVect.y = puntiRiferimentos.get(idxCenterT)[elm.myRefRegion].y - elm.y;
    }
  }
}

public void _drawMe(ElemWrapper elm, int direzione )
{

  noStroke();
  //fill(elm.col, fillT);

  /*float centerDist = pow(windowCenterVect.x - elm.x, 2)+pow(windowCenterVect.y-elm.y, 2);
   int colIdxRay = (int)constrain(map(centerDist, MIN_RAY, MAX_RAY*MAX_RAY, 0, palettes.length-1), 0, palettes.length-1); 
   
   PVector coorDist = new PVector(elm.x - windowCenterVect.x, elm.y - windowCenterVect.y);
   int colIdxAngle = (int)constrain(map(atan2(coorDist.y, coorDist.x), -PI*0.5, PI*0.5, 0, palettes.length-1), 0, palettes.length-1);
   */
  float fillT = 0;
  if (BACKGROUND_ALPHA < 5)
  {
    fillT = frameCount % 255;
  }
  fill(fillT, _OPACITY);
  //noFill();
  //stroke(0, 55);

  pushMatrix();

  ellipse(elm.x, elm.y, 2, 2);
  popMatrix();
  if (_SHOWLINES && random(1) > 0.7)
  {
    
    
    stroke(0,1);
    //line(elm.x, elm.y, elems.get(elm.internalData.randomI).x, elems.get(elm.internalData.randomI).y);
    
   line(elm.x, elm.y, puntiRiferimentos.get(0)[elm.myRefRegion].x, puntiRiferimentos.get(0)[elm.myRefRegion].y);
  }
}



public void _subisciInfluenzaInvisibile(  ElemWrapper elm)
{
  elm.x += _MOUSE_ATTR_FACTOR * (influenzaInvisibile.x - elm.x);
  elm.y += _MOUSE_ATTR_FACTOR * (influenzaInvisibile.y - elm.y);
}


public void _subisciInfluenzaMouse(float _mouseX, float _mouseY, ElemWrapper elm)
{
  elm.x += _MOUSE_ATTR_FACTOR * (_mouseX - elm.x);
  elm.y += _MOUSE_ATTR_FACTOR * (_mouseY - elm.y);
}

public void _subisciInfluenza(ElemWrapper elm )
{
  try
  {

    elm.x += _NEIGH_ATTR_FACTOR * (elems.get(elm.internalData.randomI).x - elm.x);
    elm.y += _NEIGH_ATTR_FACTOR * (elems.get(elm.internalData.randomI).y - elm.y);
  }
  catch(Exception ex)
  {
  }
}


public void updatePuntiRiferimento(int direzione, PVector centerRiferimento, boolean alterGlobVars, int  idxCenterT)
{
  for (int ii=0; ii < puntiRiferimentos.get(idxCenterT).length; ii++)
  {
    puntiRiferimentos.get(idxCenterT)[ii] = new PVector(puntiRiferimentoRay, puntiRiferimentoRay, puntiRiferimentoRay);
  }


  for (int ii=0; ii < puntiRiferimentos.get(idxCenterT).length; ii++)
  {
    for (int jj=0; jj < functions.length; jj++)
    {
      float funcVal = 1;
      float funcValY = 1;

      if (functions[jj] != null)
        funcVal = functions[jj].equals("sin") ? sin(angoliInizialiPuntiRiferimento[ii] + direzione * functionsAngles[jj]) : cos(angoliInizialiPuntiRiferimento[ii]+direzione*functionsAngles[jj]);
      if (functionsy[jj] != null)
        funcValY = functionsy[jj].equals("sin") ? sin(angoliInizialiPuntiRiferimento[ii]+direzione * functionsAnglesY[jj]) : cos(angoliInizialiPuntiRiferimento[ii]+direzione*functionsAnglesY[jj]);


      puntiRiferimentos.get(idxCenterT)[ii] = new PVector(puntiRiferimentos.get(idxCenterT)[ii].x * funcVal, puntiRiferimentos.get(idxCenterT)[ii].y * funcValY);
    }
  }

  for (int ii=0; ii < puntiRiferimentos.get(idxCenterT).length; ii++)
  {
    puntiRiferimentos.get(idxCenterT)[ii] = new PVector(puntiRiferimentos.get(idxCenterT)[ii].x + centerRiferimento.x, puntiRiferimentos.get(idxCenterT)[ii].y + centerRiferimento.y);
  }

  if (!alterGlobVars)
    return;

  for (int jj=0; jj < functions.length; jj++)
  {
    functionsAngles[jj] = functionsAngles[jj]+functionsAnglesVels[jj];
    functionsAnglesY[jj] = functionsAnglesY[jj]+functionsAnglesVelY[jj];
  }

  puntiRiferimentoRay += (segnoPuntiRiferimentoRay );

  if (puntiRiferimentoRay > MAX_RAY)
  {
    segnoPuntiRiferimentoRay = -1;
  } else if (puntiRiferimentoRay < MIN_RAY)
  {
    segnoPuntiRiferimentoRay = 1;
  }
}




public void initParticles(int idxCenterT, int iStart, int iEnd)
{
  elems.clear();
  for (int idd = 0; idd < _NUM_PARTICLES; idd++)
  {
    elems.add(
      new ElemWrapper( idd, windowCenterVects.get(idxCenterT).x - (-50+random(100)), windowCenterVects.get(idxCenterT).y - (-50 + random(100)), new PVector(0, 0), 0, null, palettes[idd%palettes.length], parseInt(random(4) )  )
      );
  }

  for (int idd = iStart; idd < iEnd; idd++)
  {
    int randomI = iStart + (int)(random( iEnd - iStart ));
    elems.get(idd).internalData = new InternalData(randomI);
    elems.get(idd).col = palettes[idd%palettes.length];

    elems.get(idd).internalClock = 0;
  }
}
