
// Software I2C connections
sbit Soft_I2C_Scl           at RC3_bit;
sbit Soft_I2C_Sda           at RC4_bit;
sbit Soft_I2C_Scl_Direction at TRISC3_bit;
sbit Soft_I2C_Sda_Direction at TRISC4_bit;
// End Software I2C connections




void main( void )
{
     //Declaración de variables.
     char Text[50];
     unsigned short DATO;
     //Inicio y configuración del reloj.
     DS1307Inicio();
     //Inicio y configuración de la USART a 9600 bps.
     UART1_Init(9600);
     //Se leen los segundos del reloj.
     DATO = DS1307GetSegundos();
     while(1) //Bucle infinito.
     {
         //Se espera el cambio en los segundos.
         while( DATO == DS1307GetSegundos() )delay_ms(200);
         //Se leen la hora y se transmiten por la USART.
         DATO = DS1307GetHoras();
         ByteToStr( DATO, Text );
         UART1_Write_Text( Text ); UART1_Write_Text(":");
         //Se leen los minutos y se transmiten por la USART.
         DATO = DS1307GetMinutos();
         ByteToStr( DATO, Text );
         UART1_Write_Text( Text ); UART1_Write_Text(":");
         //Se leen los segundos y se transmiten por la USART.
         DATO = DS1307GetSegundos();
         ByteToStr( DATO, Text );
         UART1_Write_Text( Text ); UART1_Write(13); UART1_Write(10);
     }
}