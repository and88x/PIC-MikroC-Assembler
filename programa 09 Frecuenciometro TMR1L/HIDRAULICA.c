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

char txt1[15],*puntero;
long int  contador,distancia;
int  *puntero16;
bit  bandera,medida;
float frecuencia;
interrupt(){
  if(CCP1IF_bit){
//    CCP1M0_bit= ~CCP1M0_bit;
    CCP1IF_bit=0;     //Borra la interrupcion externa 0
    TMR1L=0X00;
    TMR1H=0X00;
    *(puntero)= CCPR1L;
    *(puntero+1)= CCPR1H;


    distancia=contador;
    contador=0;
 //   if(CCP1M0_bit)bandera=1;
      bandera=1;
  }
    if(TMR1IF_bit){
    TMR1IF_bit=0;     //Borra la interrupcion externa 0
    *(puntero16+1)=*(puntero16+1)+1;
  }
}

void main() {

    Lcd_init();
    Lcd_Cmd(_LCD_CLEAR);
    Lcd_Cmd(_LCD_CURSOR_OFF);

    Lcd_Out(1,1,"Hola.");


    GIE_bit=1;        //Habilitadas las interrupciones
    PEIE_bit=1;
    CCP1IE_bit=1;     //Habilitada la interrupcion externa 0
    TMR1IE_bit=1;     //Habilitada la interrupcion externa 0
    TRISC2_bit=1;
    TRISC7_bit=0;
    T1CON=0x01;       //Configuracion en 16 bits, escalad por 1 y encendido del timer 1
    CCP1CON=0b00000101;               //Configuración del CCP1   CCP1CON=0b00000101 cada flanco de subida ;
    puntero16=&contador;
    puntero=&contador;
    bandera=0;
    TMR1ON_bit=1;
        while(1){

          if(bandera){

          bandera=0;
          frecuencia=1000000./distancia;
          floatToStr(frecuencia, txt1);
          Lcd_Out(2,1,txt1); Lcd_out_cp("Hz     ");
          delay_ms(10);
        }
        else  {
          RC7_bit=~RC7_bit;
          delay_us(10);
        }


        }
  }