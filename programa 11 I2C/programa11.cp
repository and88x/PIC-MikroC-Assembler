#line 1 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/programa 11/programa11.c"
void main( void )
{

unsigned short DIRECCION;
unsigned short DATO;

ANSEL=0X00;
TRISA=0b00101111;
ANSELH=0X00;
TRISE = 7;
TRISB = 0;
PORTB = 0;

I2C1_Init(100000);
while(1)
{
 DIRECCION = (~PORTA)&0x0F;

 I2C1_Start();
 I2C1_Wr(0b10100000);
 I2C1_Wr(DIRECCION);
 I2C1_Repeated_Start();
 I2C1_Wr(0b10100001);
 DATO=I2C1_Rd(0);
 I2C1_Stop();

 PORTB = DATO;
 delay_ms(100);

 if( Button( &PORTA, 5, 10, 0) )
 {
 DATO = ~PORTD;

 I2C1_Start();
 I2C1_Wr(0b10100000);
 I2C1_Wr(DIRECCION);
 I2C1_Wr(DATO);
 I2C1_Stop();

 delay_ms(50);
 }
}
}
