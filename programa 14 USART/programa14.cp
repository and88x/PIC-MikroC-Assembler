#line 1 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/programa 14/programa14.c"


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

char i;
char *text;

void main() {
 UART1_Init(9600);


 Lcd_Init();
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_out(1,1,"hola");
 while (1) {

 if (UART1_Data_Ready()) {
 i = UART1_Read();
 switch (i) {
 case 1 : Lcd_Cmd(_LCD_FIRST_ROW);
 break;
 case 2 :Lcd_Cmd(_LCD_SECOND_ROW);
 break;
 case 3 :Lcd_Cmd(_LCD_THIRD_ROW);
 break;
 case 4 :Lcd_Cmd(_LCD_FOURTH_ROW);
 break;
 case 5 :Lcd_Cmd(_LCD_CLEAR);
 break;
 case 6 :Lcd_Cmd(_LCD_RETURN_HOME);
 break;
 case 7 :Lcd_Cmd(_LCD_CURSOR_OFF);
 break;
 case 8 :Lcd_Cmd(_LCD_UNDERLINE_ON);
 break;
 case 9 :Lcd_Cmd(_LCD_BLINK_CURSOR_ON);
 break;
 case 10 :Lcd_Cmd(_LCD_MOVE_CURSOR_LEFT);
 break;
 case 11 :Lcd_Cmd(_LCD_MOVE_CURSOR_RIGHT);
 break;
 case 12 :Lcd_Cmd(_LCD_TURN_ON);
 break;
 case 13 :Lcd_Cmd(_LCD_TURN_OFF);
 break;
 case 14 :Lcd_Cmd(_LCD_SHIFT_LEFT);
 break;
 case 15 :Lcd_Cmd(_LCD_SHIFT_RIGHT);
 break;

 default : Lcd_chr_Cp(i);
 UART1_Write(i);
}




 }
 }
}
