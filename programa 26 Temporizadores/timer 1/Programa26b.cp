#line 1 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/programa 26 Temporizadores/timer 1/Programa26b.c"
#line 6 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/programa 26 Temporizadores/timer 1/Programa26b.c"
void Timer1Int() org 0x1A{
LATB = ~LATB;
IFS0 = IFS0 & 0xFFF7;
}
void main(){
TRISB = 0x0000;
TRISA = 0x0010;
LATB = 0x0000;
IPC0 = IPC0 | 0x1000;
IEC0 = IEC0 | 0x0008;
PR1 = 10;
T1CON = 0x8006;
while(1) asm nop;
}
