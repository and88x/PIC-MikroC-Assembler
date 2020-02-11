#line 1 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/Ejemplos dsPIC30F4013/programa27.c"
char txt[10];

char i,uart_rd;
char *texto;
float conversion;

void ADC1Int() org 0x2E{
 LATB15_bit = ~LATB15_bit;
 IFS0bits.AD1IF=0;
}

void Timer3Int() org 0x24{
 LATB14_bit = ~LATB14_bit;
 IFS0bits.T3IF = 0;
}

void main(){
 RPOR3=0x0003;

 UART1_Init(9600);
 Delay_ms(1000);


AD1CON1bits.DONE=0;
AD1CON1bits.SAMP=0;
AD1CON1bits.ASAM=1;
AD1CON1bits.SIMSAM=1;
AD1CON1bits.SSRC=2;
AD1CON1bits.FORM=0;
AD1CON1bits.AD12B=0;
AD1CON1bits.ADSIDL=0;
AD1CON1bits.ADON=1;

 AD1CON3 = 0x1003;
 AD1CON2 = 0x0300;


 AD1CHS123 = 0x0101;


 AD1CHS0 = 0x0000;
 AD1CSSL = 0;
 AD1PCFGL = 0xFFE0;
 AD1CON1.F15 = 1;


 IPC1 = IPC1 | 0x1000;
 T3IE_bit = 1;
 IEC0 = IEC0 | 0x0080;
 PR2 = 34464;
 PR3 = 0x0001;
 T3CON = 0x8000;

 TRISB15_bit=0;
 TRISB14_bit=0;
 LATB15_bit=0;
 LATB14_bit=0;

 while(1) {

 AD1CON1.F1 = 1;
 Delay_ms(100);
 AD1CON1.F1 = 0;
 while (AD1CON1.F0 == 0)
 asm nop;
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
