

void interrupt_int0() iv IVT_ADDR_INT0INTERRUPT ics ICS_AUTO {
   LATA++;
  INT0IF_bit = 0;                // bandera de interrupción borrada
}

void interrupt_int1() iv IVT_ADDR_INT1INTERRUPT ics ICS_AUTO {
   LATA--;
  INT1IF_bit = 0;                // bandera de interrupción borrada
}



void main(){
  TRISA = 0;      //porta como salidas
  TRISB = 0xFFFF; //portb como entradas
  AD1PCFGL=0XFFFF;//Todas las entradadas son digitales
  IPC5BITS.INT1IP=7; //La prioridad de la interrupcion INT1 es 7, la mas alta
  RPINR0BITS.INT1R=0;//La ubicación de la entrada de la INT1 es RP0
  INT0IE_bit = 1;
  INT1IE_bit = 1;
  INT0IF_bit = 0;
  INT1IF_bit = 0;
  
  
  while(1) asm nop;
}