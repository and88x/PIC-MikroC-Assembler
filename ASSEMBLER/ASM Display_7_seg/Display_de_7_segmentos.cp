#line 1 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/Mi_ejemplo/Display_de_7_segmentos.c"
char display[8]={0x01,0x02,0x0a,0x07,0x00,0x00,0x00,0x00};

const char TablaCA[16]={0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8,0x80,0x90,0x88,0x83,0xC6,0xA1,0x86,0x8E};
char barrido, i;
float ff1 = -3742;
char txt[15];


void desplegar(void){
 barrido=0x01;
 for (i=0;i<6;i++)
 {
 PORTC=0;
 PORTB=TablaCA[display[i]];
 PORTC=barrido;
 barrido=barrido<<1;
 }
}
void main() {
TRISB=0;
TRISC=0;
ANSELH=0;
PORTB=0;
PORTC=0;
while(1){
 desplegar();
 FloatToStr(ff1, txt);
}
}
