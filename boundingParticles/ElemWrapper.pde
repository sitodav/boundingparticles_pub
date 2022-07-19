class ElemWrapper
{
   public int idx;
   float x,y ;
   public PVector goToVect;
   public long internalClock;
   public InternalData internalData;
   public color col;
   public int myRefRegion;
   
   public ElemWrapper(int idx,float x,float y,  PVector goToV, long internClock, InternalData internalData, color col, int myRefRegion)
   {
     this.idx = idx; this.x = x; this.y = y;   this.goToVect = goToV; this.internalClock = internClock; this.internalData = internalData; this.col= col; this.myRefRegion = myRefRegion;
   }
   
   
}

class InternalData
{
  public int randomI;
  public InternalData(int i ){this.randomI = i;}
}
