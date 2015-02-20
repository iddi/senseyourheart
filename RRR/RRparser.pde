class RRparser {
  int val = 0;
  int avg = 1000;
  private int tmp=0;
  private boolean flag;
  boolean event() {
    if (flag) {
      flag = false; 
      return true;
    }  
    else return false;
  }    
  void step() {
    int b;
    //print('.');
    while (myport.bufcnt>0) {
      b=myport.getbuf(); 
      //print(char(b));      
      //if (b==13) println("CR");//TZT WEGECOOMENTEREN
      //if (b==10) println("LF");//TZT  ERUITCOMMENT
      if ((tmp>0)&&(b==10||b==13)) {
        flag = true; 
        val=tmp/1000;//ms ipv us
        if (val>600&&val<1600) avg = 9*(avg/10) + val/10;   //fake feedback         
        if (val<0.5*avg) {
          println(" adjusting sensor "); 
          output.println(0); 
          flag=false;
        }  
        if (val>1.5*avg) {
          println(" ADJUSTING SENSOR "); 
          output.println(00); 
          flag=false;
        }
      }
      if ((b==10||b==13)) tmp=0;     
      if (b!=10&&b!=13)   tmp=16*tmp + hex2int(b); //msb first
    }
  }
  private int hex2int(int c) {
    if (c=='0') return 0;  
    if (c=='1') return 1;  
    if (c=='2') return 2;  
    if (c=='3') return 3;
    if (c=='4') return 4;  
    if (c=='5') return 5;  
    if (c=='6') return 6;  
    if (c=='7') return 7;
    if (c=='8') return 8;  
    if (c=='9') return 9;  
    if (c=='A') return 10; 
    if (c=='B') return 11;
    if (c=='C') return 12; 
    if (c=='D') return 13; 
    if (c=='E') return 14; 
    if (c=='F') return 15;
    println("!@#$%"); //TZT ERUIT
    return -1;
  }
}// RRparser

