import processing.serial.*;

int candidate = 1;
int lf = 10;
Serial arserial;
PFont font;
ArrayList macPrimes;
ArrayList ardPrimes;
float macPrimePerSec;
float ardPrimePerSec;
String fromArduino;
long t;

void setup()
{
  size(800,300);
  fill(255);
  
  frameRate(500);
  
  font = loadFont("BankGothic-Light-48.vlw");
  textFont(font);
  stroke(153);
  
  macPrimes = new ArrayList();
  ardPrimes = new ArrayList();
  
  // it's the fourth port on my macbook professional
  try {
    arserial = new Serial(this, Serial.list()[4], 115200);
  
    arserial.clear();
  }
  catch (Exception ex) {
    println("Failed to find Arduino");
  }
  
  t = 1;
  
  // read the prime
  //arserial.bufferUntil(lf);
}

void draw() 
{ 
  background(0);
  
  t = millis();
  
  // check to see if we have a new prime from the arduino
  if (arserial != null) {
    while (arserial.available() > 0) {
      fromArduino = arserial.readStringUntil(lf);
      //pr(arserial.read());
      if (fromArduino != null) {
        ardPrimes.add(fromArduino);
        //pr(int(fromArduino));
      }
    }
  }
  
  // compute the next prime locally
  if (isPrime(candidate)) {
    macPrimes.add(candidate);
  }
  candidate++;
  
  // status
  fill(255, 255, 255);
  textAlign(CENTER);
  textSize(55);
  text("COMPUTATRON PRIME", width/2, 50);
  
  // mac
  if (macPrimes.size() > 1) {
    fill(0, 255, 0);
    textAlign(LEFT);
    textSize(45);
    text("Local", 100, 150);
    textSize(24);
    text("max: " + macPrimes.get(macPrimes.size()-1), 20, 210);
    macPrimePerSec = macPrimes.size() / (float)(t/1000);
    text("primes/sec: " + str(macPrimePerSec), 20, 240);
  }
  
  // arduino
  if (ardPrimes.size() > 1) {
    fill(0, 0, 255);
    textAlign(RIGHT);
    textSize(45);
    text("Arduino", width - 100, 150);
    textSize(24);
    text("max: " + ardPrimes.get(ardPrimes.size()-1), width - 20, 210);
    ardPrimePerSec = ardPrimes.size() / frameRate;
    text(str(ardPrimePerSec) + " :primes/sec", width - 20, 240);
  }
  else {
    fill(0, 0, 255);
    textAlign(RIGHT);
    textSize(45);
    text("Arduino", width - 100, 150);
    textSize(24);
    fill(255, 0, 0);
    textAlign(CENTER);
    text("! NO DATA !", width - 200, 210);
  }    
  
  // debug
  fill (255);
  textAlign(LEFT);
  textSize(12);
  text("FPS: " + int(frameRate) + ", ms: " + t, 5, height - 12);
}

void pr(int i) {
  print('\t');
  println(i);
}

boolean isPrime(int i) {
  int factors = 0;
  for (int j = i; j > 1; j--) {
    if (i % j == 0) {
      factors++;
    }
  }
  if (factors == 1) {
    return true;
  }
  else {
    return false;
  }
}
