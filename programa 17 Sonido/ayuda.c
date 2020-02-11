 /*Cabecera******************************************************/

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
    Melody2();
    while (PORTB & 0x04) ;    // Esperar que se suelte el botón
    if (Button(&PORTC,3,1,1)) // RB4 genera melodía 1
    Melody1();
    while (PORTB & 0x08) ;    // Esperar que se suelte el botón
  }
}