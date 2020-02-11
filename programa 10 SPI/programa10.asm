
_main:

;programa10.c,8 :: 		void main() {
;programa10.c,13 :: 		ANSEL = 0X00;
	CLRF       ANSEL+0
;programa10.c,14 :: 		TRISA = 0XFF;
	MOVLW      255
	MOVWF      TRISA+0
;programa10.c,15 :: 		ANSELH=0X00;
	CLRF       ANSELH+0
;programa10.c,16 :: 		TRISE = 0X00;
	CLRF       TRISE+0
;programa10.c,17 :: 		TRISB = 0X00;
	CLRF       TRISB+0
;programa10.c,18 :: 		TRISD = 0XFF;
	MOVLW      255
	MOVWF      TRISD+0
;programa10.c,19 :: 		PORTB = 0X00;
	CLRF       PORTB+0
;programa10.c,21 :: 		Chip_Select = 1;                       // Deselecccionar la memoria
	BSF        RC7_bit+0, BitPos(RC7_bit+0)
;programa10.c,22 :: 		Chip_Select_Direction = 0;             // Set CS# pin as Output
	BCF        TRISC7_bit+0, BitPos(TRISC7_bit+0)
;programa10.c,23 :: 		SPI1_Init();
	CALL       _SPI1_Init+0
;programa10.c,25 :: 		Chip_Select = 1;                       // Seleccionar la memoria
	BSF        RC7_bit+0, BitPos(RC7_bit+0)
;programa10.c,26 :: 		while(1) //Bucle infinito.
L_main0:
;programa10.c,28 :: 		DIRECCION = ((PORTA)&0x0F)|0x00; //Captura de la dirección.
	MOVLW      15
	ANDWF      PORTA+0, 0
	MOVWF      main_DIRECCION_L0+0
;programa10.c,30 :: 		Chip_Select = 0;                       // Seleccionar la memoria
	BCF        RC7_bit+0, BitPos(RC7_bit+0)
;programa10.c,31 :: 		SPI1_Write(0b00000011);
	MOVLW      3
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;programa10.c,32 :: 		SPI1_Write(DIRECCION);
	MOVF       main_DIRECCION_L0+0, 0
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;programa10.c,33 :: 		DATO=SPI1_Read(0);
	CLRF       FARG_SPI1_Read_buffer+0
	CALL       _SPI1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_DATO_L0+0
;programa10.c,34 :: 		Chip_Select = 1;                       // Deselecccionar la memoria
	BSF        RC7_bit+0, BitPos(RC7_bit+0)
;programa10.c,36 :: 		PORTB = DATO;
	MOVF       R0+0, 0
	MOVWF      PORTB+0
;programa10.c,37 :: 		delay_ms(100); //Retardo de 100 ms para graficar.
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main2:
	DECFSZ     R13+0, 1
	GOTO       L_main2
	DECFSZ     R12+0, 1
	GOTO       L_main2
	DECFSZ     R11+0, 1
	GOTO       L_main2
	NOP
;programa10.c,39 :: 		if( Button( &PORTA, 4, 10, 0) )
	MOVLW      PORTA+0
	MOVWF      FARG_Button_port+0
	MOVLW      4
	MOVWF      FARG_Button_pin+0
	MOVLW      10
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main3
;programa10.c,41 :: 		DATO = ~PORTD; //Captura del valor del dato.
	COMF       PORTD+0, 0
	MOVWF      main_DATO_L0+0
;programa10.c,43 :: 		Chip_Select = 0;                       // Seleccionar la memoria
	BCF        RC7_bit+0, BitPos(RC7_bit+0)
;programa10.c,44 :: 		SPI1_Write(0b00000110);                //Habilita la escritura
	MOVLW      6
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;programa10.c,45 :: 		Chip_Select = 1;
	BSF        RC7_bit+0, BitPos(RC7_bit+0)
;programa10.c,48 :: 		Chip_Select = 0;                       // Seleccionar la memoria
	BCF        RC7_bit+0, BitPos(RC7_bit+0)
;programa10.c,49 :: 		SPI1_Write(0b00000010);
	MOVLW      2
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;programa10.c,50 :: 		SPI1_Write(DIRECCION);
	MOVF       main_DIRECCION_L0+0, 0
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;programa10.c,51 :: 		SPI1_Write(DATO);
	MOVF       main_DATO_L0+0, 0
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;programa10.c,52 :: 		Chip_Select = 1;                       // Deselecccionar la memoria
	BSF        RC7_bit+0, BitPos(RC7_bit+0)
;programa10.c,54 :: 		delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main4:
	DECFSZ     R13+0, 1
	GOTO       L_main4
	DECFSZ     R12+0, 1
	GOTO       L_main4
	NOP
	NOP
;programa10.c,56 :: 		}
L_main3:
;programa10.c,57 :: 		Chip_Select = 0;                       // Seleccionar la memoria
	BCF        RC7_bit+0, BitPos(RC7_bit+0)
;programa10.c,58 :: 		SPI1_Write(0b00000101);                   //Lee el status de la memoria
	MOVLW      5
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;programa10.c,59 :: 		ESTADO=SPI1_Read(0);
	CLRF       FARG_SPI1_Read_buffer+0
	CALL       _SPI1_Read+0
;programa10.c,60 :: 		PORTE=ESTADO;
	MOVF       R0+0, 0
	MOVWF      PORTE+0
;programa10.c,61 :: 		Chip_Select = 1;                       // Deselecccionar la memoria
	BSF        RC7_bit+0, BitPos(RC7_bit+0)
;programa10.c,62 :: 		}
	GOTO       L_main0
;programa10.c,64 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
