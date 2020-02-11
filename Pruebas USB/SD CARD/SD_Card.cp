#line 1 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/EjemplosMios/SD CARD/SD_Card.c"


typedef unsigned short uint8;
typedef signed short int8;








static const uint8
 FILE_READ = 0x01,
 FILE_WRITE = 0x02,
 FILE_APPEND = 0x04;


sbit Mmc_Chip_Select at RC0_bit;
sbit Mmc_Chip_Select_Direction at TRISC0_bit;


void initSPI(void)
{
 SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
}
void initFastSPI(void)
{
 SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV4, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
}


int8 err;

short fhandle[4];



void main(){

 UART1_Init(9600);
 Delay_ms(100);

 UART_Write( 0x0D );
 UART_Write_Text("Start__");
 UART_Write( 0x0D );
 Delay_ms(100);

initSPI();
err = FAT32_Init();

 if (err < 0)
 {
 UART_Write( 0x0D );

 UART_Write_Text("*****init failed*****");
 UART_Write( 0x0D );
 UART_Write( 0x0A );

 while(err < 0)
 {
 err = FAT32_Init();
 Delay_ms(1000);
 }
 }

initFastSPI();

 UART_Write( 0x0D );

 UART_Write_Text("*****init ok*****");
 UART_Write( 0x0D );
 UART_Write( 0x0A );



err = 0;
if (err == FAT32_MakeDir("DIR_A"))
 {
 UART_Write( 0x0D );
 UART_Write_Text( "folder DIR_A created");
 UART_Write( 0x0D );
 UART_Write( 0x0A );

 err = FAT32_ChangeDir("DIR_A");

 fhandle[0] = FAT32_Open("TEST.TXT", FILE_APPEND );
 fhandle[1] = FAT32_Open("TEST2.TXT", FILE_APPEND );
 if (fhandle >= 0) {
 UART_Write_Text( "files created/open successfully");
 UART_Write( 0x0D );
 UART_Write( 0x0A );

 UART_Write_Text( "writting to TEST and TEST2 files...");
 UART_Write( 0x0D );
 UART_Write( 0x0A );



 FAT32_Write(fhandle[0], "Hello, this is text written in TEST.TXT", 40);
 FAT32_Write(fhandle[1], "Hello, and this one is text written in TEST2.TXT", 49);

 UART_Write_Text( "Text written successfully");
 UART_Write( 0x0D );
 UART_Write( 0x0A );


 err = FAT32_Close(fhandle[0]);
 err = FAT32_Close(fhandle[1]);

 if (err == 0) {
 UART_Write_Text( "files closed successfully");
 UART_Write( 0x0D );
 UART_Write( 0x0A );
 }

 }
 else {
 UART_Write( 0x0D );
 UART_Write_Text("files not created");
 UART_Write( 0x0D );
 UART_Write( 0x0A );
 }

 }
 else {
 UART_Write( 0x0D );
 UART_Write_Text("folder not created");
 UART_Write( 0x0D );
 UART_Write( 0x0A );
 }
 while (1)
 {
 ;
 }



}
