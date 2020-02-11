// Conecciones del módulo DAC
sbit Chip_Select at RC0_bit;
sbit Chip_Select_Direction at TRISC0_bit;

sbit HA_1 at LATB0_bit;
sbit HA_2 at LATB1_bit;
sbit HA_3 at LATB2_bit;
sbit HA_4 at LATB3_bit;
sbit pulsante at RB7_bit;

// Fin de conecciones del módulo DAC
unsigned int value, aux_value,promedio[10],promedio_dato,n_promedio,k,umbral;
long int desviacion;
char *puntero,i,j;
bit despliegue;
float x0[4]={0,0,0,0},x1[4]={0,0,0,0},x2[4]={0,0,0,0},y0[4]={0,0,0,0},y1[4]={0,0,0,0},y2[4]={0,0,0,0};

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
 
          x0[0] = (float)(value-512.0);
         //Implementación de la ecuación en diferencias.
         y0[0] = x0[0]*0.145323883877042+x1[0]*0.290647767754085+x2[0]*0.145323883877042 + y1[0]*0.671029090774096
         -y2[0]*0.252324626282266;

         //Corrimiento de los valores x(n), y y(n).
         y2[0] = y1[0];
         y1[0] = y0[0];
         x2[0] = x1[0];
         x1[0] = x0[0];
         //Reconstrucción de la señal: y en 10 bits.
         value = (unsigned int)(y0[0]+512);

         if(value>aux_value)aux_value=value;
         else{
               aux_value=aux_value-10;
               if (aux_value<0)aux_value=value;
              }
        promedio[j]=aux_value;
        promedio_dato=0;
        for(i=0;i<n_promedio;i++){
           promedio_dato=promedio_dato+promedio[i];
        }
       promedio_dato=promedio_dato/n_promedio;
       j++;
       k++;
       if(j>n_promedio)j=0;
       desviacion=desviacion+promedio_dato;
       if(promedio_dato>umbral){
       LATD0_bit=1;
         }
       else {
       LATD0_bit=0;
            }
    RD1_bit=0;
    despliegue=1;

  }
 }
 
void main() {
 TRISB=0XF0;
 HA_1=1;
 HA_2=0;
 HA_3=0;
 HA_4=0;
 
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
 CCPR2H=0x0F;
 CCPR2L=0xA0;
 
 //Configuración del ADC
 ADCON0=0x01;
 ADCON1=0x00;
 ADCON2=0b10000010;

 j=0;
 k=0;
 umbral=0;
 n_promedio=10;

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
      if(!pulsante){
         while(!pulsante);
         HA_1=~HA_1;
      }
      if(despliegue){
        DAC_Output(value<<2);                   // Envía el valor al DAC
        despliegue=0;
       }
      if(k>1000){
         umbral=desviacion/k+20;
         k=0;
         desviacion=0;

      }
    }

}