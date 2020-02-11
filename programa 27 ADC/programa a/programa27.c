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
char txt[10];

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
//  ADC1_Init_Advanced(_ADC_10bit, _ADC_INTERNAL_REF);

  AD1PCFGL = 0xFFFE;        //1th channel is sampled and coverted
  AD1CON1 = 0;              //ADC off, output_format=INTEGER
                            //Manual start of convesion
                            //Manual start of sampling
  AD1CHS0  = 0x0000;          //
  AD1CSSL = 0;               //No scan
  AD1CON3 = 0x1003;          //ADCS=3 (min TAD for 10MHz is 3*TCY=300ns)
  AD1CON2 = 0;               //Interrupt upon completion of one sample/convert
  AD1CON1.F15 = 1;           //ADC on


  while(1) {                         // Endless loop

    AD1CON1.F1 = 1;                  //Start sampling (SAMP=1)
    Delay_ms(100);                   //Wait for 100ms (sampling ...)
    AD1CON1.F1 = 0;                  //Clear SAMP bit (trigger conversion)
    while (AD1CON1.F0 == 0)
    asm nop;                         //Wait for DONE bit in ADCON1
    conversion=5.*ADC1BUF0/1024.;
    FloatToStr(conversion, txt);

    Lcd_Cmd(_LCD_CLEAR);
    UART_Write_Text(txt);
    Lcd_Out(1,1,txt);


  }

}