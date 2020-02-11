// LCD module connections
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
// End LCD module connections

char txt1[] = "mikroElektronika";
char txt2[] = "EasydsPIC4A";
char txt3[] = "Lcd4bit";
char txt4[] = "example";

char i,uart_rd;                              // Loop variable
char *texto;
float conversion;
void Move_Delay() {                  // Function used for text moving
  Delay_ms(500);                     // You can change the moving speed here
}

void main(){
  RPINR18=0xFF07;
  RPOR3=0x0003;
  ADPCFG = 0xFFFF;                   // Configure AN pins as digital I/O

  Lcd_Init();                        // Initialize LCD

  Lcd_Cmd(_LCD_CLEAR);               // Clear display
  Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
  Lcd_Out(1,6,txt3);                 // Write text in first row

  Lcd_Out(2,6,txt4);                 // Write text in second row
  Delay_ms(2000);
  Lcd_Cmd(_LCD_CLEAR);               // Clear display

  Lcd_Out(1,1,txt1);                 // Write text in first row
  Lcd_Out(2,5,txt2);                 // Write text in second row
  UART1_Init(9600);               // Initialize UART module at 9600 bps
  Delay_ms(2000);
  ADC1_Init_Advanced(_ADC_10bit, _ADC_INTERNAL_REF);


  while(1) {                         // Endless loop
   if (UART_Data_Ready()) {     // If data is received,
      uart_rd = UART_Read();     // read the received data,
      UART_Write(uart_rd);       // and send data via UART
      conversion=5.*ADC1_Read(0)/1024.;
      FloatToStr(conversion, texto);
      Lcd_Cmd(_LCD_CLEAR);
      UART_Write_Text(texto);
      Lcd_Out(1,1,texto);
    }




  }

}