//https://forums.adafruit.com/viewtopic.php?f=25&t=70871

#include <Wire.h> //I2C library 0x28H
 
byte fetch_pressure(unsigned int *p_Pressure); //convert value to byte data type
void print_float(float f, int num_digits);

#define TRUE 1
#define FALSE 0

void setup(void)
{
   Serial.begin(9600);
   Wire.begin();
   pinMode(4, OUTPUT);
   pinMode(5, OUTPUT);
   digitalWrite(5, HIGH);  // SCL remains high
   digitalWrite(4, HIGH); // SDA transfers from high to low
   digitalWrite(4, LOW);  // this turns on the MS4525, I think
   delay(5000);
   Serial.println(">>>>>>>>>>>>>>>>>>>>>>>>");  // just to be sure things are working 
}

void loop()
{
  byte _status;
  unsigned int P_dat;
  float PR;
 
  while(1)
  {
    _status = fetch_pressure(&P_dat);
   
    switch(_status)
    {
      case 0: Serial.println("Read_MR.");
      break;
      case 1: Serial.println("Read_DF2.");
      break;
      case 2: Serial.println("Read_DF3.");
      break;
      default: Serial.println("Read_DF4.");
      break;
    }
   
    PR = (float) P_dat;
   
   print_float(PR, 1);
Serial.println(P_dat);
    Serial.print(" ");
    Serial.println();
    delay(1000);
  }
}
 
  byte fetch_pressure(unsigned int *p_P_dat)
  {
   
   
  byte address, Press_H, Press_L, _status;
  unsigned int P_dat;
  address= 0x28;;
  Wire.beginTransmission(address); 
  Wire.endTransmission();
  delay(100);
 
  Wire.requestFrom((int)address, (int) 4);
  Press_H = Wire.read();
  Press_L = Wire.read();
  Wire.endTransmission();
 
 
  _status = (Press_H >> 6) & 0x03;
      Press_H = Press_H & 0x3f;
      P_dat = (((unsigned int)Press_H) << 8) | Press_L;
      *p_P_dat = P_dat;
      return(_status);

 
 
  }
 
  void print_float(float f, int num_digits)
{
    int f_int;
    int pows_of_ten[4] = {1, 10, 100, 1000};
    int multiplier, whole, fract, d, n;

    multiplier = pows_of_ten[num_digits];
    if (f < 0.0)
    {
        f = -f;
        Serial.print("-");
    }
    whole = (int) f;
    fract = (int) (multiplier * (f - (float)whole));

    Serial.print(whole);
    Serial.print(".");

    for (n=num_digits-1; n>=0; n--) // print each digit with no leading zero suppression
    {
         d = fract / pows_of_ten[n];
         Serial.print(d);
         fract = fract % pows_of_ten[n];
    }
} 
