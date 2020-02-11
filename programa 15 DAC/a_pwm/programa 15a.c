//Declaraci�n de constantes
//para la se�al seno.
const unsigned short Seno[20] =
{
127, 146, 163, 177, 185, 189, 185,
177, 163, 146, 127, 107, 90, 76,
68, 65, 68, 76, 90, 107
};

void main( void )
{
//Declaraci�n de variables.
unsigned short n=0;
//Configuraci�n del m�dulo PWM a Fpwm=15.625K Hz.
PWM1_Init(15625);   //averiguar por que este valor
//PWM1_Init(30000);
//Se inicia el m�dulo PWM con 0%.
PWM1_Start();
//PWM1_Set_Duty(100);
while(1) //Bucle infinito.
{
  //Bucle para recorres las 20 muestras
  //de un ciclo para la onda seno.
  for( n=0; n<20; n++ )
  {
     //Cambio del ciclo �til del PWM.
     PWM1_Set_Duty( Seno[n] );
     //Retardo de 50u seg.
     delay_us(50);
   }
}


}