class RRport { 
  private Serial myPort;
  private int[] buffer = new int[100];
  private int   bufcnt = 0;
  RRport(PApplet parent) {  
    String portName = Serial.list()[2]; 
    //com7, arduino, lower usb right (loe's laptop) 
    //of bovenste, front, loe's pc hg3.53 
    println(Serial.list());
    println("portName: "+ portName);
    myPort = new Serial(parent, portName, 19200);

    println("Waiting for >");
    while (true) {
      if(myPort.available()==0){
          delay(50);
          continue;
      }
      else if (myPort.read()=='>')
        break;
    }

      myPort.write('I'); 
      println(">I");
  } 
  
  void putbuf(int c) {
    if(bufcnt>=100-1) println("OVERFLOW buffer ERROR"); 
    buffer[bufcnt++]=c;
  }
  
  int  getbuf() {
    if (bufcnt<=0) println("UNDERFLOW buffer ERROR"); 
    int v=buffer[0];
    //works like FIFO, shift rest again
    int i=0;
    while (i<bufcnt-1) { 
      buffer[i]=buffer[i+1];
      i++;
    }     //alternative: cyclic buffer, not now
    bufcnt--;
    return v;
  }
  void step() {
    while (myPort.available()>0) {
      int inByte = int(myPort.read()); 
      putbuf(inByte);
    }
  }
} //     RRport

