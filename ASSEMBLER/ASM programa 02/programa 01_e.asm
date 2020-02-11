	LIST P = 16F887 ;Indicamos el modelo de PIC a utilizar
	INCLUDE <p16f887.inc>


; Definición de variables


indice EQU 0X20
digito EQU 0x21	
barrido EQU 0X22	; Para efectuar el barrido del display


display	EQU 0x30	;posición de memoria donde se encuentran las posiciones de memoria a desplegar.
tipo	EQU	0X38	;Tipo de display
puerto_datos EQU 0X39	;Dirección del puerto de datos del display
puerto_habil EQU 0X3A	;Dirección del puerto de los habilitadores



	ORG 0X00 		; Vector de reset
	goto inicio 	; 

	ORG 0X05		; Se salta el vector de interrupción
inicio: 
; ************************ Inicialización de variables *************************
    bsf STATUS,RP0
    bsf STATUS,RP1
	clrf ANSELH
    bcf STATUS,RP1 	
	clrf TRISB		
	clrf TRISC		
	bcf STATUS,RP0 	
	clrf PORTB 		
	clrf PORTC
	clrw 			

	movlw 0xFF
	movwf	tipo

	movlw 0x06
	movwf	puerto_datos

	movlw 0x07
	movwf	puerto_habil

	movlw 0x00
	movwf	0x30

	movlw 0x01
	movwf	0x31

	movlw 0x02
	movwf	0x32

	movlw 0x03
	movwf	0x33

	movlw 0x04
	movwf	0x34

	movlw 0x05
	movwf	0x35
	

; ************************* Cuerpo Principal **************************

CICLO:

	call Despliegue

	
	goto CICLO


Despliegue:
	movlw 0x01
	movwf barrido
	movlw	0x30
	movwf	indice


Siguiente: 
	movf puerto_habil,W
	movwf FSR

	btfss	tipo,0
	goto $+4
	movlw 0xFF
	movwf INDF
	goto $+2	
 	clrf INDF
    
	movf	indice,W
	movwf	FSR
	movf INDF,w 	
	call Tabla 		
	movwf digito
	movf puerto_datos,W
	movwf FSR
	movf digito,W
	movwf INDF


	btfsc	tipo,0
	comf INDF,F

	movf puerto_habil,W
	movwf FSR
	btfss	tipo,0
	goto $+3
	comf  barrido,W
	goto $+2
	movf  barrido,W


	movwf INDF
 	rlf	barrido,F
	incf indice,F 	
	movf indice,W 	
	xorlw 0x38 		
	btfsc STATUS,Z 	
	return 	
	goto Siguiente 	


	



Tabla:
	addwf PCL,f 	
					
	retlw 0xC0
	retlw 0xF9
	retlw 0xA4
	retlw 0xB0
	retlw 0x99
	retlw 0x92
	retlw 0x82
	retlw 0xf8
	retlw 0x80
	retlw 0x90
	retlw 0xFF 

	END