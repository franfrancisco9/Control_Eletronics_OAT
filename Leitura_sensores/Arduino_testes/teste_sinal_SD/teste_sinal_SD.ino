// Programa: Gravacao com modulo cartao SD 
#include <SdFat.h> 
SdFat sdCard;
SdFile meuArquivo; 
// Pino ligado ao CS do modulo
const int chipSelect = 4;
int pin = 6;
int valor=0;
void setup()
{
  // Define o pino do potenciometro como entrada
  pinMode(pin, INPUT);
  // Inicializa o modulo SD
  if(!sdCard.begin(chipSelect,SPI_HALF_SPEED))sdCard.initErrorHalt();
  // Abre o arquivo LER_POT.TXT
  if (!meuArquivo.open("ler_pot.txt", O_RDWR | O_CREAT | O_AT_END))
  {
    sdCard.errorHalt("Erro na abertura do arquivo LER_POT.TXT!");
  }
}
 
void loop()
{
  // Leitura da porta A5/Potenciometro
  valor = pulseIn(pin, HIGH);
 
  // Grava dados do potenciometro em LER_POT.TXT
  meuArquivo.open("ler_pot.txt", O_RDWR | O_CREAT | O_AT_END);
  meuArquivo.println(valor);
  meuArquivo.close();
  
  delay(500);
}
