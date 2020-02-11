#line 1 "C:/Users/Remigio Guevara/Dropbox/materias/microcontroladores de gama alta/clase/programa 15 DAC/c_resistencias/programa 15c.c"


const unsigned short Seno[20] =
{
127, 146, 163, 177, 185, 189, 185,
177, 163, 146, 127, 107, 90, 76,
68, 65, 68, 76, 90, 107
};
void main( void )
{

unsigned short n=0;

TRISC = 0;
PORTC = 127;
while(1)
{


for( n=0; n<20; n++ )
{

PORTC = Seno[n];

delay_us(50);
}
}
}
