// LCD module connections
sbit LCD_RS at RB0_bit;
sbit LCD_EN at RB1_bit;
sbit LCD_D4 at RB4_bit;
sbit LCD_D5 at RB5_bit;
sbit LCD_D6 at RB6_bit;
sbit LCD_D7 at RB7_bit;

sbit LCD_RS_Direction at TRISB0_bit;
sbit LCD_EN_Direction at TRISB1_bit;
sbit LCD_D4_Direction at TRISB4_bit;
sbit LCD_D5_Direction at TRISB5_bit;
sbit LCD_D6_Direction at TRISB6_bit;
sbit LCD_D7_Direction at TRISB7_bit;
// End LCD module connections

char *text;
int contador;
int distancia;
const int inicioTimer = 0x7265;
//const int inicioTimer = 0x8eb7;

void interrupt() {
     if (TMR1IF_bit) {
        TMR1IF_bit=0;
        TMR1L = 0x65;
        TMR1H = 0x72;
        //TMR1L = 0xb7;
        //TMR1H = 0x8e;
     }
}


void main() {
//Configuración del timer 1
T1CON = 0b00001000;     //1:1 preescaler, oscilador interno
GIE_bit = 1;
PEIE_bit = 1;
PIE1.TMR1IE = 1;
TMR1L = 0x65;
TMR1H = 0x72;
//TMR1L = 0xb7;
//TMR1H = 0x8e;

//Configuración del puerto c
TRISB6_bit = 0;
RB6_bit = 0;
RB7_bit = 0;
TRISB7_bit = 1;
TRISB5_bit = 0;
RB5_bit = 0;
TRISB4_bit = 0;
RB4_bit = 0;
//TRISB = 0;
//PORTB = 0;

Lcd_Init();                    // Inicialización del visualizador LCD
Lcd_Cmd(_LCD_CURSOR_OFF);      // Comando LCD (apagar el cursor)
Lcd_Cmd(_LCD_CLEAR);           // Comando LCD (borrar el LCD)

text = "Distancia =";
Lcd_Out(1,2,text);
delay_ms(10);

while (1) {
   RB6_bit = 1;
   delay_us(15);
   RB6_bit = 0;   //generado un pulso de 10 us
   TMR1ON_bit = 1;
   while (!RB7_bit){
   }
   //RB5_bit = 1;
   while (RB7_bit && !TMR1IF){
   }
   TMR1ON_bit = 0;
   RB4_bit = 1;
   contador = TMR1H;
   contador = contador << 8;
   contador += TMR1L;
   distancia = (contador-inicioTimer)*2/145;
   //distancia = (contador-inicioTimer)*2/29;
   //IntToStr(distancia,text);
   //Lcd_Out(2,1,text);
   //delay_ms(10);
   if (distancia <= 15 ){//&& distancia <= 100){
      RB5_bit = 1;
   } /*else if (distancia > 15 ) {
      RB7_bit = 0;
   }*/
}
}