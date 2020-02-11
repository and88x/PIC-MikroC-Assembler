//Declaración de constantes
//para la señal seno.
const unsigned short Seno[20] =
{
127, 146, 163, 177, 185, 189, 185,
177, 163, 146, 127, 107, 90, 76,
68, 65, 68, 76, 90, 107
};
void main( void )
{
//Declaración de variables.
unsigned short n=0;
//Configuración de puertos.
TRISC = 0;
PORTC = 127;
while(1) //Bucle infinito.
{
//Bucle para recorres las 20 muestras
//de un ciclo para la onda seno.
for( n=0; n<20; n++ )
{
//Cambio de muestra en el puerto B.
PORTC = Seno[n];
//Retardo de 50u seg.
delay_us(50);
}
}
}