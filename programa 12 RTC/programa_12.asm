
_main:

;programa_12.c,1 :: 		void main( void )
;programa_12.c,7 :: 		DS1307Inicio();
	CALL       _DS1307Inicio+0
;programa_12.c,9 :: 		UART1_Init(9600);
	MOVLW      25
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;programa_12.c,11 :: 		DATO = DS1307GetSegundos();
	CALL       _DS1307GetSegundos+0
	MOVF       R0+0, 0
	MOVWF      main_DATO_L0+0
;programa_12.c,12 :: 		while(1) //Bucle infinito.
L_main0:
;programa_12.c,15 :: 		while( DATO == DS1307GetSegundos() )delay_ms(200);
L_main2:
	CALL       _DS1307GetSegundos+0
	MOVF       main_DATO_L0+0, 0
	XORWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main3
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main4:
	DECFSZ     R13+0, 1
	GOTO       L_main4
	DECFSZ     R12+0, 1
	GOTO       L_main4
	DECFSZ     R11+0, 1
	GOTO       L_main4
	NOP
	GOTO       L_main2
L_main3:
;programa_12.c,17 :: 		DATO = DS1307GetHoras();
	CALL       _DS1307GetHoras+0
	MOVF       R0+0, 0
	MOVWF      main_DATO_L0+0
;programa_12.c,18 :: 		ByteToStr( DATO, Text );
	MOVF       R0+0, 0
	MOVWF      FARG_ByteToStr_input+0
	MOVLW      main_Text_L0+0
	MOVWF      FARG_ByteToStr_output+0
	CALL       _ByteToStr+0
;programa_12.c,19 :: 		UART1_Write_Text( Text ); UART1_Write_Text(":");
	MOVLW      main_Text_L0+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
	MOVLW      ?lstr1_programa_12+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;programa_12.c,21 :: 		DATO = DS1307GetMinutos();
	CALL       _DS1307GetMinutos+0
	MOVF       R0+0, 0
	MOVWF      main_DATO_L0+0
;programa_12.c,22 :: 		ByteToStr( DATO, Text );
	MOVF       R0+0, 0
	MOVWF      FARG_ByteToStr_input+0
	MOVLW      main_Text_L0+0
	MOVWF      FARG_ByteToStr_output+0
	CALL       _ByteToStr+0
;programa_12.c,23 :: 		UART1_Write_Text( Text ); UART1_Write_Text(":");
	MOVLW      main_Text_L0+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
	MOVLW      ?lstr2_programa_12+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;programa_12.c,25 :: 		DATO = DS1307GetSegundos();
	CALL       _DS1307GetSegundos+0
	MOVF       R0+0, 0
	MOVWF      main_DATO_L0+0
;programa_12.c,26 :: 		ByteToStr( DATO, Text );
	MOVF       R0+0, 0
	MOVWF      FARG_ByteToStr_input+0
	MOVLW      main_Text_L0+0
	MOVWF      FARG_ByteToStr_output+0
	CALL       _ByteToStr+0
;programa_12.c,27 :: 		UART1_Write_Text( Text ); UART1_Write(13); UART1_Write(10);
	MOVLW      main_Text_L0+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
	MOVLW      13
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
	MOVLW      10
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;programa_12.c,28 :: 		}
	GOTO       L_main0
;programa_12.c,29 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
