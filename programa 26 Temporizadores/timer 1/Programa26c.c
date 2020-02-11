/*
Cuenta cada 800 pulsos e incrementa el valor del puerto B. En este ejemplo el timer1 es usado para contar cada octavo
pulso de un reloj externo en el pin T1CK. Después de 100 pulsos la rutina de interrupción Timer1Int es llamada
y el valor del puerto B es incrementado.

*/

void Timer1Int() org 0x1A{ // Direccion del Timer1 en la tabla de vectores de interrupciòn
LATB++; // Valor del PORTB es incrementado
IFS0 = IFS0 & 0xFFF7; // Borrado de la bandera de Interrupción
}
void main(){
TRISB = 0x0000; // PORTB como salida
TRISA = 0x0010; // El pin PORTA<4>=1 T1CK es entrada
LATB = 0x0000; // Valor inicial para el puerto B
IPC0 = IPC0 | 0x1000; // Nivel de prioridad como 1
IEC0 = IEC0 | 0x0008; // Interrupción del Timer1 habilitado
PR1 = 100; // Período de la interrupción es de 100 ciclos
T1CON = 0x8012; // Timer1 es un contador sincrono de pulsos externos
while(1) asm nop; // Bucle infinito
}