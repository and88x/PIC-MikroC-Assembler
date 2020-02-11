#line 1 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/programa 08/programa 08a motor c.c/motorCC.c"





unsigned short ciclo_de_trabajo_actual;
unsigned short ciclo_de_trabajo_anterior;
char txt[6];

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



void initMain(void);


void main() {
 initMain();
 ciclo_de_trabajo_actual = 16;
 ciclo_de_trabajo_anterior = 0;
 PWM1_Start();
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"Motor C.C.:");
 while (1) {
 if (Button(&PORTB, 6,1,0))
 ciclo_de_trabajo_actual++ ;
 if (Button(&PORTB, 7,1,0))
 ciclo_de_trabajo_actual-- ;

 if (ciclo_de_trabajo_anterior != ciclo_de_trabajo_actual) {

 PWM1_Set_Duty(ciclo_de_trabajo_actual);
 ciclo_de_trabajo_anterior = ciclo_de_trabajo_actual;
 WordToStr(ciclo_de_trabajo_anterior, txt);
 Lcd_Out(2,1,"duty_c:");
 Lcd_Out(2,9,txt);
 }
 Delay_ms(50);
 }
}
void initMain() {
 TRISC = 0X00;
 PORTB = 0xff;
 TRISB = 0xff;
 PORTD = 0x00;
 TRISD = 0x00;
 NOT_RBPU_bit=0;

 Lcd_Init();
 PWM1_Init(500);
}
