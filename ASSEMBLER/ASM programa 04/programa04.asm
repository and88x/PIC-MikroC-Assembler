;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;NOMBRE:
;DESCRIPCION DEL PROGRAMA:
;
;
;
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				INCLUDE <p16f887.inc>

__CONFIG    _CONFIG1,_FOSC_INTRC_NOCLKOUT&_WDTE_OFF&_PWRTE_OFF&_MCLRE_ON
__CONFIG    _CONFIG2,_BOR40V

EXTERN DISPLAY
EXTERN	HEX2BCD

W			EQU 0		;EQUIVALENTE ACUMULADOR
F			EQU 1		;EQUIVALENTE REGISTRO
display1	EQU 0x30	;posición de memoria para direccionar el display.
display2	EQU 0x31
display3	EQU 0x32
display4	EQU 0x33
display5	EQU 0x34
display6	EQU 0x35
display7	EQU 0x36
display8	EQU 0x37
decena_unidad		EQU	0x40	;registros decimales
unidadmil_centena	EQU	0x41
decenamil			EQU	0x42
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	DATOS DE USUARIO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

UDATA


___saveSTATUS	RES 1;	SALVA STATUS
___savePCLATH 	RES 1;	SALVA PCLATCH
___saveW		RES 1;	SALVA ACUMULADOR
;AUXILIAR RES 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	VECTOR DE RESET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
VEC_RESET	CODE 0X0
PAGESEL	INICIO
goto	INICIO		;Etiqueta de inicio del programa

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	VECTOR DE INTERRUPCION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
VEC_INT	CODE 0X04
PAGESEL	INTERRUPCION
			goto	INTERRUPCION		;Etiqueta de inicio del programa


CODE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       PROGRAMA PRINCIPAL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



INICIO:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       CONFIGURACIONES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	banksel	ANSELH
	clrf	ANSELH
	banksel TRISB
	clrf	TRISB
	bsf	TRISC,2
	clrf	TRISD
	banksel PORTB
	clrf	PORTB
	clrf  	PORTC
	clrf	PORTD
	
;coNFIGURACIONES: 	CCP1CON P1M1 P1M0 DC1B1 DC1B0 CCP1M3 CCP1M2 CCP1M1 CCP1M0 
;					CM2CON1 T1GSS
;					INTCON GIE PEIE
;					PIE1 CCP1IE TMR1IE 
;					PIR1 CCP1IF  TMR1IF 
;					T1CON T1GINV TMR1GE T1CKPS1 T1CKPS0 T1OSCEN T1SYNC TMR1CS TMR1ON
;					TRISC TRISC2 TRISC1 

	BANKSEL CCP1CON
	movlw b'00000100'
	movwf	CCP1CON
	bsf	INTCON,GIE
	bsf	INTCON,PEIE
	
	BANKSEL PIE1
	bsf PIE1,CCP1IE
	BANKSEL T1CON
	movlw b'00000001'
	movwf T1CON
	

	movlw 0x00
	movwf	0x38

	movlw 0x08
	movwf	0x39

	movlw 0x06
	movwf	0x3A

	movlw 0x06
	movwf	0x3B

	movlw 0x10		;para no mostrar nada
	movwf	0x30

	movlw 0x10
	movwf	0x31

	movlw 0x10
	movwf	0x32

	movlw 0x10
	movwf	0x33

	movlw 0x10
	movwf	0x34

	movlw 0x10
	movwf	0x35

	movlw 0x10
	movwf	0x36

	movlw 0x10
	movwf	0x37

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       BUCLE PRINCIPAL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

bucle:
	PAGESEL	HEX2BCD
	call	HEX2BCD

swapf	decena_unidad,w
andlw	0x0f
movwf	display4
movfw	decena_unidad
andlw	0x0f
movwf	display3

swapf	unidadmil_centena,w
andlw	0x0f
movwf	display6
movfw	unidadmil_centena
andlw	0x0f
movwf	display5

swapf	decenamil,w
andlw	0x0f
movwf	display7

	PAGESEL	DISPLAY
	call	DISPLAY


         goto bucle       

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       INTERRUPCIONES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INTERRUPCION:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Rutina de salvatage del estado de operación del microcontrolador antes de la llamada a interrupción
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


        movwf      ___saveW
        swapf      STATUS,W
        clrf       STATUS
        movwf      ___saveSTATUS
        movf       PCLATH,W
        movwf      ___savePCLATH
        clrf       PCLATH

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Atención de la interrupción, 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	BANKSEL PIR1

	bcf	PIR1,CCP1IF
	BANKSEL TMR1H
	clrf	TMR1H
	clrf	TMR1L
 
	BANKSEL CCPR1L
	movf	CCPR1L,W
	banksel	0x44
	movwf	0x44

;	swapf	CCPR1L,W	;intercambia entre el mas y menos significativo
;	andlw	0x0F
;	movwf	0x34

	BANKSEL CCPR1H
	movf	CCPR1H,W
	banksel	0x43
	movwf	0x43

;	swapf	CCPR1H,W
;	andlw	0x0F
;	movwf	0x32	

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Rutina de recuperación del estado de operación del microcontrolador antes del retorno desde la interrupción
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SALIDA:
        movf       ___savePCLATH,W
        movwf      PCLATH
        swapf      ___saveSTATUS,W
        movwf      STATUS
        swapf      ___saveW,F
        swapf      ___saveW,W
        retfie

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       SUBRUTINAS LOCALES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       TABLAS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




		END