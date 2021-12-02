
#include <Wire.h>
#include <Adafruit_ADS1X15.h>
//--------------------------------------
#include <SdFat.h>
//--------------------------------------
#include "MPU9250.h"

Adafruit_ADS1115 ads1115;

#define pushButton 2
#define VS 5 //volts
#define air_density 1.225 // Kg/m^3
#define chipSelect 4

int16_t pref = 0;
int16_t sensorValue;
//float zeroVS = VS/2;
//float maxVS = VS*4.5/5;
//----------------------------------------
SdFat sdCard;
SdFile meuArquivo; 
// Pino ligado ao CS do modulo
//const int chipSelect = 4;
//-----------------------------------------
MPU9250 IMU(Wire,0x68);
int status;

void setup() {
  // declare the ledPin as an OUTPUT:
  Serial.begin(9600);
  ads1115.begin();
  pinMode(pushButton, INPUT_PULLUP);
  //----------------------------------------
  // Define o pino do potenciometro como entrada
  // Inicializa o modulo SD
  if(!sdCard.begin(chipSelect,SPI_HALF_SPEED))sdCard.initErrorHalt();
  // Abre o arquivo LER_POT.TXT
  if (!meuArquivo.open("data_arduino.txt", O_RDWR | O_CREAT | O_AT_END))
  {
    sdCard.errorHalt("Erro na abertura do arquivo data_arduino.txt!");
  }
  meuArquivo.println("sensor_reading pref Accelx Accely Accelz Gyrox Gyroy Gyroz Magx Magy Magz Temperatura(C)");
  meuArquivo.close();

  //-------------------------------------------
  //while(!Serial) {}

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
  // read the value from the sensor:
  int buttonState = digitalRead(pushButton);
  
  sensorValue = ads1115.readADC_SingleEnded(0);
  //o UNO e o NANO usam ambos uma escala de 0 a 5V no analog  

  if(!buttonState){
    pref=sensorValue;
  }

  Serial.print("sensor reading = ");
  Serial.print(sensorValue);
  Serial.print("     pref = ");
  Serial.print(pref);
  //------------------------------------------
  // read the sensor
  IMU.readSensor();
  // display the data
  Serial.print("     Accelx:");
  Serial.print(IMU.getAccelX_mss(),6);
  Serial.print("     Accely:");
  Serial.print(IMU.getAccelY_mss(),6);
  Serial.print("     Accelz:");
  Serial.println(IMU.getAccelZ_mss(),6);
  /*
  Serial.print("     Gyrox:");
  Serial.print(IMU.getGyroX_rads(),6);
  Serial.print("     Gyroy:");
  Serial.print(IMU.getGyroY_rads(),6);
  Serial.print("     Gyroz:");
  Serial.print(IMU.getGyroZ_rads(),6);
  Serial.print("     Magx:");
  Serial.print(IMU.getMagX_uT(),6);
  Serial.print("     Magy:");
  Serial.print(IMU.getMagY_uT(),6);
  Serial.print("     Magz:");
  Serial.print(IMU.getMagZ_uT(),6);
  Serial.print("     Temperatura:");
  Serial.println(IMU.getTemperature_C(),6);*/
  //--------------------------------------------------
  // Leitura da porta A5/Potenciometro
  // Grava dados do potenciometro em LER_POT.TXT
  meuArquivo.open("data_arduino.txt", O_RDWR | O_CREAT | O_AT_END);
  
  meuArquivo.print(sensorValue);
  meuArquivo.print(" ");
  meuArquivo.print(pref);
  meuArquivo.print(" ");

  
  meuArquivo.print(IMU.getAccelX_mss(),6);
  meuArquivo.print(" ");
  meuArquivo.print(IMU.getAccelY_mss(),6);
  meuArquivo.print(" ");
  meuArquivo.print(IMU.getAccelZ_mss(),6);
  meuArquivo.print(" ");
  meuArquivo.print(IMU.getGyroX_rads(),6);
  meuArquivo.print(" ");
  meuArquivo.print(IMU.getGyroY_rads(),6);
  meuArquivo.print(" ");
  meuArquivo.print(IMU.getGyroZ_rads(),6);
  meuArquivo.print(" ");
  meuArquivo.print(IMU.getMagX_uT(),6);
  meuArquivo.print(" ");
  meuArquivo.print(IMU.getMagY_uT(),6);
  meuArquivo.print(" ");
  meuArquivo.print(IMU.getMagZ_uT(),6);
  meuArquivo.print(" ");
  meuArquivo.println(IMU.getTemperature_C(),6);
  
  meuArquivo.close();

  //------------------------------------------------
  delay(500);
}
