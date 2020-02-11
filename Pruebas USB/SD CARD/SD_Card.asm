
_initSPI:

;SD_Card.c,23 :: 		void initSPI(void)
;SD_Card.c,25 :: 		SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	MOVLW       2
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;SD_Card.c,26 :: 		}
L_end_initSPI:
	RETURN      0
; end of _initSPI

_initFastSPI:

;SD_Card.c,27 :: 		void initFastSPI(void)
;SD_Card.c,29 :: 		SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV4, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	CLRF        FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;SD_Card.c,30 :: 		}
L_end_initFastSPI:
	RETURN      0
; end of _initFastSPI

_main:

;SD_Card.c,39 :: 		void main(){
;SD_Card.c,41 :: 		UART1_Init(9600);
	BSF         BAUDCON+0, 3, 0
	MOVLW       1
	MOVWF       SPBRGH+0 
	MOVLW       55
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;SD_Card.c,42 :: 		Delay_ms(100);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       134
	MOVWF       R12, 0
	MOVLW       153
	MOVWF       R13, 0
L_main0:
	DECFSZ      R13, 1, 1
	BRA         L_main0
	DECFSZ      R12, 1, 1
	BRA         L_main0
	DECFSZ      R11, 1, 1
	BRA         L_main0
;SD_Card.c,44 :: 		UART_Write(CR);
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;SD_Card.c,45 :: 		UART_Write_Text("Start__");
	MOVLW       ?lstr1_SD_Card+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr1_SD_Card+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
;SD_Card.c,46 :: 		UART_Write(CR);
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;SD_Card.c,47 :: 		Delay_ms(100);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       134
	MOVWF       R12, 0
	MOVLW       153
	MOVWF       R13, 0
L_main1:
	DECFSZ      R13, 1, 1
	BRA         L_main1
	DECFSZ      R12, 1, 1
	BRA         L_main1
	DECFSZ      R11, 1, 1
	BRA         L_main1
;SD_Card.c,49 :: 		initSPI();
	CALL        _initSPI+0, 0
;SD_Card.c,50 :: 		err = FAT32_Init();
	CALL        _FAT32_Init+0, 0
	MOVF        R0, 0 
	MOVWF       _err+0 
;SD_Card.c,52 :: 		if (err < 0)        //
	MOVLW       128
	XORWF       R0, 0 
	MOVWF       R1 
	MOVLW       128
	XORLW       0
	SUBWF       R1, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main2
;SD_Card.c,54 :: 		UART_Write(CR);
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;SD_Card.c,56 :: 		UART_Write_Text("*****init failed*****");
	MOVLW       ?lstr2_SD_Card+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr2_SD_Card+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
;SD_Card.c,57 :: 		UART_Write(CR);  // carrige return
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;SD_Card.c,58 :: 		UART_Write(LF);  // line feed
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;SD_Card.c,60 :: 		while(err < 0)  //  ...retry each second
L_main3:
	MOVLW       128
	XORWF       _err+0, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       0
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main4
;SD_Card.c,62 :: 		err = FAT32_Init();
	CALL        _FAT32_Init+0, 0
	MOVF        R0, 0 
	MOVWF       _err+0 
;SD_Card.c,63 :: 		Delay_ms(1000);
	MOVLW       16
	MOVWF       R11, 0
	MOVLW       57
	MOVWF       R12, 0
	MOVLW       13
	MOVWF       R13, 0
L_main5:
	DECFSZ      R13, 1, 1
	BRA         L_main5
	DECFSZ      R12, 1, 1
	BRA         L_main5
	DECFSZ      R11, 1, 1
	BRA         L_main5
	NOP
	NOP
;SD_Card.c,64 :: 		}
	GOTO        L_main3
L_main4:
;SD_Card.c,65 :: 		}
L_main2:
;SD_Card.c,67 :: 		initFastSPI();
	CALL        _initFastSPI+0, 0
;SD_Card.c,69 :: 		UART_Write(CR);
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;SD_Card.c,71 :: 		UART_Write_Text("*****init ok*****");
	MOVLW       ?lstr3_SD_Card+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr3_SD_Card+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
