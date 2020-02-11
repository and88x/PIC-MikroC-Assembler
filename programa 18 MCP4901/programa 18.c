// Conecciones del módulo DAC
sbit Chip_Select at RC0_bit;
sbit Chip_Select_Direction at TRISC0_bit;
// Fin de conecciones del módulo DAC
unsigned int value;
char *puntero;
bit despliegue;

 void DAC_Output(unsigned int valueDAC) {
  char temp;

  Chip_Select = 0;                       // Seleccciona el DAC

  // Envío del byte mas significativo
  temp = (valueDAC >> 8) & 0x0F;         // Guarda valueDAC[11..8] a temp[3..0]
  temp |= 0x30;                          // Define la configuración del DAC, ver el datasheet del MCP4921
  SPI1_Write(temp);                      // Envía el byte mas significativo por el SPI

  // Envío del byte menos significativo
  temp = valueDAC;                       // Guarda valueDAC[7..0] a temp[7..0]
  SPI1_Write(temp);                      // Envía el byte menos significativo por el SPI

  Chip_Select = 1;                       // Deselecciona el DAC
  despliegue=0;
}

interrupt() {
 if(TMR1IF_bit){
   TMR1IF_bit=0;
   RD1_bit=~RD1_bit;
   }
  if(CCP2IF_bit){
    CCP2IF_bit=0;
    RD1_bit=1;
    TMR1H=0;
    TMR1L=0;
  }
    if(ADIF_bit){
    ADIF_bit=0;
    *puntero=ADRESL;
    *(puntero+1)=ADRESH;
    RD1_bit=0;
    despliegue=1;
  }
 }
 
void main() {
 TRISD=0X00;
 PORTD=0x00;
 Chip_Select=0;
 Chip_Select_Direction=0;
 
 //Configuración del timer 1
 RD16_T1CON_bit=1;     //Habilita el TIMER1 en timer de 16 bits
 T1RUN_bit=1;    //
 T1CKPS0_bit=0;
 T1CKPS1_bit=0;
 T1OSCEN_bit=0;  //Oscilador del Timer1 apagado
 T1SYNC_bit=0;   //No interesa con TMR1CS=0
 TMR1CS_bit=0;   //FOSC/4
 TMR1ON_bit=1;   //Encendido del Timer
//Configuración del timer 3

 T3CCP2_bit=0;  // Timer 1 es la fuente de reloj para los  modulos CCP
 T3CCP1_bit=0;  //
 
 //Configuración del CCP
 
 CCP2CON= 0X0B; //Dispara del ADC
 CCPR2H=0x13;
 CCPR2L=0x88;
 
 //Configuración del ADC
 ADCON0=0x01;
 ADCON1=0x00;
// ADCON2=0b10111110;
ADCON2=0b10111110;

 
 //Configuracion de las interrupciones
 
 GIE_bit=1;
 PEIE_bit=1;
 TMR1IE_bit=1;
 CCP2IE_bit=1;
 ADIE_bit=1;
 
  TMR1IF_bit=0;
  
  puntero=&value;
  SPI1_Init();
    while(1){
      if(despliegue){
        //DAC_Output(value);                   // Envía el valor al DAC
        despliegue=0;
       }
    }

}