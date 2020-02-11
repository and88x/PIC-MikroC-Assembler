char txt[10];

char i,uart_rd;                              // Loop variable
char *texto;
float conversion;

void ADC1Int() org 0x2E{               // Dirección en el vector de interrupciones para el timer 3
  LATB15_bit = ~LATB15_bit;            // Invierte el puerto B15
  IFS0bits.AD1IF=0;                            // Borra la petición de interrupción
}

void Timer3Int() org 0x24{             // Dirección en el vector de interrupciones para el timer 3
  LATB14_bit = ~LATB14_bit;            // Invierte el puerto B14
  IFS0bits.T3IF = 0;                            // Borra la petición de interrupción
}

void main(){
  RPOR3=0x0003;

  UART1_Init(9600);               // Initialize UART module at 9600 bps
  Delay_ms(1000);
  
//  Configuración del ADC
AD1CON1bits.DONE=0;
AD1CON1bits.SAMP=0;
AD1CON1bits.ASAM=1;
AD1CON1bits.SIMSAM=1;
AD1CON1bits.SSRC=2;
AD1CON1bits.FORM=0;
AD1CON1bits.AD12B=0;
AD1CON1bits.ADSIDL=0;
AD1CON1bits.ADON=1;

  AD1CON3 = 0x1003;   //ADCS=3 (min TAD for 10MHz (16TAD) is 3*TCY=300ns)
  AD1CON2 = 0x0300;   //Interrupt upon completion of one sample/convert
                      //Converts CH0, CH1, CH2 and CH3
  
  AD1CHS123 = 0x0101;
            //CH1 positive input is AN3, CH2 positive input is AN4, CH3 positive input is AN5
            //CH1 positive input is AN3, CH2 positive input is AN4, CH3 positive input is AN5
  AD1CHS0  = 0x0000;
  AD1CSSL = 0;               //No scan
  AD1PCFGL = 0xFFE0;    //AN0 to AN5 como analógicos
  AD1CON1.F15 = 1;           //ADC on
  
// Configuración del timer3
  IPC1  = IPC1 | 0x1000;    // Prioridad del Timer3 es 1
  T3IE_bit = 1;
  IEC0  = IEC0 | 0x0080;    // Habilitación de interrupción del Timer3
  PR2   = 34464;            // Período de interrupción es 100 000 ciclos
  PR3   = 0x0001;           // Total PR3/2=1*65536 + 34464
  T3CON = 0x8000;           //10000000 00000000
  
  TRISB15_bit=0;
  TRISB14_bit=0;
  LATB15_bit=0;
  LATB14_bit=0;
  
  while(1) {                         // Endless loop

    AD1CON1.F1 = 1;                  //Start sampling (SAMP=1)
    Delay_ms(100);                   //Wait for 100ms (sampling ...)
    AD1CON1.F1 = 0;                  //Clear SAMP bit (trigger conversion)
    while (AD1CON1.F0 == 0)
    asm nop;                         //Wait for DONE bit in ADCON1
    conversion=5.*ADC1BUF0/1024.;
    FloatToStr(conversion, txt);
    UART_Write_Text("AN0=");
    UART_Write_Text(txt);
    UART_Write(9);
    
    conversion=5.*ADC1BUF1/1024.;
    FloatToStr(conversion, txt);
    UART_Write_Text("AN1=");
    UART_Write_Text(txt);
    UART_Write(9);
    
    conversion=5.*ADC1BUF2/1024.;
    FloatToStr(conversion, txt);
    UART_Write_Text("AN2=");
    UART_Write_Text(txt);
    UART_Write(9);
        
    conversion=5.*ADC1BUF3/1024.;
    FloatToStr(conversion, txt);
    UART_Write_Text("AN3=");
    UART_Write_Text(txt);
    UART_Write(9);
    UART_Write(13);
    delay_ms(1000);
  }

}