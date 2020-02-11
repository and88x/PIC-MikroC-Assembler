#line 1 "C:/Users/Remigio Guevara/Dropbox/materias/microcontroladores de gama alta/clase/programa 15 DAC/b_chip/programa 15b.c"

sbit Chip_Select at RC0_bit;
sbit Chip_Select_Direction at TRISC0_bit;


unsigned int value;

void InitMain() {
 TRISB0_bit = 1;
 TRISB1_bit = 1;
 ADCON1=0x0F;
 Chip_Select = 1;
 Chip_Select_Direction = 0;
 NOT_RBPU_bit=0;
 SPI1_Init();
}


void DAC_Output(unsigned int valueDAC) {
 char temp;

 Chip_Select = 0;


 temp = (valueDAC >> 8) & 0x0F;
 temp |= 0x30;
 SPI1_Write(temp);


 temp = valueDAC;
 SPI1_Write(temp);

 Chip_Select = 1;
}

void main() {

 InitMain();

 value = 2048;


 while (1) {

 if ((!RB0_bit) && (value < 4095)) {
 value++;
 }
 else {
 if ((!RB1_bit) && (value > 0)) {
 value--;
 }
 }
 DAC_Output(value);
 Delay_ms(1);
 }
}