;SD_Card.c,72 :: 		UART_Write(CR);  // carrige return
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;SD_Card.c,73 :: 		UART_Write(LF);  // line feed
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;SD_Card.c,77 :: 		err = 0;
	CLRF        _err+0 
;SD_Card.c,78 :: 		if (err == FAT32_MakeDir("DIR_A"))  // Create a new folder: DIR_A
	MOVLW       ?lstr4_SD_Card+0
	MOVWF       FARG_FAT32_MakeDir_dname+0 
	MOVLW       hi_addr(?lstr4_SD_Card+0)
	MOVWF       FARG_FAT32_MakeDir_dname+1 
	CALL        _FAT32_MakeDir+0, 0
	MOVF        _err+0, 0 
	XORWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_main6
;SD_Card.c,80 :: 		UART_Write(CR);
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;SD_Card.c,81 :: 		UART_Write_Text( "folder DIR_A created");
	MOVLW       ?lstr5_SD_Card+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr5_SD_Card+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
;SD_Card.c,82 :: 		UART_Write(CR);  // carrige return
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;SD_Card.c,83 :: 		UART_Write(LF);  // line feed
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;SD_Card.c,85 :: 		err = FAT32_ChangeDir("DIR_A"); // Enter into DIR_A Folder
	MOVLW       ?lstr6_SD_Card+0
	MOVWF       FARG_FAT32_ChangeDir_dname+0 
	MOVLW       hi_addr(?lstr6_SD_Card+0)
	MOVWF       FARG_FAT32_ChangeDir_dname+1 
	CALL        _FAT32_ChangeDir+0, 0
	MOVF        R0, 0 
	MOVWF       _err+0 
;SD_Card.c,87 :: 		fhandle[0]  = FAT32_Open("TEST.TXT", FILE_APPEND ); //open/create TEXT.TXT
	MOVLW       ?lstr7_SD_Card+0
	MOVWF       FARG_FAT32_Open_fn+0 
	MOVLW       hi_addr(?lstr7_SD_Card+0)
	MOVWF       FARG_FAT32_Open_fn+1 
	MOVLW       4
	MOVWF       FARG_FAT32_Open_mode+0 
	CALL        _FAT32_Open+0, 0
	MOVF        R0, 0 
	MOVWF       _fhandle+0 
;SD_Card.c,88 :: 		fhandle[1]  = FAT32_Open("TEST2.TXT", FILE_APPEND ); //open/create TEXT2.TXT
	MOVLW       ?lstr8_SD_Card+0
	MOVWF       FARG_FAT32_Open_fn+0 
	MOVLW       hi_addr(?lstr8_SD_Card+0)
	MOVWF       FARG_FAT32_Open_fn+1 
	MOVLW       4
	MOVWF       FARG_FAT32_Open_mode+0 
	CALL        _FAT32_Open+0, 0
	MOVF        R0, 0 
	MOVWF       _fhandle+1 
