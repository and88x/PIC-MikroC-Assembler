#line 1 "C:/Users/Usuario/Dropbox/materias/microprocesadores 2/programas/programa 27 ADC/programa b/programa27.c"

sbit LCD_RS at LATB4_bit;
sbit LCD_EN at LATB5_bit;
sbit LCD_D4 at LATB0_bit;
sbit LCD_D5 at LATB1_bit;
sbit LCD_D6 at LATB2_bit;
sbit LCD_D7 at LATB3_bit;

sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB0_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB3_bit;


char txt1[] = "mikroElektronika";
char txt2[] = "EasydsPIC4A";
char txt3[] = "Lcd4bit";
char txt4[] = "example";

char i,uart_rd;
char *texto;
float conversion;
void Move_Delay() {
 Delay_ms(500);
}

void main(){
 RPINR18=0xFF07;
 RPOR3=0x0003;
 ADPCFG = 0xFFFF;

 Lcd_Init();

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1,6,txt3);

 Lcd_Out(2,6,txt4);
 Delay_ms(2000);
 Lcd_Cmd(_LCD_CLEAR);

 Lcd_Out(1,1,txt1);
 Lcd_Out(2,5,txt2);
 UART1_Init(9600);
 Delay_ms(1000);


 AD1PCFGL = 0xFFFE;
 AD1CON1 = 4;


 AD1CHS0 = 0x0000;
 AD1CSSL = 0;
 AD1CON3 = 0x1003;
 AD1CON2 = 0;
 AD1CON1.F15 = 1;




 while(1) {


 Delay_ms(500);
 SAMP_bit = 0;
 while (DONE_bit)
 asm nop;
 conversion=5.*ADC1BUF0/1024.;
 FloatToStr(conversion, texto);

 Lcd_Cmd(_LCD_CLEAR);
 UART_Write_Text(ADC1BUF0);
 Lcd_Out(1,1,ADC1BUF0);


 }

}
