int pin = 6;
float duration;

void setup() {
  Serial.begin(9600);
  pinMode(pin, INPUT);
}

void loop() {
  //delay(1000);
  //0uration = digitalRead(pin);
  duration = pulseIn(pin, HIGH);
  Serial.print("\n");
  Serial.println(duration);
  //delay(1000);
  
}
