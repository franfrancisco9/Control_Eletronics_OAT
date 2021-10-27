#include "MPU9250.h"
#include <Wire.h>
#include <Adafruit_ADS1X15.h>

// an MPU9250 object with the MPU-9250 sensor on I2C bus 0 with address 0x68
MPU9250 IMU(Wire,0x68);
Adafruit_ADS1115 ads1115;


int16_t sensorValue;
float VS = 5; //volts
float air_density = 1.225; // Kg/m^3

int status;

void setup() {
  // serial to display data
  ads1115.begin();
  Serial.begin(9600);
  while(!Serial) {}

  // start communication with IMU 
  status = IMU.begin();
  if (status < 0) {
    Serial.println("IMU initialization unsuccessful");
    Serial.println("Check IMU wiring or try cycling power");
    Serial.print("Status: ");
    Serial.println(status);
    while(1) {}
  }
  // setting the accelerometer full scale range to +/-8G 
  IMU.setAccelRange(MPU9250::ACCEL_RANGE_8G);
  // setting the gyroscope full scale range to +/-500 deg/s
  IMU.setGyroRange(MPU9250::GYRO_RANGE_2000DPS);
  // setting DLPF bandwidth to 20 Hz
  IMU.setDlpfBandwidth(MPU9250::DLPF_BANDWIDTH_20HZ);
  // setting SRD to 19 for a 50 Hz update rate
  IMU.setSrd(19);
}

void loop() {
  float DP, volts, veloc;
    
  sensorValue = ads1115.readADC_SingleEnded(0);
   //o UNO e o NANO usam ambos uma escala de 0 a 5V no analog
  volts = sensorValue*VS/27040;
  
  DP = (volts-VS/2)*5/VS;
  
  //DP = (sensorValue*5/1024-zeroVS)/(maxVS-zeroVS)*2; // kPa

  if(DP>0){
    veloc = sqrt(2*DP*1000/air_density); // m/s
  }
  else{
    veloc = -sqrt(2*abs(DP)*1000/air_density); // m/s
  }
  Serial.print("sensor reading = ");
  Serial.print(sensorValue);
  Serial.print("     V = ");
  Serial.print(volts, 4);
  Serial.print("     DP = ");
  Serial.print(DP, 4);
  Serial.print("     veloc = ");
  Serial.println(veloc, 2);
  
  // read the sensor
  IMU.readSensor();
  // display the data
  Serial.println(" ");
  Serial.println(" ");
  Serial.println(" ");
  Serial.print("Accelx:");
  Serial.println(IMU.getAccelX_mss(),6);
  Serial.print("Accely:");
  Serial.println(IMU.getAccelY_mss(),6);
  Serial.print("Accelz:");
  Serial.println(IMU.getAccelZ_mss(),6);
  Serial.print("Gyrox:");
  Serial.println(IMU.getGyroX_rads(),6);
  Serial.print("Gyroy:");
  Serial.println(IMU.getGyroY_rads(),6);
  Serial.print("Gyroz:");
  Serial.println(IMU.getGyroZ_rads(),6);
  Serial.print("Magx:");
  Serial.println(IMU.getMagX_uT(),6);
  Serial.print("Magy:");
  Serial.println(IMU.getMagY_uT(),6);
  Serial.print("Magz:");
  Serial.println(IMU.getMagZ_uT(),6);
  Serial.print("Temperatura:");
  Serial.println(IMU.getTemperature_C(),6);
  delay(1000);
} 
