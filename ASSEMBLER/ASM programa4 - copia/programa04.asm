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

EXTERN DISPLAY,HEX2BCD

W			EQU 0		;EQUIVALENTE ACUMULADOR
F			EQU 1		;EQUIVALENTE REGISTRO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	DATOS DE USUARIO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

UDATA


___saveSTATUS	RES 1;	SALVA STATUS
___savePCLATH 	RES 1;	SALVA PCLATCH
___saveW		RES 1;	SALVA ACUMULADOR
auxiliar RES 1

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
banksel	auxiliar
clrf	auxiliar
	banksel	ANSELH
	clrf	ANSELH
	banksel TRISB
	clrf	TRISB
	bsf	TRISC,2			;ccp1 en RC2
	clrf	TRISD
	banksel PORTB
	clrf	PORTB
	clrf  	PORTC
	clrf	PORTD
	
;CONFIGURACIONES: 	CCP1CON P1M1 P1M0 DC1B1 DC1B0 CCP1M3 CCP1M2 CCP1M1 CCP1M0 
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
	bsf PIE1,TMR1IE
	BANKSEL T1CON
	movlw b'00000001'
	movwf T1CON
	

	movlw 0x00
	movwf	0x38   ;0x00 anodo comun

	movlw 0x08
	movwf	0x39	;puerto de datos  A->0x05 _ E->0x09

	movlw 0x06
	movwf	0x3A	;puerto de activacion

	movlw 0x80		
	movwf	0x3B	;posicion del punto en el puerto

	movlw 0x08		
	movwf	0x3C	;puerto del punto

	movlw 0x04		
	movwf	0x3D	;posicion del punto


	movlw 0x10
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

	BANKSEL CCPR1L

swapf	auxiliar,w
andlw	0xf0
movwf	0x43	;datos binarios alto H

	swapf	CCPR1H,w
	andlw	0x0f
	xorwf	0x43	;datos binarios alto L

swapf	CCPR1H,w
andlw	0xf0
movwf	0x44	;datos binarios bajo H

	swapf	CCPR1L,w
	andlw	0x0f
	xorwf	0x44	;datos binarios bajo L

swapf	CCPR1L,w
andlw	0xf0
movwf	0x45	;datos binarios bajo bajo H

	PAGESEL	HEX2BCD
	call 	HEX2BCD
	
	movf 	0x40,w
	andlw 	0x0F
	movwf	0x32
	
	swapf 	0x40,w
	andlw 	0x0F
	movwf	0x33
	
	movf 	0x41,w
	andlw	0x0F
	movwf	0x34

	swapf 	0x41,w
	andlw	0x0F
	movwf	0x35

	movf 	0x42,w
	andlw	0x0F
	movwf	0x36

;banksel	auxiliar
;movf 	auxiliar,w
;andlw	0x0F
;movwf	0x37

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

btfss	PIR1,TMR1IF
goto	$+9
bcf	PIR1,TMR1IF
banksel	auxiliar
incf	auxiliar

swapf	auxiliar,w
andlw	0xf0
movwf	0x43	;datos binarios alto H

goto	SALIDA

	bcf	PIR1,CCP1IF		;encerado de las banderas
	BANKSEL TMR1H
	clrf	TMR1H		;encerado del timer
	clrf	TMR1L
;banksel	auxiliar
;clrf	auxiliar	

;	bcf	PIR1,TMR1IF		;encerado de las banderas del timer 1

	;movf	CCPR1L,W	;solo capturo los 4 menos significativos
	;andlw	0x0F
	;movwf	0x35

	;swapf	CCPR1L,W	;cambia el mas signifi con el menos signif
	;andlw	0x0F
	;movwf	0x34


	;movf	CCPR1H,W
	;andlw	0x0F
	;movwf	0x33

	;swapf	CCPR1H,W
	;andlw	0x0F
	;movwf	0x32	

	
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