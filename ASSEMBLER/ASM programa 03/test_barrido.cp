#line 1 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/prueba 01/test_barrido.c"
const char TablaCA[18]={0x03,0x9f,0x25,0x0d,0x99,0x49,0x41,0x1f,0x01,0x09,0x11,0xc1,0x63,0x85,0x61,0x71,0x03,0x9f};
const char TablaCA2[18]={0x03,0x9f,0x29,0x0d,0x95,0x45,0x41,0x1f,0x01,0x05,0x11,0xc1,0x63,0x89,0x61,0x71,0x03,0x9f};
char display[4]={0,1,2,3};
char barrido, i;
bit oldstate, oldstate2, puntos;
unsigned int contador, condicion_contar;
#line 21 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/prueba 01/test_barrido.c"
void desplegar(void){
 barrido=0x01;
 for (i=0;i<2;i++){
 PORTB=~(0+puntos);
 delay_ms(3);
 barrido=barrido<<1;
 PORTD=TablaCA2[display[2*i]];
 PORTB=~(barrido+puntos);
 delay_ms(3);
 PORTB=~(0+puntos);
 delay_ms(3);
 PORTD=TablaCA[display[2*i+1]];
 barrido=barrido<<1;
 PORTB=~(barrido+puntos);
 delay_ms(3);
 }
}

void main() {
ANSEL = 0X00;
ANSELH=0X00;
TRISC = 0XFF;
TRISB = 0X00;
TRISD = 0X00;
PORTB = 0Xff;
PORTC = 0x00;
oldstate = 0;
oldstate2 = 0;
puntos = 1;
condicion_contar = 80;
#line 64 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/prueba 01/test_barrido.c"
while (1){
 desplegar();
 if (Button(&PORTC, 0, 1, 1)) {
 oldstate = 1;
 }
 if (oldstate && Button(&PORTC, 0, 1, 0)) {
 display[0]+=1;
 display[1]+=1;
 display[2]+=1;
 display[3]+=1;
 oldstate = 0;
 }
 if (Button(&PORTC, 1, 1, 1)) {
 oldstate2 = 1;
 }
 if (oldstate && Button(&PORTC, 1, 1, 0)) {
 if (condicion_contar == 80){
 condicion_contar = 40;
 } else {
 condicion_contar = 80;
 }
 oldstate2 = 0;
 }
 contador++;
 if (contador >= condicion_contar) {
 contador=0;
 }
 if(contador <= 40){
 puntos = 0;
 } else if(contador < 80){
 puntos = 1;
 }
}
}
