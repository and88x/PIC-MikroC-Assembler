/*
Cuenta cada d�cimo pulso e incrementa el valor del puerto B.  En este ejmeplo el timer1  es usado para contar
pulsos de un reloj externo en el pin T1CK. Despu�s de los 10 pulsos la interrupci�n Timer1Int y el valor del puerto B es complementado.

*/
void Timer1Int() org 0x1A{ // Direccion del Timer1 en la tabla de vectores de interrupci�n
LATB = ~LATB; // Inversi�n del PORTB
IFS0 = IFS0 & 0xFFF7; // Borrado de la bandera de Interrupci�n
}
void main(){
TRISB = 0x0000; // PORTB como salida
TRISA = 0x0010; // El pin PORTA<4>=1 T1CK es entrada
LATB = 0x0000; // Valor inicial para el puerto B
IPC0 = IPC0 | 0x1000; // Nivel de prioridad como 1
IEC0 = IEC0 | 0x0008; /// Interrupci�n del Timer1 habilitado
PR1 = 10; // Per�odo de la interrupci�n es de 10 ciclos
T1CON = 0x8006; // Timer1 ie un contador s�ncrono de pulsos externos
while(1) asm nop; // Bucle infinito
}
/*

�C�mo se hace para configurar el timer1 en el modo 16 bites sincr�nico? 
Prescalaoer en proporci�n 1:1,
habilitar el reloj externo TCS=1,
y habilitar la operaci�n del timer1 TON=1 (T1CON = 0x8006;). 
Poniendo el bit TRISB <4> =1 el pin PORTA <4> =1 es configurado como entrada.

*/