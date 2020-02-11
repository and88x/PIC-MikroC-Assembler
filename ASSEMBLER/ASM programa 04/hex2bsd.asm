;Libreria para convertir digitos hexadecimales a bsd, cada digito se almacena
;en un cuarteto de byte (2 digitos bcd por byte)
;el numero a transformar debe ser colocado en las posociones 0x43 la parte
;más significativa y en 0x44 la parte menos significativa del número 
;hexadecimal
;las respuestas de guardan en
;decena_unidad		EQU	0x40	;registros decimales
;unidadmil_centena	EQU	0x41
;decenamil			EQU	0x42


	LIST P = 16F887 ;Indicamos el modelo de PIC a utilizar
	INCLUDE <p16f887.inc>

GLOBAL	HEX2BCD

bcd10	EQU	0x40	;registros decimales
bcd32	EQU	0x41
bcd54	EQU	0x42
hexH	EQU	0x43	;registro a transformar
hexL	EQU	0x44

UDATA
contador	RES	1	;detiene el algoritmo

CODE
HEX2BCD:
	movlw	.19	;numero para detener el algoritmo
	banksel	contador
	movwf	contador
	clrf	bcd10	;inicio en cero los registros decimales
	clrf	bcd32
	clrf	bcd54
Paso_2:
;Colocar el bit más significativo del registro binario en la 
;posición del bit menos significativo del registro decimal
	banksel	hexH
	btfss	hexH,7
	goto	$+2
	goto	$+3
	bcf		bcd10,0
	goto	$+2
	bsf		bcd10,0

;Revisar para cada digito del registro decimal si excede el 
;número cuatro (0100), es decir, es igual o mayor a cinco, 
;de ser así, le sumaremos tres (0011), en caso contrario, no hacer nada
	swapf	bcd10,f	;para no afectar con acarreos a la parte baja
	movlw	bcd10
	movwf	FSR
	call	Paso3
	swapf	bcd10,f	;para regresar al numero original
	call	Paso3
;segundo registro
	incf	FSR
	swapf	INDF,f	;para no afectar con acarreos a la parte baja
	call	Paso3
	swapf	INDF,f	;para regresar al numero original
	call	Paso3
;tercer registro
	incf	FSR
	swapf	INDF,f	;para no afectar con acarreos a la parte baja
	call	Paso3
	swapf	INDF,f	;para regresar al numero original
	call	Paso3

;Realizar un corrimiento a la izquierda, sin importar el bit que
;obtengamos a la derecha pues luego se llenará con la siguiente 
;iteración. Despreciar el bit excedente a la izquierda. Repetir 
;desde el paso 2 el número de bits del registro binario menos un veces.
;rotar numero hexadecimal
	rlf		hexH,f
	;bcf		hexH,0
	btfss	hexL,7
	goto	$+2
	goto	$+3
	bcf		hexH,0
	goto	$+2
	bsf		hexH,0
	rlf		hexL,f

;rotar numero decimal
	rlf		bcd54,f
	;bcf		bcd4,0
	btfss	bcd32,7
	goto	$+2
	goto	$+3
	bcf		bcd54,0
	goto	$+2
	bsf		bcd54,0

	rlf		bcd32,f
	;bcf		bcd32,0
	btfss	bcd10,7
	goto	$+2
	goto	$+3
	bcf		bcd32,0
	goto	$+2
	bsf		bcd32,0

	rlf		bcd10,f
;Realizar el paso 2 nuevamente
	banksel	contador
	decf	contador,f
	btfss	STATUS,Z
	goto	Paso_2
;paso 2 extra
	btfss	hexH,7
	goto	$+2
	goto	$+3
	bcf		bcd10,0
	goto	$+2
	bsf		bcd10,0
	return

Paso3:
	movfw	INDF
	andlw	0xf0
	addlw	0xB0	
	btfss	STATUS,C	;si el carrier es 1 se suma 3
	goto	$+3
	movlw	0x30
	addwf	INDF,f
	return

end
