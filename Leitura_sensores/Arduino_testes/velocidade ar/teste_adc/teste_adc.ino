#include <Wire.h>
#include <Adafruit_ADS1X15.h>

Adafruit_ADS1115 ads1115;
int16_t adc0;

void setup(void)
{
  Serial.begin(9600);
  Serial.println("Hello!");
  Serial.println("Getting single-ended readings from AIN0..3");
  Serial.println("ADC Range: +/- 6.144V (1 bit = 3mV)");
  ads1115.begin();
}

void loop(void)
{

  adc0 = ads1115.readADC_SingleEnded(0);
  
  Serial.print("AIN0: "); Serial.println(adc0);
    
  delay(500);
}
