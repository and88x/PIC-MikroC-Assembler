#line 1 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/programa 24 interrupciones DSPIC/programa24.c"


void interrupt_int0() iv IVT_ADDR_INT0INTERRUPT ics ICS_AUTO {
 LATA++;
 INT0IF_bit = 0;
}

void interrupt_int1() iv IVT_ADDR_INT1INTERRUPT ics ICS_AUTO {
 LATA--;
 INT1IF_bit = 0;
}



void main(){
 TRISA = 0;
 TRISB = 0xFFFF;
 AD1PCFGL=0XFFFF;
 IPC5BITS.INT1IP=7;
 RPINR0BITS.INT1R=0;
 INT0IE_bit = 1;
 INT1IE_bit = 1;
 INT0IF_bit = 0;
 INT1IF_bit = 0;


 while(1) asm nop;
}
