#line 1 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/programa 26 Temporizadores/timer 2 y timer 3/programa26e.c"
#line 9 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/programa 26 Temporizadores/timer 2 y timer 3/programa26e.c"
void Timer23Int() org 0x24{
 LATB = ~LATB;
 IFS0 = 0;
}

void main(){
 TRISB = 0x0000;
 LATB = 0xAAAA;
 IPC1 = IPC1 | 0x1000;
 T3IE_bit = 1;
 IEC0 = IEC0 | 0x0080;
 PR2 = 34464;
 PR3 = 0x0001;
 T2CON = 0x8038;
 while(1) asm nop;
}
