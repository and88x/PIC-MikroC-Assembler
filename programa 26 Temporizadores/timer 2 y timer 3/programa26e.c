/*
Conecta y desconecra diodos CONECTADOS en el puerto la b aproximadamente una vez cada dos segundos.
l ejemplo usa timer2 encadenado y AL TIMER 3 que tienen un conteo 256 veces más despacio que él del dispositivo dsPIC.
En cada 100000 veces de la acticacion de la interrupción de timer1  llaman la rutina Timer23Int y el valor en el puerto la B es cambiado

*/


void Timer23Int() org 0x24{ // Dirección en el vector de interrupciones para el timer 3
  LATB = ~LATB;            // Invierte el puerto B
  IFS0 = 0;                 // Borra la petición de interrupción
}

void main(){
  TRISB = 0x0000;                // Port B es salida
  LATB  = 0xAAAA;           // Valor inicial para el puerto B
  IPC1  = IPC1 | 0x1000;    // Prioridad del Timer3 es 1
  T3IE_bit = 1;
  IEC0  = IEC0 | 0x0080;    // Habilitación de interrupción del Timer3
  PR2   = 34464;            // Período de interrupción es 100 000 ciclos
  PR3   = 0x0001;           // Total PR3/2=1*65536 + 34464
  T2CON = 0x8038;           // Timer2/3 es habilitado, reloj interno es  dividido para 256
  while(1) asm nop;         // Bucle sin fin
}

/*
¿Cómo se hace para poner módulo timer2/3 en el modo de temporizador 32 bits?
Los bits de interrupciòn correspondientes, prioridad T3IPC=1, bit de petición de interrupciòn T3IF=0, y el bit de habilitación de interrupcion T3IE=1
son puestos primero (en el módulo encadenado timer2/3 la interrupción es controlada por los bits de control del módulo timer3
y la operación del módulo timer2/3 es controlada por los bits de control del módulo timer2). 
Entonces la operación del temporizador es activada TON=1, la operación 32 bites es seleccionado T32=1, 
y en este caso el prescalador es configurado para 1:256 la proporción TCKPS <1:0> =11. 
El registro de periodo PR2/3 contiene el valor 100000 distribuido según la fórmula PR3/2=PR3*65536 + PR2, PR3=1 y PR2=34464.

¿Cómo se hace el calculo del período de llamadas de interrupción? Dejando al reloj interno(interior) ajustado a 10MHz. 
El período correspondiente es 100ns. Ya que el reloj es dividido por 256 (el prescaler reduce el reloj 1:256) para formar el reloj del temporizador,
se sigue que 100ns*256 = 25600ns, que es 25.6 µs. En cada 100000 pulsaciones una interrupción es llamada, es decir en cada 2.56s o aproximadamente una vez cada dos segundos.
T = 100 000*25.6 µ s = 2.56s.

*/