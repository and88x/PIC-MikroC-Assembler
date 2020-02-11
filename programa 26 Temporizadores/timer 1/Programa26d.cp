#line 1 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/programa 26 Temporizadores/timer 1/Programa26d.c"
#line 12 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/programa 26 Temporizadores/timer 1/Programa26d.c"
void Timer1Int() org 0x1A{
LATB = TMR1;
TMR1=0;
IFS0 = IFS0 & 0xFFF7;
}
main(){
TRISB = 0x0000;
TRISA = 0x0010;
LATB = 0x0000;
IPC0 = IPC0 | 0x1000;
IEC0 = IEC0 | 0x0008;
TMR1=0;
PR1 = 0xFFFF;
T1CON = 0x8040;
while (1) asm nop;
}
