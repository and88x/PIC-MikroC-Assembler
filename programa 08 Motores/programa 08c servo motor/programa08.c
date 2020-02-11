/*Cabecera******************************************************/

// Definir las variables ciclo_de_trabajo_actual,
// ciclo_de trabajo_anterior


char txt[6];
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

unsigned contador,tiempo;          // Definir la variable cnt

void interrupt() {
  if(RC0_bit)RC0_bit=0;
  else RC0_bit=1;
  contador++;               // Con una interrupción la cnt se incrementa en 1
  if(contador<tiempo)RC2_bit=1;
  else RC2_bit=0;
  if(contador==100)contador=0;

  TMR0 = 0xa0;           // El valor inicial se devuelve en el temporizador TMR0
  INTCON = 0b00100000;       // Bit T0IE se pone a 1, el bit T0IF se pone a 0

}

void initMain() {
  TRISC=0X00;
  PORTC=0X00;
  PORTB = 0xff;     // Estado inicial del puerto PORTB
  TRISB = 0xff;     // Todos los pines del puerto PORTB se configuran como entradas

  NOT_RBPU_bit=0;      //Resistencias de pull up activadas

  Lcd_Init();

}

void main() {
  TMR0 = 0xa0;           // Temporizador T0 cuenta de 10 veces
  PWM1_Init(100);
  INTEDG_bit=0;
  T0CS_bit=0;  //Reloj interno
  T0SE_bit=0;   //Transicion que en realidad no importa
  PSA_bit=0;   //Asigna el presescalador al timer 0
  PS0_bit=0;   //
  PS1_bit=0;   // Preescalador 1:2(1MHz)
  PS2_bit=0;   //
  INTCON = 0b10100000;       // Habilitada interrupción TMR0

  contador = 0;             // A la variable cnt se le asigna un 0
  tiempo=5;
  initMain();
  Lcd_Cmd(_LCD_CURSOR_OFF);      // Comando LCD (apagar el cursor)
  Lcd_Cmd(_LCD_CLEAR);           // Comando LCD (borrar el LCD)                  // Iniciar el módulo PWM1
  Lcd_Out(1,1,"Servomotor:");
  while (1) {                      // Bucle infinito
    if (Button(&PORTB, 6,1,0))     // Si se presiona el botón conectado al RB6
    tiempo++ ;    // incrementar el valor de la variable current_duty
    if (Button(&PORTB, 7,1,0))     // Si se presiona el botón conectado al RB7
    tiempo-- ;    // decrementar el valor de la variable current_duty
    if(tiempo>25)tiempo=25;
    if(tiempo<5)tiempo=5;
    WordToStr(tiempo, txt);  //
    Lcd_Out(2,1,"duty:");
    Lcd_Out(2,7,txt);
    Lcd_Chr_CP("us");
    Delay_ms(50); // Tiempo de retardo de 50mS
  }
}