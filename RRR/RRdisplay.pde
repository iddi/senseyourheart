class RRdisplay {
  int cnt;
  int SIZE;//need 150 or more for 750 wide screen, set in setup
  int xbuffer[];
  int hbuffer[];
  int pbuffer[];

  RRdisplay() {
    cnt=0;
    SIZE=width/5;
    xbuffer = new int[SIZE];
    hbuffer = new int[SIZE];
    pbuffer = new int[SIZE];
  }

  void next(int RR) {
    int H=(1600-RR)/10; 
    int X=5*cnt;
    if (H<0) H=0;//height of bar
    xbuffer[cnt]=X;
    hbuffer[cnt]=H;
    pbuffer[cnt]=100;
    cnt = (cnt+1)%(SIZE);
  }

  void step() {
    doforgetfulness();
    dobars();
  }

  private void doforgetfulness() {
    int Pfactor=100-1500/(5*SIZE); 
    if (Pfactor<90) Pfactor=90;
    if (Pfactor>99) Pfactor=99;
    for (int i=0; i<SIZE; i++) {
      pbuffer[i]=Pfactor*pbuffer[i]/100;
    }
  }    

  private void dobar(int X, int P, int H) {
    int Hmax = 100;
    //P is presence 0..100% 
    int R=25; 
    int G=255; 
    int B=125;
    strokeWeight(1);
    stroke(0, 0, 0); 
    fill(0, 0, 0); 
    rect(X, height-Hmax, 4, Hmax);//clear old bar 
    R=(P*R)/100; 
    G=(P*G)/100; 
    B=(P*B)/100;
    stroke(R/2, G/2, B/2); 
    fill(R, G, B); 
    rect(X, height-H, 4, H);//bar is 5 wide
  }

  private void dobars() {
    for (int i=0; i<SIZE; i++) {
      dobar(xbuffer[i], pbuffer[i], hbuffer[i]);
    }
  }
}

