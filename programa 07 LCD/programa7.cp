#line 1 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/programa 07/programa7.c"

sbit LCD_RS at RD0_bit;
sbit LCD_EN at RD1_bit;
sbit LCD_D4 at RD4_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D7 at RD7_bit;

sbit LCD_RS_Direction at TRISD0_bit;
sbit LCD_EN_Direction at TRISD1_bit;
sbit LCD_D4_Direction at TRISD4_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D7_Direction at TRISD7_bit;






unsigned char ch;
unsigned int adc_rd;
char *text;
long tlong;
float conversion;

void main() {
 INTCON = 0;

 Lcd_Init();
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Cmd(_LCD_CLEAR);

 text = "mikroElektronika";
 Lcd_Out(1,1,text);

 text = "LCD ejemplo";
 Lcd_Out(2,1,text);


 ADCON0=0xC0;
 ADCON1=0b10000000;
 TRISA = 0xFF;
 Delay_ms(2000);


 Lcd_Out(2,1,"voltage:");
 Lcd_Cmd(_LCD_CLEAR);
 while (1) {
 adc_rd = ADC_Read(0);
 Lcd_Out(1,1,"Volt=");
 conversion=adc_rd*5./1023;
 FloatToStr(conversion, text);
 Lcd_out_CP(text);
 Lcd_Out(2,3,"(Voltios)");
 Delay_ms(1);
 }
}
