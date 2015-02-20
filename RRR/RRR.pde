import processing.serial.*;
import java.text.*;
import java.util.*;

boolean RRDISPLAY=true;
boolean HRVDISPLAY=true;
boolean CIRCLEDISPLAY=true;

RRport myport;
RRparser myparser;

RRdisplay rrdisplay;
HRVdisplay hrvdisplay;
CIRCLEdisplay circledisplay;

PrintWriter output;
PFont myFont; 
boolean settedup=false;

void setup()
{ 
  int bars=75;
  frameRate(10);
  //myFont = createFont("TimesNewRomanPSMT",16);
  //textFont(myFont);
  size(5*bars,5*bars);
  myport = new RRport(this);
  myparser = new RRparser();
  rrdisplay = new RRdisplay();
  hrvdisplay = new HRVdisplay();
  circledisplay = new CIRCLEdisplay();

  SimpleDateFormat sdf = new SimpleDateFormat("-yyyy-MM-dd/HH-mm"); 
  Date now = new Date(); 
  println("log to logfiles"+sdf.format(now));
  output = createWriter("logfiles"+sdf.format(now)+".txt");


  fill(10,10,10);
  rect(0,0,width,height);
  settedup=true;
}

int RRavg = 1200;
int RRstd = 50;

int time = 0;
int count =0;
void draw() {
  count++;
  count=count%10;
  if (count==9) output.flush();
  time++;
}

void serialEvent(Serial p) { 
  if (settedup) {
    //print("!");
    //zat allemaal eerst in draw
    myport.step();
    myparser.step();
    //if (time/10 > 120) stop();
    if (myparser.event()) {
      int RR = myparser.val; 
      print(" RR="); 
      print(RR); 
      output.println(RR);
      RRavg = int((23 * RRavg + 1*RR)/24); 
      print(" AVG="); 
      print(RRavg);
      RRstd = int((15.0 * RRstd + abs(RR - RRavg)) / 16.0); 
      print(" STD="); 
      print(RRstd);//niet met kwadraat ivm outlyers
      println();
      rrdisplay.next(RR);
      hrvdisplay.next(RRstd);
      circledisplay.next(RRavg,RR);
      if (RRDISPLAY==true) rrdisplay.step();
      if (HRVDISPLAY==true) hrvdisplay.step();
      if (CIRCLEDISPLAY==true) circledisplay.step();

      //float BTopt = 15.00; //assumed resonant breathing rate in seconds
      //int advice = int(BTopt*1000/RRavg); //idem in heart beats
      //fill(30); stroke(0); rect(0,height-16,16,2*16);
      //fill(150); text(Integer.toString(advice),0, height);
    }
  }
}

public void stop() {
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  println("THANK YOU, GOODBYE");
  exit(); // Stops the program
}

void keyPressed() {
}




