
_main:

;motorCC.c,29 :: 		void main() {
;motorCC.c,30 :: 		initMain();
	CALL       _initMain+0
;motorCC.c,31 :: 		ciclo_de_trabajo_actual = 16;    // Valor inicial de la variable ciclo_de_trabajo_actual
	MOVLW      16
	MOVWF      _ciclo_de_trabajo_actual+0
;motorCC.c,32 :: 		ciclo_de_trabajo_anterior = 0;   // Reiniciar la variable ciclo_de trabajo_anterior
	CLRF       _ciclo_de_trabajo_anterior+0
;motorCC.c,33 :: 		PWM1_Start();
	CALL       _PWM1_Start+0
;motorCC.c,34 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);      // Comando LCD (apagar el cursor)
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;motorCC.c,35 :: 		Lcd_Cmd(_LCD_CLEAR);           // Comando LCD (borrar el LCD)                  // Iniciar el módulo PWM1
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;motorCC.c,36 :: 		Lcd_Out(1,1,"Motor C.C.:");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_motorCC+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;motorCC.c,37 :: 		while (1) {                      // Bucle infinito
L_main0:
;motorCC.c,38 :: 		if (Button(&PORTB, 6,1,0))     // Si se presiona el botón conectado al RB6
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	MOVLW      6
	MOVWF      FARG_Button_pin+0
	MOVLW      1
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main2
;motorCC.c,39 :: 		ciclo_de_trabajo_actual++ ;    // incrementar el valor de la variable current_duty
	INCF       _ciclo_de_trabajo_actual+0, 1
L_main2:
;motorCC.c,40 :: 		if (Button(&PORTB, 7,1,0))     // Si se presiona el botón conectado al RB7
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	MOVLW      7
	MOVWF      FARG_Button_pin+0
	MOVLW      1
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main3
;motorCC.c,41 :: 		ciclo_de_trabajo_actual-- ;    // decrementar el valor de la variable current_duty
	DECF       _ciclo_de_trabajo_actual+0, 1
L_main3:
;motorCC.c,43 :: 		if (ciclo_de_trabajo_anterior != ciclo_de_trabajo_actual) {             // Si ciclo_de_trabajo_actual y
	MOVF       _ciclo_de_trabajo_anterior+0, 0
	XORWF      _ciclo_de_trabajo_actual+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main4
;motorCC.c,45 :: 		PWM1_Set_Duty(ciclo_de_trabajo_actual);              // ajustar un nuevo valor a PWM,
	MOVF       _ciclo_de_trabajo_actual+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;motorCC.c,46 :: 		ciclo_de_trabajo_anterior = ciclo_de_trabajo_actual; // Guardar el nuevo valor
	MOVF       _ciclo_de_trabajo_actual+0, 0
	MOVWF      _ciclo_de_trabajo_anterior+0
;motorCC.c,47 :: 		WordToStr(ciclo_de_trabajo_anterior, txt);  //
	MOVF       _ciclo_de_trabajo_actual+0, 0
	MOVWF      FARG_WordToStr_input+0
	CLRF       FARG_WordToStr_input+1
	MOVLW      _txt+0
	MOVWF      FARG_WordToStr_output+0
	CALL       _WordToStr+0
;motorCC.c,48 :: 		Lcd_Out(2,1,"duty_c:");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_motorCC+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;motorCC.c,49 :: 		Lcd_Out(2,9,txt);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;motorCC.c,50 :: 		}
L_main4:
;motorCC.c,51 :: 		Delay_ms(50); // Tiempo de retardo de 50mS
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main5:
	DECFSZ     R13+0, 1
	GOTO       L_main5
	DECFSZ     R12+0, 1
	GOTO       L_main5
	NOP
	NOP
;motorCC.c,52 :: 		}
	GOTO       L_main0
;motorCC.c,53 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_initMain:

;motorCC.c,54 :: 		void initMain() {
;motorCC.c,55 :: 		TRISC = 0X00;
	CLRF       TRISC+0
;motorCC.c,56 :: 		PORTB = 0xff;     // Estado inicial del puerto PORTB
	MOVLW      255
	MOVWF      PORTB+0
;motorCC.c,57 :: 		TRISB = 0xff;     // Todos los pines del puerto PORTB se configuran como entradas
	MOVLW      255
	MOVWF      TRISB+0
;motorCC.c,58 :: 		PORTD = 0x00;     // Estado inicial del puerto PORTB
	CLRF       PORTD+0
;motorCC.c,59 :: 		TRISD = 0x00;     // Todos los pines del puerto PORTB se configuran como entradas
	CLRF       TRISD+0
;motorCC.c,60 :: 		NOT_RBPU_bit=0;      //Resistencias de pull up activadas
	BCF        NOT_RBPU_bit+0, BitPos(NOT_RBPU_bit+0)
;motorCC.c,62 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;motorCC.c,63 :: 		PWM1_Init(500); // Inicialización del módulo PWM (500Hz)
	BSF        T2CON+0, 0
	BSF        T2CON+0, 1
	MOVLW      249
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;motorCC.c,64 :: 		}
L_end_initMain:
	RETURN
; end of _initMain
