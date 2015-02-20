class CIRCLEdisplay {
  int prevRR;
  int cnt;
  int SIZE;//need 150 or more for 750 wide screen, set in setup
  int xbuffer[];
  int ybuffer[];
  int pbuffer[];
  int fbuffer[]; //foppen, IE DECREASING COUNTER, "BUDGET"TO GO
  CIRCLEdisplay() {
    prevRR=1000;
    cnt=0;
    SIZE=width/5;
    xbuffer = new int[SIZE];
    ybuffer = new int[SIZE];
    pbuffer = new int[SIZE];
    fbuffer = new int[SIZE];
    for (int i=0;i<SIZE;i++) {
      xbuffer[i]=width/2;
      ybuffer[i]=height/2;
      pbuffer[i]=0;
      fbuffer[i]=0;
    }
  }
  void next(int RRavg, int RR) {
    int x=(RR - RRavg) / 3;
    int y=-(prevRR - RRavg) / 3;
    int xRot =  (7*x)/10 + (7*y)/10;// rotate -45 
    int yRot = -(7*x)/10 + (7*y)/10;//7/10 = sin 45
    xRot = 2*xRot;//stretch horizontally
    prevRR = RR;
    xbuffer[cnt]=width/2+xRot;
    ybuffer[cnt]=height/2+yRot;
    pbuffer[cnt]=100;
    fbuffer[cnt]=SIZE/2;
    cnt = (cnt+1)%(SIZE);
  }
  void step() {
    doforgetfulness();
    doblocksandlines();
  }
  private void doforgetfulness() {
    int Pfactor=90;
    for (int i=0;i<SIZE;i++) {
      if (fbuffer[i]>0) 
        pbuffer[i]=Pfactor*pbuffer[i]/100;
      fbuffer[i]--;
    }
  }    
  private void doblock(int X, int Y, int P) {
    int R=255; 
    int G=25; 
    int B=25;
    R=(P*R)/100; 
    G=(P*G)/100; 
    B=(P*B)/100;
    strokeWeight(1); 
    stroke(R/2,G/2,B/2); 
    fill(R,G,B); 
    rect(X,Y,6,6);//block is 7 wide
  }
  private void doline(int X, int Y, int PX, int PY, int P) {
    int Hmax = 160;
    //P is presence 0..100% 
    int R=255; 
    int G=25; 
    int B=25;
    R=(P*R)/100; 
    G=(P*G)/100; 
    B=(P*B)/100;
    strokeWeight(1); 
    stroke(R,G,B); 
    line(X+2,Y+2,PX+2,PY+2);
  }
  private int prev(int i) {
    if (i>0) return i-1;
    else return SIZE-1;
  }
  private int nxt(int i) {
    if (i<SIZE-1) return i+1;
    else return 0;
  }
  private void doblocksandlines() {
    int j=cnt; 
    for (int i=0;i<SIZE;i++) {
      j=nxt(j);//write newest last
      if (fbuffer[j]>0)
        doblock(xbuffer[j],ybuffer[j],pbuffer[j]);
      if (fbuffer[j]>0 && fbuffer[prev(j)]>0)
        doline(xbuffer[j],ybuffer[j],xbuffer[prev(j)],ybuffer[prev(j)],pbuffer[j]);
    }
  }
}

