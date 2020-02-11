#line 1 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/programa 18/programa 18.c"

sbit Chip_Select at RC0_bit;
sbit Chip_Select_Direction at TRISC0_bit;

unsigned int value;
char *puntero;
bit despliegue;

 void DAC_Output(unsigned int valueDAC) {
 char temp;

 Chip_Select = 0;


 temp = (valueDAC >> 8) & 0x0F;
 temp |= 0x30;
 SPI1_Write(temp);


 temp = valueDAC;
 SPI1_Write(temp);

 Chip_Select = 1;
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


 RD16_T1CON_bit=1;
 T1RUN_bit=1;
 T1CKPS0_bit=0;
 T1CKPS1_bit=0;
 T1OSCEN_bit=0;
 T1SYNC_bit=0;
 TMR1CS_bit=0;
 TMR1ON_bit=1;


 T3CCP2_bit=0;
 T3CCP1_bit=0;



 CCP2CON= 0X0B;
 CCPR2H=0x13;
 CCPR2L=0x88;


 ADCON0=0x01;
 ADCON1=0x00;

ADCON2=0b10111110;




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

 despliegue=0;
 }
 }

}
