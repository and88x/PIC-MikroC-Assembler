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




// Declarar variables
unsigned char ch;
unsigned int adc_rd;
char *text;
long tlong;
float conversion;

void main() {
  INTCON = 0;                    // Todas las interrupciones deshabilitadas

  Lcd_Init();                    // Inicialización del visualizador LCD
  Lcd_Cmd(_LCD_CURSOR_OFF);      // Comando LCD (apagar el cursor)
  Lcd_Cmd(_LCD_CLEAR);           // Comando LCD (borrar el LCD)

  text = "mikroElektronika";     // Definir el primer mensaje
  Lcd_Out(1,1,text);             // Escribir el primer mensaje en la primera línea

  text = "LCD ejemplo";          // Definir el segundo mensaje
  Lcd_Out(2,1,text);             // Definir el primer mensaje

  //Adc_INit();
  ADCON0=0xC0;                 //Solo interesa el reloj de conversión del ADC
  ADCON1=0b10000000;           //Justificacion derecha y todos los canales del puerto A analógicos y del puerto E digitales
  TRISA = 0xFF;                  // Todos los pines del puerto PORTA se configuran como entradas
  Delay_ms(2000);

               // Definir el tercer mensaje
  Lcd_Out(2,1,"voltage:");
   Lcd_Cmd(_LCD_CLEAR);           // Comando LCD (borrar el LCD)
  while (1) {
    adc_rd = ADC_Read(0);        // Conversión A/D. Pin RA2 es una entrada.
    Lcd_Out(1,1,"Volt=");
    conversion=adc_rd*5./1023;
    FloatToStr(conversion, text);
    Lcd_out_CP(text);
    Lcd_Out(2,3,"(Voltios)");
    Delay_ms(1);
  }
}