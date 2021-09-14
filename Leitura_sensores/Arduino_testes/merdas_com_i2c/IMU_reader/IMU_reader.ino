/*  
 *  How I2C Communication Protocol Works - Arduino I2C Tutorial
 *  
 *   by Dejan, www.HowToMechatronics.com 
 *   
 */
#include <Wire.h>
int i=0;
long value=0;
int ADXLAddress = 0x68; // Device address in which is also included the 8th bit for selecting the mode, read in this case.
#define X_Axis_Register_DATAX0 0x3F // Hexadecima address for the DATAX0 internal register.
#define X_Axis_Register_DATAX1 0x40 // Hexadecima address for the DATAX1 internal register.
//#define Power_Register 0x2D // Power Control Register
int X0,X1,X_out;
void setup() {
  Wire.begin(); // Initiate the Wire library
  Serial.begin(9600);
  delay(100);
  // Enable measurement
  Wire.beginTransmission(ADXLAddress);
  //Wire.write(Power_Register);
  // Bit D3 High for measuring enable (0000 1000)
  Wire.write(8);  
  Wire.endTransmission();
}
void loop() {
  for(i=0;i<100;i++){
  Wire.beginTransmission(ADXLAddress); // Begin transmission to the Sensor 
  //Ask the particular registers for data
  Wire.write(X_Axis_Register_DATAX0);
  Wire.write(X_Axis_Register_DATAX1);
  
  Wire.endTransmission(); // Ends the transmission and transmits the data from the two registers
  
  Wire.requestFrom(ADXLAddress,2); // Request the transmitted two bytes from the two registers
  
  if(Wire.available()<=2) {  // 
    X0 = Wire.read(); // Reads the data from the register
    X1 = Wire.read();   
  }
  
  Serial.print("X0= ");
  Serial.print(X0, HEX);
  Serial.print("   X1= ");
  Serial.print(X1, HEX);
  Serial.print("             Z = ");
  value = (X0<<8)+X1;
  Serial.println(value);
  
  i=i+1;
  //Serial.println(i);
  }
  exit(0);
}
