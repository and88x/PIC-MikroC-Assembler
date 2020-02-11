sbit BOBINA_A at RB1_bit;
sbit BOBINA_B at RB3_bit;
sbit BOBINA_C at RB5_bit;
sbit BOBINA_D at RB7_bit;

// LCD module connections
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
// End LCD module connections

int retardo,auxiliar;
char txt[6];

void espera(void);


void main() {
 TRISB=0X00;
 PORTB=0X00;
 TRISC=0XFF;
 PORTC=0X00;
 retardo=50;
 Lcd_Init();                    // Inicialización del visualizador LCD
 Lcd_Cmd(_LCD_CURSOR_OFF);      // Comando LCD (apagar el cursor)
 Lcd_Cmd(_LCD_CLEAR);           // Comando LCD (borrar el LCD)
 Lcd_Out(1,1,"Motor a Pasos:");
 while(1){
   if (Button(&PORTC, 0, 50, 1)) retardo++;
   if (Button(&PORTC, 1, 50, 1)) retardo--;

   WordToStr(retardo, txt);  //
   Lcd_Out(2,1,"retardo:");
   Lcd_Out(2,9,txt);
   BOBINA_A=1;BOBINA_B=0;BOBINA_C=0;BOBINA_D=0;
   espera();
   BOBINA_A=0;BOBINA_B=1;BOBINA_C=0;BOBINA_D=0;
   espera();
   BOBINA_A=0;BOBINA_B=0;BOBINA_C=1;BOBINA_D=0;
   espera();
   BOBINA_A=0;BOBINA_B=0;BOBINA_C=0;BOBINA_D=1;
   espera();
   BOBINA_A=1;BOBINA_B=0;BOBINA_C=0;BOBINA_D=0;
   espera();
   BOBINA_A=0;BOBINA_B=1;BOBINA_C=0;BOBINA_D=0;
   espera();
   BOBINA_A=0;BOBINA_B=0;BOBINA_C=1;BOBINA_D=0;
   espera();
   BOBINA_A=0;BOBINA_B=0;BOBINA_C=0;BOBINA_D=1;
   espera();
   BOBINA_A=1;BOBINA_B=0;BOBINA_C=0;BOBINA_D=0;
   espera();
   BOBINA_A=0;BOBINA_B=1;BOBINA_C=0;BOBINA_D=0;
   espera();
   BOBINA_A=0;BOBINA_B=0;BOBINA_C=1;BOBINA_D=0;
   espera();
   BOBINA_A=0;BOBINA_B=0;BOBINA_C=0;BOBINA_D=1;
   espera();

   BOBINA_A=0;BOBINA_B=0;BOBINA_C=0;BOBINA_D=1;
   espera();
   BOBINA_A=0;BOBINA_B=0;BOBINA_C=1;BOBINA_D=0;
   espera();
   BOBINA_A=0;BOBINA_B=1;BOBINA_C=0;BOBINA_D=0;
   espera();
   BOBINA_A=1;BOBINA_B=0;BOBINA_C=0;BOBINA_D=0;
   espera();
   
   BOBINA_A=0;BOBINA_B=0;BOBINA_C=0;BOBINA_D=1;
   espera();
   BOBINA_A=0;BOBINA_B=0;BOBINA_C=1;BOBINA_D=0;
   espera();
   BOBINA_A=0;BOBINA_B=1;BOBINA_C=0;BOBINA_D=0;
   espera();
   BOBINA_A=1;BOBINA_B=0;BOBINA_C=0;BOBINA_D=0;
   espera();

   BOBINA_A=0;BOBINA_B=0;BOBINA_C=0;BOBINA_D=1;
   espera();
   BOBINA_A=0;BOBINA_B=0;BOBINA_C=1;BOBINA_D=0;
   espera();
   BOBINA_A=0;BOBINA_B=1;BOBINA_C=0;BOBINA_D=0;
   espera();
   BOBINA_A=1;BOBINA_B=0;BOBINA_C=0;BOBINA_D=0;
   espera();

 
 }
}


void espera(){
    auxiliar=retardo;
    while(auxiliar!=0){
       auxiliar--;
       delay_ms(1);
    }
    }