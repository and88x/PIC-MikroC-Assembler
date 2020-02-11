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

EXTERN	DISPLAY
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
milisegundos	RES	1
segundos	RES 1
minutos		RES	1
horas		RES	1

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

	BANKSEL PIE1
	bsf PIE1,CCP1IE
	BANKSEL T1CON
	movlw b'00000001'
	movwf T1CON

	BANKSEL CCPR1H
	movlw 0xc3
	movwf CCPR1H
	movlw 0x50
	movwf CCPR1L	;una interrupcion cada 50ms
	
	BANKSEL TMR1H
	clrf TMR1H
	clrf TMR1L

	BANKSEL CCP1CON
	movlw b'00001010'	;Compare mode, generate software interrupt on match 
	movwf	CCP1CON
	bsf	INTCON,GIE
	bsf	INTCON,PEIE

	movlw 0x00		;display de anodo comun
	movwf	0x38

	movlw 0x08		;digitos por el puerto d
	movwf	0x39

	movlw 0x06		;multiplexacion por el puerto b
	movwf	0x3A

;inicio en cero todos los digitos del display
	movlw 0x00
	movwf	0x30

	movlw 0x00
	movwf	0x31

	movlw 0x00
	movwf	0x32

	movlw 0x00
	movwf	0x33

	movlw 0x00
	movwf	0x34

	movlw 0x00
	movwf	0x35

	movlw 0x00
	movwf	0x36

	movlw 0x00
	movwf	0x37

	banksel	segundos
	clrf	segundos
	banksel	minutos
	clrf	minutos
	banksel	horas
	clrf	horas

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       BUCLE PRINCIPAL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

bucle:
banksel	segundos
movfw	segundos
banksel	0x43
movwf	0x44
clrf	0x43

	PAGESEL	HEX2BCD
	call	HEX2BCD

swapf	decena_unidad,w
andlw	0x0f
movwf	display4
movfw	decena_unidad
andlw	0x0f
movwf	display3

banksel	minutos
movfw	minutos
banksel	0x43
movwf	0x44
clrf	0x43

	PAGESEL	HEX2BCD
	call	HEX2BCD

swapf	decena_unidad,w
andlw	0x0f
movwf	display6
movfw	decena_unidad
andlw	0x0f
movwf	display5

banksel	horas
movfw	horas
banksel	0x43
movwf	0x44
clrf	0x43

	PAGESEL	HEX2BCD
	call	HEX2BCD

swapf	decena_unidad,w
andlw	0x0f
movwf	display8
movfw	decena_unidad
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
	clrf TMR1H
	clrf TMR1L

	BANKSEL milisegundos
	incf	milisegundos,f
	movlw	0x14	;14 veces 50ms = 1s
	xorwf	milisegundos,W
	btfss	STATUS,Z
	goto SALIDA
	clrf	milisegundos

	BANKSEL segundos
	incf	segundos,f
	movlw	0x3c
	xorwf	segundos,W
	btfss	STATUS,Z
	goto SALIDA
	clrf	segundos

	BANKSEL minutos
	incf	minutos,f
	movlw	0x3c
	xorwf	minutos,W
	btfss	STATUS,Z
	goto SALIDA
	clrf	minutos

	BANKSEL horas
	incf	horas,f
	movlw	0x18
	xorwf	horas,W
	btfss	STATUS,Z
	goto SALIDA
	clrf	horas

;	clrf	0x31
;	incf	0x32
;	movlw	0x0A
;	xorwf	0x32,W
;	btfss	STATUS,Z
;	goto SALIDA
;	clrf	0x32
;	incf	0x33
;	movlw	0x0A
;	xorwf	0x33,W
;	btfss	STATUS,Z
;	goto SALIDA
;	clrf	0x33
;	incf	0x34
;	movlw	0x06
;	xorwf	0x34,W
;	btfss	STATUS,Z
;	goto SALIDA
;	clrf	0x34	
;	incf	0x35
;	movlw	0x0A
;	xorwf	0x33,W
;	btfss	STATUS,Z
;	goto SALIDA
;	clrf	0x35
;	incf	0x36
;	movlw	0x06
;	xorwf	0x36,W
;	btfss	STATUS,Z
;	goto SALIDA
;	clrf	0x36

	
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