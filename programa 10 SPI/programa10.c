// Conexiones de la memoria
sbit Chip_Select at RC7_bit;
sbit Chip_Select_Direction at TRISC7_bit;




void main() {
//Declaración de variables.
unsigned short DIRECCION;
unsigned short DATO, ESTADO;
//Configuración de puertos.
ANSEL = 0X00;
TRISA = 0XFF;
ANSELH=0X00;
TRISE = 0X00;
TRISB = 0X00;
TRISD = 0XFF;
PORTB = 0X00;
//Inicio del módulo SPI.
Chip_Select = 1;                       // Deselecccionar la memoria
Chip_Select_Direction = 0;             // Set CS# pin as Output
SPI1_Init();

Chip_Select = 1;                       // Seleccionar la memoria
while(1) //Bucle infinito.
{
        DIRECCION = ((PORTA)&0x0F)|0x00; //Captura de la dirección.
         //Protocolo de lectura de la dirección DIRECCION.
         Chip_Select = 0;                       // Seleccionar la memoria
         SPI1_Write(0b00000011);
         SPI1_Write(DIRECCION);
         DATO=SPI1_Read(0);
         Chip_Select = 1;                       // Deselecccionar la memoria
         //Visualización del DATO en el puerto B.
         PORTB = DATO;
         delay_ms(100); //Retardo de 100 ms para graficar.
         //Sentencia if para evaluar si se pulsa el botón de grabar.
         if( Button( &PORTA, 4, 10, 0) )
         {
             DATO = ~PORTD; //Captura del valor del dato.

             Chip_Select = 0;                       // Seleccionar la memoria
             SPI1_Write(0b00000110);                //Habilita la escritura
             Chip_Select = 1;

             //Protocolo de grabación.
             Chip_Select = 0;                       // Seleccionar la memoria
             SPI1_Write(0b00000010);
             SPI1_Write(DIRECCION);
             SPI1_Write(DATO);
             Chip_Select = 1;                       // Deselecccionar la memoria
             //Retardo para esperar que la memoria grabe el dato.
             delay_ms(50);

         }
         Chip_Select = 0;                       // Seleccionar la memoria
         SPI1_Write(0b00000101);                   //Lee el status de la memoria
         ESTADO=SPI1_Read(0);
         PORTE=ESTADO;
         Chip_Select = 1;                       // Deselecccionar la memoria
}

}