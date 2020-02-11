/*Cabecera******************************************************/
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
char i;
char *text;

void main() {
  UART1_Init(9600); // Inicializar el módulo USART
  // (8 bits, tasa de baudios 9600, no hay bit
  // de paridad...)
  Lcd_Init();                    // Inicialización del visualizador LCD
  Lcd_Cmd(_LCD_CURSOR_OFF);      // Comando LCD (apagar el cursor)
  Lcd_Cmd(_LCD_CLEAR);           // Comando LCD (borrar el LCD)
  Lcd_out(1,1,"hola");
  while (1) {
// UART1_Write(060);
    if (UART1_Data_Ready()) { // si se ha recibido un dato
      i = UART1_Read(); // leerlo
      switch (i) {
             case 1 : Lcd_Cmd(_LCD_FIRST_ROW);// Move cursor to the 1st row
             break;
             case 2 :Lcd_Cmd(_LCD_SECOND_ROW);// Move cursor to the 2nd row
             break;
             case 3 :Lcd_Cmd(_LCD_THIRD_ROW);// Move cursor to the 3rd row
             break;
             case 4 :Lcd_Cmd(_LCD_FOURTH_ROW);// Move cursor to the 4th row
             break;
             case 5 :Lcd_Cmd(_LCD_CLEAR);// Clear display
             break;
             case 6 :Lcd_Cmd(_LCD_RETURN_HOME);// Return cursor to home position, returns a shifted display to its original position. Display data RAM is unaffected.
             break;
             case 7 :Lcd_Cmd(_LCD_CURSOR_OFF);// Turn off cursor
             break;
             case 8 :Lcd_Cmd(_LCD_UNDERLINE_ON);// Underline cursor on
             break;
             case 9 :Lcd_Cmd(_LCD_BLINK_CURSOR_ON);// Blink cursor on
             break;
             case 10 :Lcd_Cmd(_LCD_MOVE_CURSOR_LEFT);// Move cursor left without changing display data RAM
             break;
             case 11 :Lcd_Cmd(_LCD_MOVE_CURSOR_RIGHT);// Move cursor right without changing display data RAM
             break;
             case 12 :Lcd_Cmd(_LCD_TURN_ON);// Turn Lcd display on
             break;
             case 13 :Lcd_Cmd(_LCD_TURN_OFF);// Turn Lcd display off
             break;
             case 14 :Lcd_Cmd(_LCD_SHIFT_LEFT);// Shift display left without changing display data RAM
             break;
             case 15 :Lcd_Cmd(_LCD_SHIFT_RIGHT);// Shift display right without changing display data RAM
             break;

             default : Lcd_chr_Cp(i);
        UART1_Write(i); // enviarlo atrás
}




    }
  }
}