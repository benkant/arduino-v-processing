int candidate = 1;
int found = 0;

void setup() {
  Serial.begin(115200);
  //Serial.println("Primes:");
}

void loop() {
  if (isPrime(candidate)) {
    pr(candidate);
    found++;
  }
  
  candidate++;
}

void pr(int i) {
  Serial.println(i);
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
