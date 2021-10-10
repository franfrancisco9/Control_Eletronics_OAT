
int sensorPin = A0;    // select the input pin for the potentiometer
float sensorValue = 0;  // variable to store the value coming from the sensor
float VS = 5; //volts
float air_density = 1.225; // Kg/m^3
//float zeroVS = VS/2;
//float maxVS = VS*4.5/5;

void setup() {
  // declare the ledPin as an OUTPUT:
  Serial.begin(9600);
  pinMode(sensorPin, INPUT);
}

void loop() {
  // read the value from the sensor:
  float DP, volts, veloc;
  sensorValue = analogRead(sensorPin);
  //o UNO e o NANO usam ambos uma escala de 0 a 5V no analog
  volts = sensorValue*VS/1024;
  
  DP = (volts-VS/2)*5/VS;
  
  //DP = (sensorValue*5/1024-zeroVS)/(maxVS-zeroVS)*2; // kPa

  if(DP>0){
    veloc = sqrt(2*DP*1000/air_density); // m/s
  }
  else{
    veloc = -sqrt(2*abs(DP)*1000/air_density); // m/s
  }
  Serial.print("sensor reading = ");
  Serial.print(sensorValue, 1);
  Serial.print("     V = ");
  Serial.print(volts, 4);
  Serial.print("     DP = ");
  Serial.print(DP, 4);
  Serial.print("     veloc = ");
  Serial.println(veloc, 2);
  
  delay(500);
}
