#line 1 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/programa 12/programa_12.c"
void main( void )
{

 char Text[50];
 unsigned short DATO;

 DS1307Inicio();

 UART1_Init(9600);

 DATO = DS1307GetSegundos();
 while(1)
 {

 while( DATO == DS1307GetSegundos() )delay_ms(200);

 DATO = DS1307GetHoras();
 ByteToStr( DATO, Text );
 UART1_Write_Text( Text ); UART1_Write_Text(":");

 DATO = DS1307GetMinutos();
 ByteToStr( DATO, Text );
 UART1_Write_Text( Text ); UART1_Write_Text(":");

 DATO = DS1307GetSegundos();
 ByteToStr( DATO, Text );
 UART1_Write_Text( Text ); UART1_Write(13); UART1_Write(10);
 }
}
