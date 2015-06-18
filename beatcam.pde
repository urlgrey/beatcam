import processing.video.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;
BeatListener bl;
int time;
int wait = 0; // increase if you want to capture images less frequently
Capture cam;
int filterIndex = 0;

class BeatListener implements AudioListener
{
  private BeatDetect beat;
  private AudioPlayer source;

  BeatListener(BeatDetect beat, AudioPlayer source)
  {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }

  void samples(float[] samps)
  {
    beat.detect(source.mix);
  }

  void samples(float[] sampsL, float[] sampsR)
  {
    beat.detect(source.mix);
  }
}

void setup() {
  size(640, 480);

  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }

    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, 640, 480);
    cam.start();     

    minim = new Minim(this);

    song = minim.loadFile("marcus_kellis_theme.mp3", 1024);
    song.play();
    // a beat detection object that is FREQ_ENERGY mode that 
    // expects buffers the length of song's buffer size
    // and samples captured at songs's sample rate
    beat = new BeatDetect(song.bufferSize(), song.sampleRate());
    // set the sensitivity to 300 milliseconds
    // After a beat has been detected, the algorithm will wait for 300 milliseconds 
    // before allowing another beat to be reported. You can use this to dampen the 
    // algorithm if it is giving too many false-positives. The default value is 10, 
    // which is essentially no damping. If you try to set the sensitivity to a negative value, 
    // an error will be reported and it will be set to 10 instead. 
    beat.setSensitivity(50);  
    // make a new beat listener, so that we won't miss any buffers for the analysis
    bl = new BeatListener(beat, song);  
    time = millis();//store the current time
  }
}

void draw() {
  beat.detect(song.mix);
  if (cam.available() == true &&
    beat.isKick() && 
    (millis() - time >= wait)) 
  {
    time = millis();
    cam.read();

    // capture image from camera
    image(cam, 0, 0);

    // cycle through filters
    switch (filterIndex++) {
    case 0:
      filter(THRESHOLD);
      break;
    case 1:
      filter(GRAY);
      break;
    default:
      filter(INVERT);
      filterIndex = 0;
    }
  }
  saveFrame("caps/img-#####.tiff");
}

