
_desplegar:

;test_barrido.c,21 :: 		void desplegar(void){
;test_barrido.c,22 :: 		barrido=0x01;
	MOVLW      1
	MOVWF      _barrido+0
;test_barrido.c,23 :: 		for (i=0;i<2;i++){
	CLRF       _i+0
L_desplegar0:
	MOVLW      2
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_desplegar1
;test_barrido.c,24 :: 		PORTB=~(0+puntos);
	CLRF       R0+0
	BTFSC      _puntos+0, BitPos(_puntos+0)
	INCF       R0+0, 1
	COMF       R0+0, 0
	MOVWF      PORTB+0
;test_barrido.c,25 :: 		delay_ms(3);
	MOVLW      4
	MOVWF      R12+0
	MOVLW      228
	MOVWF      R13+0
L_desplegar3:
	DECFSZ     R13+0, 1
	GOTO       L_desplegar3
	DECFSZ     R12+0, 1
	GOTO       L_desplegar3
	NOP
;test_barrido.c,26 :: 		barrido=barrido<<1;
	MOVF       _barrido+0, 0
	MOVWF      R3+0
	RLF        R3+0, 1
	BCF        R3+0, 0
	MOVF       R3+0, 0
	MOVWF      _barrido+0
;test_barrido.c,27 :: 		PORTD=TablaCA2[display[2*i]];
	MOVF       _i+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _display+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	ADDLW      _TablaCA2+0
	MOVWF      R0+0
	MOVLW      hi_addr(_TablaCA2+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      PORTD+0
;test_barrido.c,28 :: 		PORTB=~(barrido+puntos);
	CLRF       R0+0
	BTFSC      _puntos+0, BitPos(_puntos+0)
	INCF       R0+0, 1
	MOVF       R3+0, 0
	ADDWF      R0+0, 1
	COMF       R0+0, 0
	MOVWF      PORTB+0
;test_barrido.c,29 :: 		delay_ms(3);
	MOVLW      4
	MOVWF      R12+0
	MOVLW      228
	MOVWF      R13+0
L_desplegar4:
	DECFSZ     R13+0, 1
	GOTO       L_desplegar4
	DECFSZ     R12+0, 1
	GOTO       L_desplegar4
	NOP
;test_barrido.c,30 :: 		PORTB=~(0+puntos);
	CLRF       R0+0
	BTFSC      _puntos+0, BitPos(_puntos+0)
	INCF       R0+0, 1
	COMF       R0+0, 0
	MOVWF      PORTB+0
;test_barrido.c,31 :: 		delay_ms(3);
	MOVLW      4
	MOVWF      R12+0
	MOVLW      228
	MOVWF      R13+0
L_desplegar5:
	DECFSZ     R13+0, 1
	GOTO       L_desplegar5
	DECFSZ     R12+0, 1
	GOTO       L_desplegar5
	NOP
;test_barrido.c,32 :: 		PORTD=TablaCA[display[2*i+1]];
	MOVF       _i+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	INCF       R0+0, 1
	BTFSC      STATUS+0, 2
	INCF       R0+1, 1
	MOVF       R0+0, 0
	ADDLW      _display+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	ADDLW      _TablaCA+0
	MOVWF      R0+0
	MOVLW      hi_addr(_TablaCA+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      PORTD+0
;test_barrido.c,33 :: 		barrido=barrido<<1;
	MOVF       _barrido+0, 0
	MOVWF      R1+0
	RLF        R1+0, 1
	BCF        R1+0, 0
	MOVF       R1+0, 0
	MOVWF      _barrido+0
;test_barrido.c,34 :: 		PORTB=~(barrido+puntos);
	CLRF       R0+0
	BTFSC      _puntos+0, BitPos(_puntos+0)
	INCF       R0+0, 1
	MOVF       R1+0, 0
	ADDWF      R0+0, 1
	COMF       R0+0, 0
	MOVWF      PORTB+0
;test_barrido.c,35 :: 		delay_ms(3);
	MOVLW      4
	MOVWF      R12+0
	MOVLW      228
	MOVWF      R13+0
L_desplegar6:
	DECFSZ     R13+0, 1
	GOTO       L_desplegar6
	DECFSZ     R12+0, 1
	GOTO       L_desplegar6
	NOP
;test_barrido.c,23 :: 		for (i=0;i<2;i++){
	INCF       _i+0, 1
;test_barrido.c,36 :: 		}
	GOTO       L_desplegar0
L_desplegar1:
;test_barrido.c,37 :: 		}
L_end_desplegar:
	RETURN
; end of _desplegar

_main:

;test_barrido.c,39 :: 		void main() {
;test_barrido.c,40 :: 		ANSEL = 0X00;
	CLRF       ANSEL+0
;test_barrido.c,41 :: 		ANSELH=0X00;
	CLRF       ANSELH+0
;test_barrido.c,42 :: 		TRISC = 0XFF;
	MOVLW      255
	MOVWF      TRISC+0
;test_barrido.c,43 :: 		TRISB = 0X00;
	CLRF       TRISB+0
;test_barrido.c,44 :: 		TRISD = 0X00;
	CLRF       TRISD+0
;test_barrido.c,45 :: 		PORTB = 0Xff;
	MOVLW      255
	MOVWF      PORTB+0
;test_barrido.c,46 :: 		PORTC = 0x00;
	CLRF       PORTC+0
;test_barrido.c,47 :: 		oldstate = 0;
	BCF        _oldstate+0, BitPos(_oldstate+0)
;test_barrido.c,48 :: 		oldstate2 = 0;
	BCF        _oldstate2+0, BitPos(_oldstate2+0)
;test_barrido.c,49 :: 		puntos = 1;
	BSF        _puntos+0, BitPos(_puntos+0)
;test_barrido.c,50 :: 		condicion_contar = 80;
	MOVLW      80
	MOVWF      _condicion_contar+0
	MOVLW      0
	MOVWF      _condicion_contar+1
;test_barrido.c,64 :: 		while (1){
L_main7:
;test_barrido.c,65 :: 		desplegar();
	CALL       _desplegar+0
;test_barrido.c,66 :: 		if (Button(&PORTC, 0, 1, 1)) {               // Detect logical one
	MOVLW      PORTC+0
	MOVWF      FARG_Button_port+0
	CLRF       FARG_Button_pin+0
	MOVLW      1
	MOVWF      FARG_Button_time_ms+0
	MOVLW      1
	MOVWF      FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main9
;test_barrido.c,67 :: 		oldstate = 1;                              // Update flag
	BSF        _oldstate+0, BitPos(_oldstate+0)
;test_barrido.c,68 :: 		}
L_main9:
;test_barrido.c,69 :: 		if (oldstate && Button(&PORTC, 0, 1, 0)) {   // Detect one-to-zero transition
	BTFSS      _oldstate+0, BitPos(_oldstate+0)
	GOTO       L_main12
	MOVLW      PORTC+0
	MOVWF      FARG_Button_port+0
	CLRF       FARG_Button_pin+0
	MOVLW      1
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main12
L__main24:
;test_barrido.c,70 :: 		display[0]+=1;
	INCF       _display+0, 1
;test_barrido.c,71 :: 		display[1]+=1;
	INCF       _display+1, 1
;test_barrido.c,72 :: 		display[2]+=1;
	INCF       _display+2, 1
;test_barrido.c,73 :: 		display[3]+=1;
	INCF       _display+3, 1
;test_barrido.c,74 :: 		oldstate = 0;                              // Update flag
	BCF        _oldstate+0, BitPos(_oldstate+0)
;test_barrido.c,75 :: 		}
L_main12:
;test_barrido.c,76 :: 		if (Button(&PORTC, 1, 1, 1)) {               // Detect logical one
	MOVLW      PORTC+0
	MOVWF      FARG_Button_port+0
	MOVLW      1
	MOVWF      FARG_Button_pin+0
	MOVLW      1
	MOVWF      FARG_Button_time_ms+0
	MOVLW      1
	MOVWF      FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main13
;test_barrido.c,77 :: 		oldstate2 = 1;                              // Update flag
	BSF        _oldstate2+0, BitPos(_oldstate2+0)
;test_barrido.c,78 :: 		}
L_main13:
;test_barrido.c,79 :: 		if (oldstate && Button(&PORTC, 1, 1, 0)) {   // Detect one-to-zero transition
	BTFSS      _oldstate+0, BitPos(_oldstate+0)
	GOTO       L_main16
	MOVLW      PORTC+0
	MOVWF      FARG_Button_port+0
	MOVLW      1
	MOVWF      FARG_Button_pin+0
	MOVLW      1
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main16
L__main23:
;test_barrido.c,80 :: 		if (condicion_contar == 80){
	MOVLW      0
	XORWF      _condicion_contar+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main27
	MOVLW      80
	XORWF      _condicion_contar+0, 0
L__main27:
	BTFSS      STATUS+0, 2
	GOTO       L_main17
;test_barrido.c,81 :: 		condicion_contar = 40;
	MOVLW      40
	MOVWF      _condicion_contar+0
	MOVLW      0
	MOVWF      _condicion_contar+1
;test_barrido.c,82 :: 		}  else {
	GOTO       L_main18
L_main17:
;test_barrido.c,83 :: 		condicion_contar = 80;
	MOVLW      80
	MOVWF      _condicion_contar+0
	MOVLW      0
	MOVWF      _condicion_contar+1
;test_barrido.c,84 :: 		}
L_main18:
;test_barrido.c,85 :: 		oldstate2 = 0;                              // Update flag
	BCF        _oldstate2+0, BitPos(_oldstate2+0)
;test_barrido.c,86 :: 		}
L_main16:
;test_barrido.c,87 :: 		contador++;
	INCF       _contador+0, 1
	BTFSC      STATUS+0, 2
	INCF       _contador+1, 1
;test_barrido.c,88 :: 		if (contador >= condicion_contar) {
	MOVF       _condicion_contar+1, 0
	SUBWF      _contador+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main28
	MOVF       _condicion_contar+0, 0
	SUBWF      _contador+0, 0
L__main28:
	BTFSS      STATUS+0, 0
	GOTO       L_main19
;test_barrido.c,89 :: 		contador=0;
	CLRF       _contador+0
	CLRF       _contador+1
;test_barrido.c,90 :: 		}
L_main19:
;test_barrido.c,91 :: 		if(contador <= 40){
	MOVF       _contador+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main29
	MOVF       _contador+0, 0
	SUBLW      40
L__main29:
	BTFSS      STATUS+0, 0
	GOTO       L_main20
;test_barrido.c,92 :: 		puntos = 0;
	BCF        _puntos+0, BitPos(_puntos+0)
;test_barrido.c,93 :: 		} else if(contador < 80){
	GOTO       L_main21
L_main20:
	MOVLW      0
	SUBWF      _contador+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main30
	MOVLW      80
	SUBWF      _contador+0, 0
L__main30:
	BTFSC      STATUS+0, 0
	GOTO       L_main22
;test_barrido.c,94 :: 		puntos = 1;
	BSF        _puntos+0, BitPos(_puntos+0)
;test_barrido.c,95 :: 		}
L_main22:
L_main21:
;test_barrido.c,96 :: 		}
	GOTO       L_main7
;test_barrido.c,97 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
