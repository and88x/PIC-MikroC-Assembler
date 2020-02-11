/*

Use timer1 in the gated time accumulation mode.The enable GATE signal is applied to the pin T1CK. Measure
the width of the signal and display the result at port B.



*/



void Timer1Int() org 0x1A{// Direccion del Timer1 en la tabla de vectores de interrupci�n
LATB = TMR1; // La duraci�n del Pulso es desplegado en el puerto B
TMR1=0;
IFS0 = IFS0 & 0xFFF7; // Borrado de la bandera de Interrupci�n
}
main(){
TRISB = 0x0000; // PORTB como salida
TRISA = 0x0010; // El pin PORTA<4>=1 T1CK es entrada
LATB = 0x0000; // Valor inicial para el puerto B
IPC0 = IPC0 | 0x1000; // Nivel de prioridad como 1
IEC0 = IEC0 | 0x0008; // Interrupci�n del Timer1 habilitado
TMR1=0;
PR1 = 0xFFFF; // Periodo es el m�ximo
T1CON = 0x8040; // Timer1 est� habilitado, reloj interno est� bajo T1CK=1
while (1) asm nop; // Bucle infinito
}

/*
�Por qu� el registro PR1 es puesto al valor m�ximo?
La raz�n principal es permitir que los intervalos de tiempo de la medida sea tan larga como sea posible ,
implica que la interrumpci�n no vienen como una consecuencia de igualaci�n del TMR1 y registros de PR1,
pero, de ser posible, como una consecuencia del flanc de bajada de la se�al de GATE.

*/