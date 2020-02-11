
_desplegar:

;Display_de_7_segmentos.c,9 :: 		void desplegar(void){
;Display_de_7_segmentos.c,10 :: 		barrido=0x01;
	MOVLW      1
	MOVWF      _barrido+0
;Display_de_7_segmentos.c,11 :: 		for (i=0;i<6;i++)
	CLRF       _i+0
L_desplegar0:
	MOVLW      6
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_desplegar1
;Display_de_7_segmentos.c,13 :: 		PORTC=0;
	CLRF       PORTC+0
;Display_de_7_segmentos.c,14 :: 		PORTB=TablaCA[display[i]];
	MOVF       _i+0, 0
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
	MOVWF      PORTB+0
;Display_de_7_segmentos.c,15 :: 		PORTC=barrido;
	MOVF       _barrido+0, 0
	MOVWF      PORTC+0
;Display_de_7_segmentos.c,16 :: 		barrido=barrido<<1;
	RLF        _barrido+0, 1
	BCF        _barrido+0, 0
;Display_de_7_segmentos.c,11 :: 		for (i=0;i<6;i++)
	INCF       _i+0, 1
;Display_de_7_segmentos.c,17 :: 		}
	GOTO       L_desplegar0
L_desplegar1:
;Display_de_7_segmentos.c,18 :: 		}
L_end_desplegar:
	RETURN
; end of _desplegar

_main:

;Display_de_7_segmentos.c,19 :: 		void main() {
;Display_de_7_segmentos.c,20 :: 		TRISB=0;
	CLRF       TRISB+0
;Display_de_7_segmentos.c,21 :: 		TRISC=0;
	CLRF       TRISC+0
;Display_de_7_segmentos.c,22 :: 		ANSELH=0;
	CLRF       ANSELH+0
;Display_de_7_segmentos.c,23 :: 		PORTB=0;
	CLRF       PORTB+0
;Display_de_7_segmentos.c,24 :: 		PORTC=0;
	CLRF       PORTC+0
;Display_de_7_segmentos.c,25 :: 		while(1){
L_main3:
;Display_de_7_segmentos.c,26 :: 		desplegar();
	CALL       _desplegar+0
;Display_de_7_segmentos.c,27 :: 		FloatToStr(ff1, txt);  // txt is "-374.2"
	MOVF       _ff1+0, 0
	MOVWF      FARG_FloatToStr_fnum+0
	MOVF       _ff1+1, 0
	MOVWF      FARG_FloatToStr_fnum+1
	MOVF       _ff1+2, 0
	MOVWF      FARG_FloatToStr_fnum+2
	MOVF       _ff1+3, 0
	MOVWF      FARG_FloatToStr_fnum+3
	MOVLW      _txt+0
	MOVWF      FARG_FloatToStr_str+0
	CALL       _FloatToStr+0
;Display_de_7_segmentos.c,28 :: 		}
	GOTO       L_main3
;Display_de_7_segmentos.c,29 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
