 /*Cabecera******************************************************/
void SI3(int t){
     Sound_Play(246, t);
}
void DO(int t){
     Sound_Play(262, t);
}
void DO_s(int t){
     Sound_Play(277, t);
}
void RE(int t){
     Sound_Play(293, t);
}
void RE_s(int t){
     Sound_Play(311, t);
}
void MI(int t){
     Sound_Play(330, t);
}
void FA(int t){
     Sound_Play(349, t);
}
void FA_s(int t){
     Sound_Play(369, t);
}
void SOL(int t){
     Sound_Play(391, t);
}
void SOL_s(int t){
     Sound_Play(415, t);
}
void LA(int t){
     Sound_Play(440, t);
}
void LA_s(int t){
     Sound_Play(466, t);
}
void Si(int t){
     Sound_Play(494, t);
}
void LA3(int t){
     Sound_Play(220, t);
}
void SOL3(int t){
     Sound_Play(196, t);
}


void Tone1() {
  Sound_Play(659, 250); // Frecuencia = 659Hz, duración = 250ms
}

void Tone2() {
  Sound_Play(698, 250); // Frecuencia = 698Hz, duración = 250ms
}

void Tone3() {
  Sound_Play(784, 250); // Frecuencia = 784Hz, duración = 250ms
}

void Melody1() { // Componer una melodía divertida 1
  Tone1(); Tone2(); Tone3(); Tone3();
  Tone1(); Tone2(); Tone3(); Tone3();
  Tone1(); Tone2(); Tone3();
  Tone1(); Tone2(); Tone3(); Tone3();
  Tone1(); Tone2(); Tone3();
  Tone3(); Tone3(); Tone2(); Tone2(); Tone1();
}
void dragon_ball_gt() {
int t2 = 260;
int t= 130;
int t3=390;
     MI(t3); MI(t3); DO(t2); RE(t2); MI(t2); FA(t2);
     MI(t3); RE(t3); DO(t3); SI3(t3);
     DO(t3); DO(t3); LA3(t2); SI3(t2); DO(t2); RE(t2); 
     DO(t3); SI3(t3); LA3(t3); SOL3(t3); 
     LA3(t*4); LA3(t2); DO(t2); FA(t3);
     MI(t2); DO(t3); RE(t3); MI(t); FA(t); MI(t);
     RE(t); DO(t); RE(t); DO(t3); DO(t2); SI3(t2); DO(t2);
}

void ToneA() { // Tono A
  Sound_Play( 880, 50);
}

void ToneC() { // Tono C
  Sound_Play(1046, 50);
}

void ToneE() { // Tono E
  Sound_Play(1318, 50);
}

void Melody2() { // Componer una melodía divertida 2
  unsigned short i;

  for (i = 9; i > 0; i--) {
    ToneA(); ToneC(); ToneE();
  }
}

void main() {

  TRISC = 0x0F;                // Pines RB7-RB4 se configuran como entradas


  Sound_Init(&PORTD, 3);
  Sound_Play(1000, 500);

  while (1) {
    if (Button(&PORTC,0,1,1)) // RB7 genera Tono1
    Tone1();
    while (PORTC & 0x01) ;    // Esperar que se suelte el botón
    if (Button(&PORTC,1,1,1)) // RB6 genera Tono2
    Tone2();
    while (PORTC & 0x02) ;    // Esperar que se suelte el botón
    if (Button(&PORTC,2,1,1)) // RB5 genera melodía 2
    //Melody2();
    dragon_ball_gt();
    while (PORTB & 0x04) ;    // Esperar que se suelte el botón
    if (Button(&PORTC,3,1,1)) // RB4 genera melodía 1
    Melody1();
    while (PORTB & 0x08) ;    // Esperar que se suelte el botón
  }
}