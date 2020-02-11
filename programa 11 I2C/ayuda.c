void main( void )
{
//Declaraci�n de variables.
unsigned short DIRECCION;
unsigned short DATO;
//Configuraci�n de puertos.
ANSEL=0X00;
TRISA=0b00101111;
ANSELH=0X00;
TRISE = 7;
TRISB = 0;
PORTB = 0;
//Inicio del m�dulo I2C a 100K bps.
I2C1_Init(100000);
while(1) //Bucle infinito.
{
         DIRECCION = (~PORTA)&0x0F; //Captura de la direcci�n.
         //Protocolo de lectura de la direcci�n DIRECCION.
         I2C1_Start();
         I2C1_Wr(0b10100000);
         I2C1_Wr(DIRECCION);
         I2C1_Repeated_Start();
         I2C1_Wr(0b10100001);
         DATO=I2C1_Rd(0);
         I2C1_Stop();
         //Visualizaci�n del DATO en el puerto B.
         PORTB = DATO;
         delay_ms(100); //Retardo de 100 ms para graficar.
         //Sentencia if para evaluar si se pulsa el bot�n de grabar.
         if( Button( &PORTA, 5, 10, 0) )
         {
             DATO = ~PORTD; //Captura del valor del dato.
             //Protocolo de grabaci�n.
             I2C1_Start();
             I2C1_Wr(0b10100000);
             I2C1_Wr(DIRECCION);
             I2C1_Wr(DATO);
             I2C1_Stop();
             //Retardo para esperar que la memoria grabe el dato.
             delay_ms(50);
         }
}
}