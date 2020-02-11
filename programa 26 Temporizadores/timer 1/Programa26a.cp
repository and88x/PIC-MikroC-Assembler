#line 1 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/programa 26 Temporizadores/timer 1/Programa26a.c"
#line 6 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/programa 26 Temporizadores/timer 1/Programa26a.c"
void Timer1Int() org 0x1A{
LATB = ~LATB;
IFS0 = IFS0 & 0xFFF7;
}
void main(){

TRISB = 0;
LATB = 0xAAAA;
IPC0 = IPC0 | 0x1000;
IEC0 = IEC0 | 0x0008;
PR1 = 5000;
T1CON = 0x8030;
while(1) asm nop;
}
