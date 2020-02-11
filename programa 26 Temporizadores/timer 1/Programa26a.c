/*
Enciende y apaga LEDs conecatos al puerto B aproximadamente 4 veces por segundo. Este ejemplo usa el m�dulo temporizador 1
con un reloj 256 veces mas lento que el relog del dsPIC. Cada 10 000 pulsaciones el modulo timer1 llama a un rutina
de interrupci�n Timer1Int y cambia el valor del puerto B
*/
void Timer1Int() org 0x1A{// Direccion del Timer1 en la tabla de vectores de interrupci�n
LATB = ~LATB; // Inversi�n del PORTB
IFS0 = IFS0 & 0xFFF7; // Borrado de la bandera de Interrupci�n
}
void main(){
//ODCB=0x0000;
TRISB = 0; // PORTB como salida
LATB = 0xAAAA; // Valor inicial para el puerto B
IPC0 = IPC0 | 0x1000; // Nivel de prioridad como 1
IEC0 = IEC0 | 0x0008; // Interrupci�n del Timer1 habilitado
PR1 = 5000; // Per�odo de la interrupci�n es de 10000 ciclos
T1CON = 0x8030; // Timer1 habilitado(reloj interno divido para 256)
while(1) asm nop; // Bucle infinito
}

/*
�C�mo calcular el per�odo de interrumpci�n? El reloj interno est� seteado a 10MHz. 
El per�odo es 100ns.Ya que el reloj es dividido por 256 (el prescalador reduce el reloj 1:256) para formar el reloj de temporizador,
entonces el reloj de temporizador es 100*256=25600nsque es 25.6 �s. Cada 10000 pulsaciones una interrupci�nes requerida,
esto es cada 256ms o aproximadamente 4 veces por segundo.
*/