import java.io.*;

interface LubDubHandler {
  void handle(int rr);
}

final class LubDub {
  final String uuid;
  final LubDubHandler handler;
  
  private class T extends Thread {
    public void run() {
      try {
        final ProcessBuilder pb = new ProcessBuilder("/bin/bash", "-lc", "lub-dub " + uuid);
        final Process p = pb.start();
        final InputStreamReader in = new InputStreamReader(p.getInputStream());
        final BufferedReader buf = new BufferedReader(in);
        String line;

        pb.redirectErrorStream(true);
        while ( (line = buf.readLine ()) != null) {
          String[] parts = line.split(",");
          for (int i = 1; i < parts.length; i++)
            handler.handle(Integer.parseInt(parts[i]));
        }
        buf.close();
      } 
      catch (IOException e) {
        e.printStackTrace();
      }
    }
  }

  LubDub(final String uuid, final LubDubHandler handler) {
    this.uuid = uuid;
    this.handler = handler;
    new T().start();
  }
}

