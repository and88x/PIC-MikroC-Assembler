void Timer23Int() org 0x22{ //Direcci�n en ele vector de interrupci�n para el timer 3
  LATB++;                   //Incrementa el valor del PORTB
  IFS0 = 0;                 // Borra la badera de interrupci�n
}

void main(){
  TRISB = 0;             //PORTB  como salida
  TRISA = 0x10;          // El pin PORTA<4>=1 T1CK es entrada
  LATB  = 0;             //Inicializacion del valor del PORTB
  IPC1  = IPC1 | 0x1000; //Prioridad de la Interrupci�n del timer3 es 1
  IEC0  = IEC0 | 0x0080; //Habilitaci�n de la Interrupci�n  del timer3
  PR2   = 10;            //EL per�odo de interrupcion es es 10 ciclos
  PR3   = 0;             //Total PR3/2=0*65536 + 10
  T2CON = 0x800A;        //Timer2/3 es configurado coo contador sincrono de pulsos externos
  while(1) asm nop;      //
}