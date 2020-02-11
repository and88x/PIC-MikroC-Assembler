#line 1 "C:/Users/Andres/Desktop/programa 09/programa10.c"

sbit Chip_Select at RC7_bit;
sbit Chip_Select_Direction at TRISC7_bit;




void main() {

unsigned short DIRECCION;
unsigned short DATO, ESTADO;

ANSEL = 0X00;
TRISA = 0XFF;
ANSELH=0X00;
TRISE = 0X00;
TRISB = 0X00;
TRISD = 0XFF;
PORTB = 0X00;

Chip_Select = 1;
Chip_Select_Direction = 0;
SPI1_Init();

Chip_Select = 1;
while(1)
{
 DIRECCION = ((PORTA)&0x0F)|0x00;

 Chip_Select = 0;
 SPI1_Write(0b00000011);
 SPI1_Write(DIRECCION);
 DATO=SPI1_Read(0);
 Chip_Select = 1;

 PORTB = DATO;
 delay_ms(100);

 if( Button( &PORTA, 4, 10, 0) )
 {
 DATO = ~PORTD;

 Chip_Select = 0;
 SPI1_Write(0b00000110);
 Chip_Select = 1;


 Chip_Select = 0;
 SPI1_Write(0b00000010);
 SPI1_Write(DIRECCION);
 SPI1_Write(DATO);
 Chip_Select = 1;

 delay_ms(50);

 }
 Chip_Select = 0;
 SPI1_Write(0b00000101);
 ESTADO=SPI1_Read(0);
 PORTE=ESTADO;
 Chip_Select = 1;
}

}
