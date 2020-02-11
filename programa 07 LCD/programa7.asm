
_main:

;programa7.c,27 :: 		void main() {
;programa7.c,28 :: 		INTCON = 0;                    // Todas las interrupciones deshabilitadas
	CLRF       INTCON+0
;programa7.c,30 :: 		Lcd_Init();                    // Inicialización del visualizador LCD
	CALL       _Lcd_Init+0
;programa7.c,31 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);      // Comando LCD (apagar el cursor)
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;programa7.c,32 :: 		Lcd_Cmd(_LCD_CLEAR);           // Comando LCD (borrar el LCD)
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;programa7.c,34 :: 		text = "mikroElektronika";     // Definir el primer mensaje
	MOVLW      ?lstr1_programa7+0
	MOVWF      _text+0
;programa7.c,35 :: 		Lcd_Out(1,1,text);             // Escribir el primer mensaje en la primera línea
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVF       _text+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;programa7.c,37 :: 		text = "LCD ejemplo";          // Definir el segundo mensaje
	MOVLW      ?lstr2_programa7+0
	MOVWF      _text+0
;programa7.c,38 :: 		Lcd_Out(2,1,text);             // Definir el primer mensaje
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVF       _text+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;programa7.c,41 :: 		ADCON0=0xC0;                 //Solo interesa el reloj de conversión del ADC
	MOVLW      192
	MOVWF      ADCON0+0
;programa7.c,42 :: 		ADCON1=0b10000000;           //Justificacion derecha y todos los canales del puerto A analógicos y del puerto E digitales
	MOVLW      128
	MOVWF      ADCON1+0
;programa7.c,43 :: 		TRISA = 0xFF;                  // Todos los pines del puerto PORTA se configuran como entradas
	MOVLW      255
	MOVWF      TRISA+0
;programa7.c,44 :: 		Delay_ms(2000);
	MOVLW      21
	MOVWF      R11+0
	MOVLW      75
	MOVWF      R12+0
	MOVLW      190
	MOVWF      R13+0
L_main0:
	DECFSZ     R13+0, 1
	GOTO       L_main0
	DECFSZ     R12+0, 1
	GOTO       L_main0
	DECFSZ     R11+0, 1
	GOTO       L_main0
	NOP
;programa7.c,47 :: 		Lcd_Out(2,1,"voltage:");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_programa7+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;programa7.c,48 :: 		Lcd_Cmd(_LCD_CLEAR);           // Comando LCD (borrar el LCD)
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;programa7.c,49 :: 		while (1) {
L_main1:
;programa7.c,50 :: 		adc_rd = ADC_Read(0);        // Conversión A/D. Pin RA2 es una entrada.
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc_rd+0
	MOVF       R0+1, 0
	MOVWF      _adc_rd+1
;programa7.c,51 :: 		Lcd_Out(1,1,"Volt=");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_programa7+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;programa7.c,52 :: 		conversion=adc_rd*5./1023;
	MOVF       _adc_rd+0, 0
	MOVWF      R0+0
	MOVF       _adc_rd+1, 0
	MOVWF      R0+1
	CALL       _word2double+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      32
	MOVWF      R4+2
	MOVLW      129
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      192
	MOVWF      R4+1
	MOVLW      127
	MOVWF      R4+2
	MOVLW      136
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _conversion+0
	MOVF       R0+1, 0
	MOVWF      _conversion+1
	MOVF       R0+2, 0
	MOVWF      _conversion+2
	MOVF       R0+3, 0
	MOVWF      _conversion+3
;programa7.c,53 :: 		FloatToStr(conversion, text);
	MOVF       R0+0, 0
	MOVWF      FARG_FloatToStr_fnum+0
	MOVF       R0+1, 0
	MOVWF      FARG_FloatToStr_fnum+1
	MOVF       R0+2, 0
	MOVWF      FARG_FloatToStr_fnum+2
	MOVF       R0+3, 0
	MOVWF      FARG_FloatToStr_fnum+3
	MOVF       _text+0, 0
	MOVWF      FARG_FloatToStr_str+0
	CALL       _FloatToStr+0
;programa7.c,54 :: 		Lcd_out_CP(text);
	MOVF       _text+0, 0
	MOVWF      FARG_Lcd_Out_CP_text+0
	CALL       _Lcd_Out_CP+0
;programa7.c,55 :: 		Lcd_Out(2,3,"(Voltios)");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      3
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_programa7+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;programa7.c,56 :: 		Delay_ms(1);
	MOVLW      3
	MOVWF      R12+0
	MOVLW      151
	MOVWF      R13+0
L_main3:
	DECFSZ     R13+0, 1
	GOTO       L_main3
	DECFSZ     R12+0, 1
	GOTO       L_main3
	NOP
	NOP
;programa7.c,57 :: 		}
	GOTO       L_main1
;programa7.c,58 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
