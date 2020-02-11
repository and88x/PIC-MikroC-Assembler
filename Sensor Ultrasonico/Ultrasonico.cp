#line 1 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/Sensor Ultrasonico/Ultrasonico.c"
#line 17 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/Sensor Ultrasonico/Ultrasonico.c"
char *text;
int contador;
int distancia;
const int inicioTimer = 0x7265;


void interrupt() {
 if (TMR1IF_bit) {
 TMR1IF_bit=0;
 TMR1L = 0x65;
 TMR1H = 0x72;


 }
}


void main() {

T1CON = 0b00001000;
GIE_bit = 1;
PEIE_bit = 1;
PIE1.TMR1IE = 1;
TMR1L = 0x65;
TMR1H = 0x72;




TRISB6_bit = 0;
RB6_bit = 0;
RB7_bit = 0;
TRISB7_bit = 1;
TRISB5_bit = 0;
RB5_bit = 0;
TRISB4_bit = 0;
RB4_bit = 0;
#line 65 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/Sensor Ultrasonico/Ultrasonico.c"
while (1) {
 RB6_bit = 1;
 delay_us(15);
 RB6_bit = 0;
 TMR1ON_bit = 1;
 while (!RB7_bit){
 }

 while (RB7_bit && !TMR1IF){
 }
 TMR1ON_bit = 0;
 RB4_bit = 1;
 contador = TMR1H;
 contador = contador << 8;
 contador += TMR1L;
 distancia = (contador-inicioTimer)*2/145;




 if (distancia <= 15 ){
 RB5_bit = 1;
#line 89 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/Sensor Ultrasonico/Ultrasonico.c"
 }
}
}
