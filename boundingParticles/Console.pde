//import processing.awt.PSurfaceAWT.SmoothCanvas;
import com.sun.awt.AWTUtilities;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JRootPane; 
import java.awt.event.ComponentListener;
import java.awt.event.ComponentEvent;
import java.awt.event.MouseMotionAdapter; 
import java.awt.Rectangle;
import java.awt.Frame;
import java.lang.Math;
import java.awt.event.MouseAdapter;
import java.awt.PointerInfo;
import java.awt.MouseInfo;
import java.awt.Point;
import java.awt.Dimension;
import java.awt.Robot;




public class WindowForShittyConsole extends PApplet
{ 

  public int xlFrameInWindow, ylFrameInWindow, wFrame, hFrame;
  JFrame internalJFrame;
  PGraphics buffer; 

  KeysStepSequencer stepSequencer = null;
  long sketchClock = 0;  
  final PApplet motherSketch; 

  public WindowForShittyConsole(int xlFrameInWindow, int ylFrameInWindow, int wFrame, int hFrame, PApplet motherSketch)
  {
    this.motherSketch = motherSketch;
    this.xlFrameInWindow = xlFrameInWindow; 
    this.ylFrameInWindow = ylFrameInWindow; 
    this.wFrame = wFrame; 
    this.hFrame = hFrame;  
    runSketch(new String[]{}); /*this starts the sketch in a new jframe */
  }


  //@Override from PApplet
  void setup()
  {

    this.buffer = createGraphics(wFrame, hFrame); //serve visto che le primitive di draw le facciamo in classi esterne alla seconda applet
    //nel caso in cui si usano seconde applet non si possono fare disegni in classi esterne, come avviene con la mail applet
    //ma bisogna scrivere su un buffer e poi scaricarlo internamente alla seconda applet
    surface.setResizable(true);    
    this.getSurface().setSize(this.wFrame, this.hFrame); 
    background(0); 
    this.getSurface().setLocation(this.xlFrameInWindow, this.ylFrameInWindow);

    this.stepSequencer = new KeysStepSequencer(new PVector(30, 10), wFrame-50, hFrame-20, functions.length);
  }



  public void draw()
  { 

    if (stepSequencer != null)
    {

      buffer.beginDraw(); 

      stepSequencer.disegnami(buffer, mouseX, mouseY);
      buffer.endDraw();
      image(buffer, 0, 0);
      
       
    }
  }



  public void mouseClicked()
  {
    stepSequencer.checkEventoMouse(mouseX, mouseY, "click");
  }

  public void mousePressed()
  {
    startMouseRegionDrag = new PVector(mouseX, mouseY);
  }

  public void mouseReleased()
  {
    endMouseRegionDrag = new PVector(mouseX, mouseY); 
    stepSequencer.checkEventoMouse(mouseX, mouseY, "dragArea");
  }

  public void keyPressed()
  {
  
    
    stepSequencer.checkEventoKey(key,keyCode, "keypressed");
  }
} 