;SD_Card.c,89 :: 		if (fhandle >= 0) {
	CLRF        R1 
	CLRF        R2 
	MOVF        R2, 0 
	SUBLW       hi_addr(_fhandle+0)
	BTFSS       STATUS+0, 2 
	GOTO        L__main16
	MOVF        R1, 0 
	SUBLW       _fhandle+0
L__main16:
	BTFSS       STATUS+0, 0 
	GOTO        L_main7
;SD_Card.c,90 :: 		UART_Write_Text( "files created/open successfully");
	MOVLW       ?lstr9_SD_Card+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr9_SD_Card+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
;SD_Card.c,91 :: 		UART_Write(CR);  // carrige return
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;SD_Card.c,92 :: 		UART_Write(LF);  // line feed
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;SD_Card.c,94 :: 		UART_Write_Text( "writting to TEST and TEST2 files...");
	MOVLW       ?lstr10_SD_Card+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr10_SD_Card+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
;SD_Card.c,95 :: 		UART_Write(CR);  // carrige return
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;SD_Card.c,96 :: 		UART_Write(LF);  // line feed
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;SD_Card.c,100 :: 		FAT32_Write(fhandle[0], "Hello, this is text written in TEST.TXT", 40);
	MOVF        _fhandle+0, 0 
	MOVWF       FARG_FAT32_Write_fHandle+0 
	MOVLW       ?lstr11_SD_Card+0
	MOVWF       FARG_FAT32_Write_wrBuf+0 
	MOVLW       hi_addr(?lstr11_SD_Card+0)
	MOVWF       FARG_FAT32_Write_wrBuf+1 
	MOVLW       40
	MOVWF       FARG_FAT32_Write_len+0 
	MOVLW       0
	MOVWF       FARG_FAT32_Write_len+1 
	CALL        _FAT32_Write+0, 0
;SD_Card.c,101 :: 		FAT32_Write(fhandle[1], "Hello, and this one is text written in TEST2.TXT", 49);
	MOVF        _fhandle+1, 0 
	MOVWF       FARG_FAT32_Write_fHandle+0 
	MOVLW       ?lstr12_SD_Card+0
	MOVWF       FARG_FAT32_Write_wrBuf+0 
	MOVLW       hi_addr(?lstr12_SD_Card+0)
	MOVWF       FARG_FAT32_Write_wrBuf+1 
	MOVLW       49
	MOVWF       FARG_FAT32_Write_len+0 
	MOVLW       0
	MOVWF       FARG_FAT32_Write_len+1 
	CALL        _FAT32_Write+0, 0
;SD_Card.c,103 :: 		UART_Write_Text( "Text written successfully");
	MOVLW       ?lstr13_SD_Card+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr13_SD_Card+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
;SD_Card.c,104 :: 		UART_Write(CR);  // carrige return
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;SD_Card.c,105 :: 		UART_Write(LF);  // line feed
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;SD_Card.c,108 :: 		err = FAT32_Close(fhandle[0]); // Close  TEXT.TXT file
	MOVF        _fhandle+0, 0 
	MOVWF       FARG_FAT32_Close_fHandle+0 
	CALL        _FAT32_Close+0, 0
	MOVF        R0, 0 
	MOVWF       _err+0 
;SD_Card.c,109 :: 		err = FAT32_Close(fhandle[1]); // Close  TEXT2.TXT file
	MOVF        _fhandle+1, 0 
	MOVWF       FARG_FAT32_Close_fHandle+0 
	CALL        _FAT32_Close+0, 0
	MOVF        R0, 0 
	MOVWF       _err+0 
;SD_Card.c,111 :: 		if (err == 0) {         // if the files were previously opened and no error occured  ...}
	MOVF        R0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main8
;SD_Card.c,112 :: 		UART_Write_Text( "files closed successfully");
	MOVLW       ?lstr14_SD_Card+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr14_SD_Card+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
;SD_Card.c,113 :: 		UART_Write(CR);  // carrige return
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;SD_Card.c,114 :: 		UART_Write(LF);  // line feed
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;SD_Card.c,115 :: 		}
L_main8:
;SD_Card.c,117 :: 		}
	GOTO        L_main9
L_main7:
;SD_Card.c,119 :: 		UART_Write(CR);
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;SD_Card.c,120 :: 		UART_Write_Text("files not created");
	MOVLW       ?lstr15_SD_Card+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr15_SD_Card+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
;SD_Card.c,121 :: 		UART_Write(CR);  // carrige return
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;SD_Card.c,122 :: 		UART_Write(LF);  // line feed
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;SD_Card.c,123 :: 		}
L_main9:
;SD_Card.c,125 :: 		}
	GOTO        L_main10
L_main6:
;SD_Card.c,127 :: 		UART_Write(CR);
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;SD_Card.c,128 :: 		UART_Write_Text("folder not created");
	MOVLW       ?lstr16_SD_Card+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr16_SD_Card+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
;SD_Card.c,129 :: 		UART_Write(CR);  // carrige return
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;SD_Card.c,130 :: 		UART_Write(LF);  // line feed
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;SD_Card.c,131 :: 		}
L_main10:
;SD_Card.c,132 :: 		while (1)
L_main11:
;SD_Card.c,135 :: 		}
	GOTO        L_main11
;SD_Card.c,139 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
