const char TablaCA[18]={0x03,0x9f,0x25,0x0d,0x99,0x49,0x41,0x1f,0x01,0x09,0x11,0xc1,0x63,0x85,0x61,0x71,0x03,0x9f};
const char TablaCA2[18]={0x03,0x9f,0x29,0x0d,0x95,0x45,0x41,0x1f,0x01,0x05,0x11,0xc1,0x63,0x89,0x61,0x71,0x03,0x9f};
char display[4]={0,1,2,3};
char barrido, i;//, contador;
bit oldstate, oldstate2, puntos;                               // Old state flag
unsigned int contador, condicion_contar;
//#define p PORTB. f0
/*void interrupt() {
  if (PIR1.CCP1IF == 1){
     PIR1.CCP1IF == 0;
     TMR1H = 0;
     TMR1L = 0;
     if (contador == 20){
        contador=0;
     }else{
        contador+=1;
     }
  }
}*/

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

/*CCP1IE_BIT = 1;
T1CON = 0x01;
CCPR1H = 0xc3;
CCPR1L = 0x50; //una interrupcion cada 50ms
TMR1H = 0;
TMR1L = 0;

CCP1CON = 0x0a;       //Compare mode, generate software interrupt on match
GIE_BIT = 1;
PEIE_BIT =1;
contador =0;*/

while (1){
    desplegar();
    if (Button(&PORTC, 0, 1, 1)) {               // Detect logical one
      oldstate = 1;                              // Update flag
    }
    if (oldstate && Button(&PORTC, 0, 1, 0)) {   // Detect one-to-zero transition
      display[0]+=1;
      display[1]+=1;
      display[2]+=1;
      display[3]+=1;
      oldstate = 0;                              // Update flag
    }
    if (Button(&PORTC, 1, 1, 1)) {               // Detect logical one
      oldstate2 = 1;                              // Update flag
    }
    if (oldstate && Button(&PORTC, 1, 1, 0)) {   // Detect one-to-zero transition
      if (condicion_contar == 80){
         condicion_contar = 40;
      }  else {
         condicion_contar = 80;
      }
      oldstate2 = 0;                              // Update flag
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