; Librería para manejo de un grupo de display de 7 segmentos
; el dígito mas significativo hay que colocar en la dirección 0x30 y el menos significativo en la dirección 0x37
;



	LIST P = 16F887 ;Indicamos el modelo de PIC a utilizar
	INCLUDE <p16f887.inc>


; Definición de variables
GLOBAL DISPLAY


display1	EQU 0x30	;posición de memoria donde se encuentran las posiciones de memoria a desplegar.
display2	EQU 0x31
display3	EQU 0x32
display4	EQU 0x33
display5	EQU 0x34
display6	EQU 0x35
display7	EQU 0x36
display8	EQU 0x37
tipo	EQU	0X38	;Tipo de display
puerto_datos EQU 0X39	;Dirección del puerto de datos del display
puerto_habil EQU 0X3A	;Dirección del puerto de los habilitadores
puntopos EQU 0x3B	;posicion en el puesto del punto
punto EQU 0X3C	;Dirección del puerto de punto
pospunto EQU 0x3D  ;posicion del punto donde el pin sea 1



UDATA

indice RES 1
digito RES 1
barrido RES 1	; Para efectuar el barrido del display


CODE


DISPLAY:
	banksel	barrido
	movlw 0x80
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
 
	banksel	indice   
	movf	indice,W
	movwf	FSR
	movf INDF,w 	
	call Tabla 		
	banksel	digito
	movwf digito
	movf puerto_datos,W
	movwf FSR
	movf digito,W
	movwf INDF


	btfsc	tipo,0
	comf INDF,F
;***********enviar dato punto***********
	banksel	pospunto
	bcf	STATUS,Z 	
	movf pospunto,W 	
	xorwf barrido,W		;ve si tiene que mostrar el punto
	btfss STATUS,Z 	
	goto $+3
	movf puntopos,w
	;xorlw	0xff 
	goto $+2
	movlw	0x00	;0x00 cuando esta haciendo xor	
	banksel	digito
	clrf digito
	movwf digito
	movf punto,W
	movwf FSR
	movf digito,W
	xorwf INDF,f		;xor cuando esta en el mismo puerto que los datos

 	btfsc	tipo,0
	comf INDF,F


	banksel	barrido
	movf puerto_habil,W
	movwf FSR
	btfss	tipo,0
	goto $+3
	comf  barrido,W
	goto $+2
	movf  barrido,W


	movwf INDF
 	rrf	barrido,F
	banksel	indice
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
	retlw 0x88
	retlw 0x83
	retlw 0xc6
	retlw 0xA1
	retlw 0x86
	retlw 0x8e
	retlw 0xFF 


	END