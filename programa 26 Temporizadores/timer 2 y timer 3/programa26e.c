/*
Conecta y desconecra diodos CONECTADOS en el puerto la b aproximadamente una vez cada dos segundos.
l ejemplo usa timer2 encadenado y AL TIMER 3 que tienen un conteo 256 veces m�s despacio que �l del dispositivo dsPIC.
En cada 100000 veces de la acticacion de la interrupci�n de timer1  llaman la rutina Timer23Int y el valor en el puerto la B es cambiado

*/


void Timer23Int() org 0x24{ // Direcci�n en el vector de interrupciones para el timer 3
  LATB = ~LATB;            // Invierte el puerto B
  IFS0 = 0;                 // Borra la petici�n de interrupci�n
}

void main(){
  TRISB = 0x0000;                // Port B es salida
  LATB  = 0xAAAA;           // Valor inicial para el puerto B
  IPC1  = IPC1 | 0x1000;    // Prioridad del Timer3 es 1
  T3IE_bit = 1;
  IEC0  = IEC0 | 0x0080;    // Habilitaci�n de interrupci�n del Timer3
  PR2   = 34464;            // Per�odo de interrupci�n es 100 000 ciclos
  PR3   = 0x0001;           // Total PR3/2=1*65536 + 34464
  T2CON = 0x8038;           // Timer2/3 es habilitado, reloj interno es  dividido para 256
  while(1) asm nop;         // Bucle sin fin
}

/*
�C�mo se hace para poner m�dulo timer2/3 en el modo de temporizador 32 bits?
Los bits de interrupci�n correspondientes, prioridad T3IPC=1, bit de petici�n de interrupci�n T3IF=0, y el bit de habilitaci�n de interrupcion T3IE=1
son puestos primero (en el m�dulo encadenado timer2/3 la interrupci�n es controlada por los bits de control del m�dulo timer3
y la operaci�n del m�dulo timer2/3 es controlada por los bits de control del m�dulo timer2). 
Entonces la operaci�n del temporizador es activada TON=1, la operaci�n 32 bites es seleccionado T32=1, 
y en este caso el prescalador es configurado para 1:256 la proporci�n TCKPS <1:0> =11. 
El registro de periodo PR2/3 contiene el valor 100000 distribuido seg�n la f�rmula PR3/2=PR3*65536 + PR2, PR3=1 y PR2=34464.

�C�mo se hace el calculo del per�odo de llamadas de interrupci�n? Dejando al reloj interno(interior) ajustado a 10MHz. 
El per�odo correspondiente es 100ns. Ya que el reloj es dividido por 256 (el prescaler reduce el reloj 1:256) para formar el reloj del temporizador,
se sigue que 100ns*256 = 25600ns, que es 25.6 �s. En cada 100000 pulsaciones una interrupci�n es llamada, es decir en cada 2.56s o aproximadamente una vez cada dos segundos.
T = 100 000*25.6 � s = 2.56s.

*/