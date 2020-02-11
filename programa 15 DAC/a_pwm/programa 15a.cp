#line 1 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/programa 15 DAC/a_pwm/programa 15a.c"


const unsigned short Seno[20] =
{
127, 146, 163, 177, 185, 189, 185,
177, 163, 146, 127, 107, 90, 76,
68, 65, 68, 76, 90, 107
};

void main( void )
{

unsigned short n=0;

PWM1_Init(15625);


PWM1_Start();

while(1)
{


 for( n=0; n<20; n++ )
 {

 PWM1_Set_Duty( Seno[n] );

 delay_us(50);
 }
}


}
