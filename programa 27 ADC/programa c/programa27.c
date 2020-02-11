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
  Delay_ms(1000);


  AD1PCFGL = 0xFFFE;        //1th channel is sampled and coverted
  AD1CON1 = 0x0040;        //ADC off, output_format=INTEGER
                          //Timer 3 starts convesion
                            //Manual start of sampling
  AD1CHS0  = 0x0000;          //
  AD1CSSL = 0;               //No scan
  AD1CON3 = 0x0F00;        //TAD = internalTCY
                          //Sample time ends with timer 3 clock






  /*TIMER3 init*/
  TMR3   = 0;             //Reset TIMER3 counter
  PR3    = 0x3FFF;        //PR3, number of TIMER3 clocks between two conversions start
  T3CON  = 0x8010;        //TIMER3 ON, prescale 1:1

  AD1CON1.F15 = 1;         //ADC on
  AD1CON1.F2  = 1;         //ASAM=1, start sampling after conversion ends

  
  
  


  while(1) {                         // Endless loop



    SAMP_bit = 1;                  //SAMP=1, start sampling

    while (DONE_bit)
    asm nop;                         //Wait for DONE bit in ADCON1
    conversion=ADC1BUF0;
    FloatToStr(conversion, texto);

    Lcd_Cmd(_LCD_CLEAR);
    UART_Write(ADC1BUF0);
    Lcd_chr(1,1,ADC1BUF0);
    Lcd_Out(2,1,texto);

  }

}