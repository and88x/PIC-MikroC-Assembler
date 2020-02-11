
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Ultrasonico.c,23 :: 		void interrupt() {
;Ultrasonico.c,24 :: 		if (TMR1IF_bit) {
	BTFSS      TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
	GOTO       L_interrupt0
;Ultrasonico.c,25 :: 		TMR1IF_bit=0;
	BCF        TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
;Ultrasonico.c,26 :: 		TMR1L = 0x65;
	MOVLW      101
	MOVWF      TMR1L+0
;Ultrasonico.c,27 :: 		TMR1H = 0x72;
	MOVLW      114
	MOVWF      TMR1H+0
;Ultrasonico.c,30 :: 		}
L_interrupt0:
;Ultrasonico.c,31 :: 		}
L_end_interrupt:
L__interrupt13:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;Ultrasonico.c,34 :: 		void main() {
;Ultrasonico.c,36 :: 		T1CON = 0b00001000;     //1:1 preescaler, oscilador interno
	MOVLW      8
	MOVWF      T1CON+0
;Ultrasonico.c,37 :: 		GIE_bit = 1;
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;Ultrasonico.c,38 :: 		PEIE_bit = 1;
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;Ultrasonico.c,39 :: 		PIE1.TMR1IE = 1;
	BSF        PIE1+0, 0
;Ultrasonico.c,40 :: 		TMR1L = 0x65;
	MOVLW      101
	MOVWF      TMR1L+0
;Ultrasonico.c,41 :: 		TMR1H = 0x72;
	MOVLW      114
	MOVWF      TMR1H+0
;Ultrasonico.c,46 :: 		TRISB6_bit = 0;
	BCF        TRISB6_bit+0, BitPos(TRISB6_bit+0)
;Ultrasonico.c,47 :: 		RB6_bit = 0;
	BCF        RB6_bit+0, BitPos(RB6_bit+0)
;Ultrasonico.c,48 :: 		RB7_bit = 0;
	BCF        RB7_bit+0, BitPos(RB7_bit+0)
;Ultrasonico.c,49 :: 		TRISB7_bit = 1;
	BSF        TRISB7_bit+0, BitPos(TRISB7_bit+0)
;Ultrasonico.c,50 :: 		TRISB5_bit = 0;
	BCF        TRISB5_bit+0, BitPos(TRISB5_bit+0)
;Ultrasonico.c,51 :: 		RB5_bit = 0;
	BCF        RB5_bit+0, BitPos(RB5_bit+0)
;Ultrasonico.c,52 :: 		TRISB4_bit = 0;
	BCF        TRISB4_bit+0, BitPos(TRISB4_bit+0)
;Ultrasonico.c,53 :: 		RB4_bit = 0;
	BCF        RB4_bit+0, BitPos(RB4_bit+0)
;Ultrasonico.c,65 :: 		while (1) {
L_main1:
;Ultrasonico.c,66 :: 		RB6_bit = 1;
	BSF        RB6_bit+0, BitPos(RB6_bit+0)
;Ultrasonico.c,67 :: 		delay_us(15);
	MOVLW      24
	MOVWF      R13+0
L_main3:
	DECFSZ     R13+0, 1
	GOTO       L_main3
	NOP
	NOP
;Ultrasonico.c,68 :: 		RB6_bit = 0;   //generado un pulso de 10 us
	BCF        RB6_bit+0, BitPos(RB6_bit+0)
;Ultrasonico.c,69 :: 		TMR1ON_bit = 1;
	BSF        TMR1ON_bit+0, BitPos(TMR1ON_bit+0)
;Ultrasonico.c,70 :: 		while (!RB7_bit){
L_main4:
	BTFSC      RB7_bit+0, BitPos(RB7_bit+0)
	GOTO       L_main5
;Ultrasonico.c,71 :: 		}
	GOTO       L_main4
L_main5:
;Ultrasonico.c,73 :: 		while (RB7_bit && !TMR1IF){
L_main6:
	BTFSS      RB7_bit+0, BitPos(RB7_bit+0)
	GOTO       L_main7
L__main11:
;Ultrasonico.c,74 :: 		}
	GOTO       L_main6
L_main7:
;Ultrasonico.c,75 :: 		TMR1ON_bit = 0;
	BCF        TMR1ON_bit+0, BitPos(TMR1ON_bit+0)
;Ultrasonico.c,76 :: 		RB4_bit = 1;
	BSF        RB4_bit+0, BitPos(RB4_bit+0)
;Ultrasonico.c,77 :: 		contador = TMR1H;
	MOVF       TMR1H+0, 0
	MOVWF      _contador+0
	CLRF       _contador+1
;Ultrasonico.c,78 :: 		contador = contador << 8;
	MOVF       _contador+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       R0+0, 0
	MOVWF      _contador+0
	MOVF       R0+1, 0
	MOVWF      _contador+1
;Ultrasonico.c,79 :: 		contador += TMR1L;
	MOVF       TMR1L+0, 0
	ADDWF      R0+0, 1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVF       R0+0, 0
	MOVWF      _contador+0
	MOVF       R0+1, 0
	MOVWF      _contador+1
;Ultrasonico.c,80 :: 		distancia = (contador-inicioTimer)*2/145;
	MOVLW      101
	SUBWF      R0+0, 0
	MOVWF      R3+0
	MOVLW      114
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      R0+1, 0
	MOVWF      R3+1
	MOVF       R3+0, 0
	MOVWF      R0+0
	MOVF       R3+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVLW      145
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      _distancia+0
	MOVF       R0+1, 0
	MOVWF      _distancia+1
;Ultrasonico.c,85 :: 		if (distancia <= 15 ){//&& distancia <= 100){
	MOVLW      128
	MOVWF      R2+0
	MOVLW      128
	XORWF      R0+1, 0
	SUBWF      R2+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main15
	MOVF       R0+0, 0
	SUBLW      15
L__main15:
	BTFSS      STATUS+0, 0
	GOTO       L_main10
;Ultrasonico.c,86 :: 		RB5_bit = 1;
	BSF        RB5_bit+0, BitPos(RB5_bit+0)
;Ultrasonico.c,89 :: 		}*/
L_main10:
;Ultrasonico.c,90 :: 		}
	GOTO       L_main1
;Ultrasonico.c,91 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
