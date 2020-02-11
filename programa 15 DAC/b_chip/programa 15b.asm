
_InitMain:

;programa 15b.c,8 :: 		void InitMain() {
;programa 15b.c,9 :: 		TRISB0_bit = 1;                        // Pone el pin RA0 como entrada
	BSF         TRISB0_bit+0, BitPos(TRISB0_bit+0) 
;programa 15b.c,10 :: 		TRISB1_bit = 1;                        // Pone el pin RA1 como entrada
	BSF         TRISB1_bit+0, BitPos(TRISB1_bit+0) 
;programa 15b.c,11 :: 		ADCON1=0x0F;
	MOVLW       15
	MOVWF       ADCON1+0 
;programa 15b.c,12 :: 		Chip_Select = 1;                       // Deseleciona el DAC
	BSF         RC0_bit+0, BitPos(RC0_bit+0) 
;programa 15b.c,13 :: 		Chip_Select_Direction = 0;             // Pone el pin CS# como salida
	BCF         TRISC0_bit+0, BitPos(TRISC0_bit+0) 
;programa 15b.c,14 :: 		NOT_RBPU_bit=0;                        // Habilita las resistencias de pull up
	BCF         NOT_RBPU_bit+0, BitPos(NOT_RBPU_bit+0) 
;programa 15b.c,15 :: 		SPI1_Init();                           // Inicializa el módulo SPI
	CALL        _SPI1_Init+0, 0
;programa 15b.c,16 :: 		}
L_end_InitMain:
	RETURN      0
; end of _InitMain

_DAC_Output:

;programa 15b.c,19 :: 		void DAC_Output(unsigned int valueDAC) {
;programa 15b.c,22 :: 		Chip_Select = 0;                       // Seleccciona el DAC
	BCF         RC0_bit+0, BitPos(RC0_bit+0) 
;programa 15b.c,25 :: 		temp = (valueDAC >> 8) & 0x0F;         // Guarda valueDAC[11..8] a temp[3..0]
	MOVF        FARG_DAC_Output_valueDAC+1, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       15
	ANDWF       R0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
;programa 15b.c,26 :: 		temp |= 0x30;                          // Define la configuración del DAC, ver el datasheet del MCP4921
	MOVLW       48
	IORWF       FARG_SPI1_Write_data_+0, 1 
;programa 15b.c,27 :: 		SPI1_Write(temp);                      // Envía el byte mas significativo por el SPI
	CALL        _SPI1_Write+0, 0
;programa 15b.c,31 :: 		SPI1_Write(temp);                      // Envía el byte menos significativo por el SPI
	MOVF        FARG_DAC_Output_valueDAC+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;programa 15b.c,33 :: 		Chip_Select = 1;                       // Deselecciona el DAC
	BSF         RC0_bit+0, BitPos(RC0_bit+0) 
;programa 15b.c,34 :: 		}
L_end_DAC_Output:
	RETURN      0
; end of _DAC_Output

_main:

;programa 15b.c,36 :: 		void main() {
;programa 15b.c,38 :: 		InitMain();                            // Realiza la inicializacion principal
	CALL        _InitMain+0, 0
;programa 15b.c,40 :: 		value = 2048;                          // Cuando el programa empieza, DAC posee
	MOVLW       0
	MOVWF       _value+0 
	MOVLW       8
	MOVWF       _value+1 
;programa 15b.c,43 :: 		while (1) {                             // Lazo  infinito
L_main0:
;programa 15b.c,45 :: 		if ((!RB0_bit) && (value < 4095)) {   // Si RA0 es precionado
	BTFSC       RB0_bit+0, BitPos(RB0_bit+0) 
	GOTO        L_main4
	MOVLW       15
	SUBWF       _value+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main15
	MOVLW       255
	SUBWF       _value+0, 0 
L__main15:
	BTFSC       STATUS+0, 0 
	GOTO        L_main4
L__main11:
;programa 15b.c,46 :: 		value++;                           //   incrementa el valor
	INFSNZ      _value+0, 1 
	INCF        _value+1, 1 
;programa 15b.c,47 :: 		}
	GOTO        L_main5
L_main4:
;programa 15b.c,49 :: 		if ((!RB1_bit) && (value > 0)) {    // If RA1 es precionado
	BTFSC       RB1_bit+0, BitPos(RB1_bit+0) 
	GOTO        L_main8
	MOVLW       0
	MOVWF       R0 
	MOVF        _value+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main16
	MOVF        _value+0, 0 
	SUBLW       0
L__main16:
	BTFSC       STATUS+0, 0 
	GOTO        L_main8
L__main10:
;programa 15b.c,50 :: 		value--;                         //   decrementa el valor
	MOVLW       1
	SUBWF       _value+0, 1 
	MOVLW       0
	SUBWFB      _value+1, 1 
;programa 15b.c,51 :: 		}
L_main8:
;programa 15b.c,52 :: 		}
L_main5:
;programa 15b.c,53 :: 		DAC_Output(value);                   // Envía el valor al DAC
	MOVF        _value+0, 0 
	MOVWF       FARG_DAC_Output_valueDAC+0 
	MOVF        _value+1, 0 
	MOVWF       FARG_DAC_Output_valueDAC+1 
	CALL        _DAC_Output+0, 0
;programa 15b.c,54 :: 		Delay_ms(1);
	MOVLW       3
	MOVWF       R12, 0
	MOVLW       151
	MOVWF       R13, 0
L_main9:
	DECFSZ      R13, 1, 1
	BRA         L_main9
	DECFSZ      R12, 1, 1
	BRA         L_main9
	NOP
	NOP
;programa 15b.c,55 :: 		}
	GOTO        L_main0
;programa 15b.c,56 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
