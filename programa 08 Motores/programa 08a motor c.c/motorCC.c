/*Cabecera******************************************************/

// Definir las variables ciclo_de_trabajo_actual,
// ciclo_de trabajo_anterior

unsigned short ciclo_de_trabajo_actual;
unsigned short ciclo_de_trabajo_anterior;
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


void initMain(void);


void main() {
  initMain();
  ciclo_de_trabajo_actual = 16;    // Valor inicial de la variable ciclo_de_trabajo_actual
  ciclo_de_trabajo_anterior = 0;   // Reiniciar la variable ciclo_de trabajo_anterior
  PWM1_Start();
  Lcd_Cmd(_LCD_CURSOR_OFF);      // Comando LCD (apagar el cursor)
  Lcd_Cmd(_LCD_CLEAR);           // Comando LCD (borrar el LCD)                  // Iniciar el módulo PWM1
  Lcd_Out(1,1,"Motor C.C.:");
  while (1) {                      // Bucle infinito
    if (Button(&PORTB, 6,1,0))     // Si se presiona el botón conectado al RB6
    ciclo_de_trabajo_actual++ ;    // incrementar el valor de la variable current_duty
    if (Button(&PORTB, 7,1,0))     // Si se presiona el botón conectado al RB7
    ciclo_de_trabajo_actual-- ;    // decrementar el valor de la variable current_duty

    if (ciclo_de_trabajo_anterior != ciclo_de_trabajo_actual) {             // Si ciclo_de_trabajo_actual y
      // ciclo_de trabajo_anterior no son iguales
      PWM1_Set_Duty(ciclo_de_trabajo_actual);              // ajustar un nuevo valor a PWM,
      ciclo_de_trabajo_anterior = ciclo_de_trabajo_actual; // Guardar el nuevo valor
    WordToStr(ciclo_de_trabajo_anterior, txt);  //
    Lcd_Out(2,1,"duty_c:");
    Lcd_Out(2,9,txt);
    }
    Delay_ms(50); // Tiempo de retardo de 50mS
  }
}
void initMain() {
  TRISC = 0X00;
  PORTB = 0xff;     // Estado inicial del puerto PORTB
  TRISB = 0xff;     // Todos los pines del puerto PORTB se configuran como entradas
  PORTD = 0x00;     // Estado inicial del puerto PORTB
  TRISD = 0x00;     // Todos los pines del puerto PORTB se configuran como entradas
  NOT_RBPU_bit=0;      //Resistencias de pull up activadas

  Lcd_Init();
  PWM1_Init(500); // Inicialización del módulo PWM (500Hz)
}