
_main:

;programa14.c,20 :: 		void main() {
;programa14.c,21 :: 		UART1_Init(9600); // Inicializar el módulo USART
	MOVLW      25
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;programa14.c,24 :: 		Lcd_Init();                    // Inicialización del visualizador LCD
	CALL       _Lcd_Init+0
;programa14.c,25 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);      // Comando LCD (apagar el cursor)
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;programa14.c,26 :: 		Lcd_Cmd(_LCD_CLEAR);           // Comando LCD (borrar el LCD)
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;programa14.c,27 :: 		Lcd_out(1,1,"hola");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_programa14+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;programa14.c,28 :: 		while (1) {
L_main0:
;programa14.c,30 :: 		if (UART1_Data_Ready()) { // si se ha recibido un dato
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main2
;programa14.c,31 :: 		i = UART1_Read(); // leerlo
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _i+0
;programa14.c,32 :: 		switch (i) {
	GOTO       L_main3
;programa14.c,33 :: 		case 1 : Lcd_Cmd(_LCD_FIRST_ROW);// Move cursor to the 1st row
L_main5:
	MOVLW      128
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;programa14.c,34 :: 		break;
	GOTO       L_main4
;programa14.c,35 :: 		case 2 :Lcd_Cmd(_LCD_SECOND_ROW);// Move cursor to the 2nd row
L_main6:
	MOVLW      192
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;programa14.c,36 :: 		break;
	GOTO       L_main4
;programa14.c,37 :: 		case 3 :Lcd_Cmd(_LCD_THIRD_ROW);// Move cursor to the 3rd row
L_main7:
	MOVLW      148
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;programa14.c,38 :: 		break;
	GOTO       L_main4
;programa14.c,39 :: 		case 4 :Lcd_Cmd(_LCD_FOURTH_ROW);// Move cursor to the 4th row
L_main8:
	MOVLW      212
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;programa14.c,40 :: 		break;
	GOTO       L_main4
;programa14.c,41 :: 		case 5 :Lcd_Cmd(_LCD_CLEAR);// Clear display
L_main9:
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;programa14.c,42 :: 		break;
	GOTO       L_main4
;programa14.c,43 :: 		case 6 :Lcd_Cmd(_LCD_RETURN_HOME);// Return cursor to home position, returns a shifted display to its original position. Display data RAM is unaffected.
L_main10:
	MOVLW      2
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;programa14.c,44 :: 		break;
	GOTO       L_main4
;programa14.c,45 :: 		case 7 :Lcd_Cmd(_LCD_CURSOR_OFF);// Turn off cursor
L_main11:
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;programa14.c,46 :: 		break;
	GOTO       L_main4
;programa14.c,47 :: 		case 8 :Lcd_Cmd(_LCD_UNDERLINE_ON);// Underline cursor on
L_main12:
	MOVLW      14
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;programa14.c,48 :: 		break;
	GOTO       L_main4
;programa14.c,49 :: 		case 9 :Lcd_Cmd(_LCD_BLINK_CURSOR_ON);// Blink cursor on
L_main13:
	MOVLW      15
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;programa14.c,50 :: 		break;
	GOTO       L_main4
;programa14.c,51 :: 		case 10 :Lcd_Cmd(_LCD_MOVE_CURSOR_LEFT);// Move cursor left without changing display data RAM
L_main14:
	MOVLW      16
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;programa14.c,52 :: 		break;
	GOTO       L_main4
;programa14.c,53 :: 		case 11 :Lcd_Cmd(_LCD_MOVE_CURSOR_RIGHT);// Move cursor right without changing display data RAM
L_main15:
	MOVLW      20
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;programa14.c,54 :: 		break;
	GOTO       L_main4
;programa14.c,55 :: 		case 12 :Lcd_Cmd(_LCD_TURN_ON);// Turn Lcd display on
L_main16:
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;programa14.c,56 :: 		break;
	GOTO       L_main4
;programa14.c,57 :: 		case 13 :Lcd_Cmd(_LCD_TURN_OFF);// Turn Lcd display off
L_main17:
	MOVLW      8
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;programa14.c,58 :: 		break;
	GOTO       L_main4
;programa14.c,59 :: 		case 14 :Lcd_Cmd(_LCD_SHIFT_LEFT);// Shift display left without changing display data RAM
L_main18:
	MOVLW      24
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;programa14.c,60 :: 		break;
	GOTO       L_main4
;programa14.c,61 :: 		case 15 :Lcd_Cmd(_LCD_SHIFT_RIGHT);// Shift display right without changing display data RAM
L_main19:
	MOVLW      28
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;programa14.c,62 :: 		break;
	GOTO       L_main4
;programa14.c,64 :: 		default : Lcd_chr_Cp(i);
L_main20:
	MOVF       _i+0, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;programa14.c,65 :: 		UART1_Write(i); // enviarlo atrás
	MOVF       _i+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;programa14.c,66 :: 		}
	GOTO       L_main4
L_main3:
	MOVF       _i+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_main5
	MOVF       _i+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_main6
	MOVF       _i+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_main7
	MOVF       _i+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_main8
	MOVF       _i+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_main9
	MOVF       _i+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L_main10
	MOVF       _i+0, 0
	XORLW      7
	BTFSC      STATUS+0, 2
	GOTO       L_main11
	MOVF       _i+0, 0
	XORLW      8
	BTFSC      STATUS+0, 2
	GOTO       L_main12
	MOVF       _i+0, 0
	XORLW      9
	BTFSC      STATUS+0, 2
	GOTO       L_main13
	MOVF       _i+0, 0
	XORLW      10
	BTFSC      STATUS+0, 2
	GOTO       L_main14
	MOVF       _i+0, 0
	XORLW      11
	BTFSC      STATUS+0, 2
	GOTO       L_main15
	MOVF       _i+0, 0
	XORLW      12
	BTFSC      STATUS+0, 2
	GOTO       L_main16
	MOVF       _i+0, 0
	XORLW      13
	BTFSC      STATUS+0, 2
	GOTO       L_main17
	MOVF       _i+0, 0
	XORLW      14
	BTFSC      STATUS+0, 2
	GOTO       L_main18
	MOVF       _i+0, 0
	XORLW      15
	BTFSC      STATUS+0, 2
	GOTO       L_main19
	GOTO       L_main20
L_main4:
;programa14.c,71 :: 		}
L_main2:
;programa14.c,72 :: 		}
	GOTO       L_main0
;programa14.c,73 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
