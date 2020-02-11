#line 1 "C:/Users/Usuario/Dropbox/materias/microprocesadores 2/programas/programa 26 Temporizadores/timer 2 y timer 3/programa26f.c"
void Timer23Int() org 0x22{
 LATB++;
 IFS0 = 0;
}

void main(){
 TRISB = 0;
 TRISA = 0x10;
 LATB = 0;
 IPC1 = IPC1 | 0x1000;
 IEC0 = IEC0 | 0x0080;
 PR2 = 10;
 PR3 = 0;
 T2CON = 0x800A;
 while(1) asm nop;
}
