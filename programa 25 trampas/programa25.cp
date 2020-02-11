#line 1 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/programa 25 trampas/programa25.c"
int valor;

void IntDet() org 0x0014{
 LATA--;
 IFS0.F0 = 0;
}

void TrapTrap() org 0x000C{
 INTCON1.F4 = 0;
#line 12 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/programa 25 trampas/programa25.c"
 LATA = 5;
 LATB++;
}

void main(){
 TRISB = 0x0080;
 TRISA = 0x0;
 LATB=0X0;
 LATA = 0x05;
 IFS0 = 0;
 INTCON1 = 0;
 IEC0 = 1;
 while(1){
 valor = 256 / LATA;
 }
}
