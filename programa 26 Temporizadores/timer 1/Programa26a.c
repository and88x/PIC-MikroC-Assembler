/*
Enciende y apaga LEDs conecatos al puerto B aproximadamente 4 veces por segundo. Este ejemplo usa el módulo temporizador 1
con un reloj 256 veces mas lento que el relog del dsPIC. Cada 10 000 pulsaciones el modulo timer1 llama a un rutina
de interrupción Timer1Int y cambia el valor del puerto B
*/
void Timer1Int() org 0x1A{// Direccion del Timer1 en la tabla de vectores de interrupciòn
LATB = ~LATB; // Inversión del PORTB
IFS0 = IFS0 & 0xFFF7; // Borrado de la bandera de Interrupción
}
void main(){
//ODCB=0x0000;
TRISB = 0; // PORTB como salida
LATB = 0xAAAA; // Valor inicial para el puerto B
IPC0 = IPC0 | 0x1000; // Nivel de prioridad como 1
IEC0 = IEC0 | 0x0008; // Interrupción del Timer1 habilitado
PR1 = 5000; // Período de la interrupción es de 10000 ciclos
T1CON = 0x8030; // Timer1 habilitado(reloj interno divido para 256)
while(1) asm nop; // Bucle infinito
}

/*
¿Cómo calcular el período de interrumpción? El reloj interno está seteado a 10MHz. 
El período es 100ns.Ya que el reloj es dividido por 256 (el prescalador reduce el reloj 1:256) para formar el reloj de temporizador,
entonces el reloj de temporizador es 100*256=25600nsque es 25.6 µs. Cada 10000 pulsaciones una interrupciónes requerida,
esto es cada 256ms o aproximadamente 4 veces por segundo.
*/