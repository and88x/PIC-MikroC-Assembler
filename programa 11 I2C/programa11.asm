
_main:

;programa11.c,1 :: 		void main( void )
;programa11.c,7 :: 		ANSEL=0X00;
	CLRF       ANSEL+0
;programa11.c,8 :: 		TRISA=0b00101111;
	MOVLW      47
	MOVWF      TRISA+0
;programa11.c,9 :: 		ANSELH=0X00;
	CLRF       ANSELH+0
;programa11.c,10 :: 		TRISE = 7;
	MOVLW      7
	MOVWF      TRISE+0
;programa11.c,11 :: 		TRISB = 0;
	CLRF       TRISB+0
;programa11.c,12 :: 		PORTB = 0;
	CLRF       PORTB+0
;programa11.c,14 :: 		I2C1_Init(100000);
	MOVLW      10
	MOVWF      SSPADD+0
	CALL       _I2C1_Init+0
;programa11.c,15 :: 		while(1) //Bucle infinito.
L_main0:
;programa11.c,17 :: 		DIRECCION = (~PORTA)&0x0F; //Captura de la dirección.
	COMF       PORTA+0, 0
	MOVWF      main_DIRECCION_L0+0
	MOVLW      15
	ANDWF      main_DIRECCION_L0+0, 1
;programa11.c,19 :: 		I2C1_Start();
	CALL       _I2C1_Start+0
;programa11.c,20 :: 		I2C1_Wr(0b10100000);
	MOVLW      160
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;programa11.c,21 :: 		I2C1_Wr(DIRECCION);
	MOVF       main_DIRECCION_L0+0, 0
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;programa11.c,22 :: 		I2C1_Repeated_Start();
	CALL       _I2C1_Repeated_Start+0
;programa11.c,23 :: 		I2C1_Wr(0b10100001);
	MOVLW      161
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;programa11.c,24 :: 		DATO=I2C1_Rd(0);
	CLRF       FARG_I2C1_Rd_ack+0
	CALL       _I2C1_Rd+0
	MOVF       R0+0, 0
	MOVWF      main_DATO_L0+0
;programa11.c,25 :: 		I2C1_Stop();
	CALL       _I2C1_Stop+0
;programa11.c,27 :: 		PORTB = DATO;
	MOVF       main_DATO_L0+0, 0
	MOVWF      PORTB+0
;programa11.c,28 :: 		delay_ms(100); //Retardo de 100 ms para graficar.
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main2:
	DECFSZ     R13+0, 1
	GOTO       L_main2
	DECFSZ     R12+0, 1
	GOTO       L_main2
	NOP
	NOP
;programa11.c,30 :: 		if( Button( &PORTA, 5, 10, 0) )
	MOVLW      PORTA+0
	MOVWF      FARG_Button_port+0
	MOVLW      5
	MOVWF      FARG_Button_pin+0
	MOVLW      10
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main3
;programa11.c,32 :: 		DATO = ~PORTD; //Captura del valor del dato.
	COMF       PORTD+0, 0
	MOVWF      main_DATO_L0+0
;programa11.c,34 :: 		I2C1_Start();
	CALL       _I2C1_Start+0
;programa11.c,35 :: 		I2C1_Wr(0b10100000);
	MOVLW      160
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;programa11.c,36 :: 		I2C1_Wr(DIRECCION);
	MOVF       main_DIRECCION_L0+0, 0
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;programa11.c,37 :: 		I2C1_Wr(DATO);
	MOVF       main_DATO_L0+0, 0
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;programa11.c,38 :: 		I2C1_Stop();
	CALL       _I2C1_Stop+0
;programa11.c,40 :: 		delay_ms(50);
	MOVLW      65
	MOVWF      R12+0
	MOVLW      238
	MOVWF      R13+0
L_main4:
	DECFSZ     R13+0, 1
	GOTO       L_main4
	DECFSZ     R12+0, 1
	GOTO       L_main4
	NOP
;programa11.c,41 :: 		}
L_main3:
;programa11.c,42 :: 		}
	GOTO       L_main0
;programa11.c,43 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
