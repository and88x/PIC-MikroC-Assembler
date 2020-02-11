#define CR 0x0D // carrige return
#define LF 0x0A // line feed
typedef unsigned short      uint8;
typedef   signed short      int8;
////////////////////////////////////////////////////////////////////////////////
//
//  modes of file operation:
//      - read   ( resets cursor to 0 )
//      - write  ( resets cursor to 0 )
//      - append ( leaves cursor as is )
//
////////////////////////////////////////////////////////////////////////////////
static const uint8
    FILE_READ       = 0x01,
    FILE_WRITE      = 0x02,
    FILE_APPEND     = 0x04;

// Mmc Library requirements
sbit Mmc_Chip_Select           at RC0_bit;
sbit Mmc_Chip_Select_Direction at TRISC0_bit;

// SPI initialization routines required by Mmc Library
void initSPI(void)
{
    SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
}
void initFastSPI(void)
{
    SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV4, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
}


int8   err;
//signed short err;
short fhandle[4];   // file handle variable should be signed (4 = max files can be open at the same time



void main(){
 //  UART module initialization
  UART1_Init(9600);
  Delay_ms(100);

  UART_Write(CR);
  UART_Write_Text("Start__");
  UART_Write(CR);
  Delay_ms(100);

initSPI();
err = FAT32_Init();

 if (err < 0)        //
    {
        UART_Write(CR);
       // UART_Write_Text(constToVar(uartbuf, "init failed"));
       UART_Write_Text("*****init failed*****");
        UART_Write(CR);  // carrige return
        UART_Write(LF);  // line feed

        while(err < 0)  //  ...retry each second
        {
            err = FAT32_Init();
            Delay_ms(1000);
        }
    }

initFastSPI();

 UART_Write(CR);
   // UART_Write_Text(constToVar(uartbuf, "init ok"));
   UART_Write_Text("*****init ok*****");
    UART_Write(CR);  // carrige return
    UART_Write(LF);  // line feed

  //   Create a folder

err = 0;
if (err == FAT32_MakeDir("DIR_A"))  // Create a new folder: DIR_A
    {
        UART_Write(CR);
        UART_Write_Text( "folder DIR_A created");
        UART_Write(CR);  // carrige return
        UART_Write(LF);  // line feed

        err = FAT32_ChangeDir("DIR_A"); // Enter into DIR_A Folder

        fhandle[0]  = FAT32_Open("TEST.TXT", FILE_APPEND ); //open/create TEXT.TXT
        fhandle[1]  = FAT32_Open("TEST2.TXT", FILE_APPEND ); //open/create TEXT2.TXT
          if (fhandle >= 0) {
             UART_Write_Text( "files created/open successfully");
             UART_Write(CR);  // carrige return
             UART_Write(LF);  // line feed

             UART_Write_Text( "writting to TEST and TEST2 files...");
             UART_Write(CR);  // carrige return
             UART_Write(LF);  // line feed

             //Write to files
            // for (i = 0; i < 50; i++ ) {
             FAT32_Write(fhandle[0], "Hello, this is text written in TEST.TXT", 40);
             FAT32_Write(fhandle[1], "Hello, and this one is text written in TEST2.TXT", 49);

             UART_Write_Text( "Text written successfully");
             UART_Write(CR);  // carrige return
             UART_Write(LF);  // line feed

           //Close all the files
             err = FAT32_Close(fhandle[0]); // Close  TEXT.TXT file
             err = FAT32_Close(fhandle[1]); // Close  TEXT2.TXT file

            if (err == 0) {         // if the files were previously opened and no error occured  ...}
               UART_Write_Text( "files closed successfully");
               UART_Write(CR);  // carrige return
               UART_Write(LF);  // line feed
             }

           }
           else {
           UART_Write(CR);
           UART_Write_Text("files not created");
           UART_Write(CR);  // carrige return
           UART_Write(LF);  // line feed
    }

    }
    else {
    UART_Write(CR);
        UART_Write_Text("folder not created");
        UART_Write(CR);  // carrige return
        UART_Write(LF);  // line feed
    }
  while (1)
  {
  ;   //loop
  }



}