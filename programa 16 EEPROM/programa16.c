void main() {

  PORTB = 0;                 // Valor inicial del puerto PORTB
  TRISB = 0;                 // Todos los pines del puerto PORTB se configuran

  // como salidas
  PORTD = 0;                 // Valor inicial del puerto PORTB
  TRISD = 0;                 // Todos los pines del puerto PORTD se configuran

  // como salidas
  TRISA = 0xFF;              // Todos los pines del puerto PORTA se configuran

  // como entradas
  ADCON1= 0X0E;
  PORTD = EEPROM_Read(5);    // Leer la memoria EEPROM en la dirección 5

  do {
    PORTB = PORTB++;         // Incrementar el puerto PORTB en 1
    Delay_ms(100);           // Tiempo de retardo de 100mS

    if (~PORTA.B2) EEPROM_Write(5,PORTB); // Si se pulsa el botón MEMO, guardar el puerto PORTB

    PORTD = EEPROM_Read(5);  // Leer el dato escrito

    do {}
      while (~PORTA.B2);      // Quedarse en este bucle hasta que el botón esté pulsado

  }
  while(1);                  // Bucle infinito
}