
_main:

;programa16.c,1 :: 		void main() {
;programa16.c,3 :: 		PORTB = 0;                 // Valor inicial del puerto PORTB
	CLRF        PORTB+0 
;programa16.c,4 :: 		TRISB = 0;                 // Todos los pines del puerto PORTB se configuran
	CLRF        TRISB+0 
;programa16.c,7 :: 		PORTD = 0;                 // Valor inicial del puerto PORTB
	CLRF        PORTD+0 
;programa16.c,8 :: 		TRISD = 0;                 // Todos los pines del puerto PORTD se configuran
	CLRF        TRISD+0 
;programa16.c,11 :: 		TRISA = 0xFF;              // Todos los pines del puerto PORTA se configuran
	MOVLW       255
	MOVWF       TRISA+0 
;programa16.c,14 :: 		ADCON1= 0X0E;
	MOVLW       14
	MOVWF       ADCON1+0 
;programa16.c,15 :: 		PORTD = EEPROM_Read(5);    // Leer la memoria EEPROM en la dirección 5
	MOVLW       5
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       PORTD+0 
;programa16.c,17 :: 		do {
L_main0:
;programa16.c,18 :: 		PORTB = PORTB++;         // Incrementar el puerto PORTB en 1
	MOVF        PORTB+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       PORTB+0 
;programa16.c,19 :: 		Delay_ms(100);           // Tiempo de retardo de 100mS
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_main3:
	DECFSZ      R13, 1, 1
	BRA         L_main3
	DECFSZ      R12, 1, 1
	BRA         L_main3
	DECFSZ      R11, 1, 1
	BRA         L_main3
	NOP
;programa16.c,21 :: 		if (~PORTA.B2) EEPROM_Write(5,PORTB); // Si se pulsa el botón MEMO, guardar el puerto PORTB
	BTFSC       PORTA+0, 2 
	GOTO        L__main9
	BSF         4056, 0 
	GOTO        L__main10
L__main9:
	BCF         4056, 0 
L__main10:
	BTFSS       4056, 0 
	GOTO        L_main4
	MOVLW       5
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        PORTB+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
L_main4:
;programa16.c,23 :: 		PORTD = EEPROM_Read(5);  // Leer el dato escrito
	MOVLW       5
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       PORTD+0 
;programa16.c,25 :: 		do {}
L_main5:
;programa16.c,26 :: 		while (~PORTA.B2);      // Quedarse en este bucle hasta que el botón esté pulsado
	BTFSC       PORTA+0, 2 
	GOTO        L__main11
	BSF         4056, 0 
	GOTO        L__main12
L__main11:
	BCF         4056, 0 
L__main12:
	BTFSC       4056, 0 
	GOTO        L_main5
;programa16.c,29 :: 		while(1);                  // Bucle infinito
	GOTO        L_main0
;programa16.c,30 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
