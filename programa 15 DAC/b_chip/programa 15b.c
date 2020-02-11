// Conecciones del módulo DAC
sbit Chip_Select at RC0_bit;
sbit Chip_Select_Direction at TRISC0_bit;
// Fin de conecciones del módulo DAC

unsigned int value;

void InitMain() {
  TRISB0_bit = 1;                        // Pone el pin RA0 como entrada
  TRISB1_bit = 1;                        // Pone el pin RA1 como entrada
  ADCON1=0x0F;
  Chip_Select = 1;                       // Deseleciona el DAC
  Chip_Select_Direction = 0;             // Pone el pin CS# como salida
  NOT_RBPU_bit=0;                        // Habilita las resistencias de pull up
  SPI1_Init();                           // Inicializa el módulo SPI
}

// DAC se incrementa (0..4095) --> tensión de salida (0..Vref)
void DAC_Output(unsigned int valueDAC) {
  char temp;

  Chip_Select = 0;                       // Seleccciona el DAC

  // Envío del byte mas significativo
  temp = (valueDAC >> 8) & 0x0F;         // Guarda valueDAC[11..8] a temp[3..0]
  temp |= 0x30;                          // Define la configuración del DAC, ver el datasheet del MCP4921
  SPI1_Write(temp);                      // Envía el byte mas significativo por el SPI

  // Envío del byte menos significativo
  temp = valueDAC;                       // Guarda valueDAC[7..0] a temp[7..0]
  SPI1_Write(temp);                      // Envía el byte menos significativo por el SPI

  Chip_Select = 1;                       // Deselecciona el DAC
}

void main() {

  InitMain();                            // Realiza la inicializacion principal

  value = 2048;                          // Cuando el programa empieza, DAC posee
                                         //   la mitad del valor total

 while (1) {                             // Lazo  infinito

    if ((!RB0_bit) && (value < 4095)) {   // Si RA0 es precionado
      value++;                           //   incrementa el valor
      }
    else {
      if ((!RB1_bit) && (value > 0)) {    // If RA1 es precionado
        value--;                         //   decrementa el valor
        }
      }
    DAC_Output(value);                   // Envía el valor al DAC
    Delay_ms(1);
  }
}