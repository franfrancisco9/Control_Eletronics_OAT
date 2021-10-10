/*
 * SD Card Module Interfacing with Arduino Uno
 * https://www.electroniclinic.com/
 */
 
#include <SPI.h> //for the SD card module
#include <SD.h> // for the SD card
 
const int chipSelect = 10; 
 
// Create a file to store the data
File myFile;
 
int Vresistor = A0; // Potentiometer is connected with the Analog pin A0
int Vrdata; // A variable used to store the Potentiometer value
 
void setup() {
 
 
  //initializing Serial monitor
  Serial.begin(9600); // Baud rate
  pinMode(Vresistor, INPUT); // Sets the Analog pin A0 as the Input. 
 
    
  // setup for the SD card
  Serial.print("Initializing SD card...");
 
  if(!SD.begin(chipSelect)) {
    Serial.println("initialization failed!");
    return;
  }
  Serial.println("initialization done.");
    
  //open file
  myFile=SD.open("DATA.txt", FILE_WRITE);
 
  // if the file opened ok, write to it:
  if (myFile) {
    Serial.println("File opened ok");
    // print the headings for our data
    myFile.println("Logging Variable Resistor Values");
  }
  myFile.close();
}
 
 
 
void LoggingVresistor() {
 
  Vrdata = analogRead(Vresistor); // reading the Potentiometer
  Serial.println(Vrdata); // print it on the Serial monitor for debugging purposes. You can Commnent this line.
  myFile = SD.open("DATA.txt", FILE_WRITE); // opens the fils DATA, which is the text file, for writing the Pot value.
  if (myFile) {
    Serial.println("open with success");
    myFile.print("Variable Resistor ");
    myFile.print(",");
    myFile.print(Vrdata);
    myFile.println();
  }
  myFile.close();
}
 
void loop() {
 
  LoggingVresistor();
  delay(5000); // delay of 5 seconds. 
}
