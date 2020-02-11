
_main:

;MyProject.c,8 :: 		void main() {
;MyProject.c,13 :: 		ANSEL = 0X00;
	CLRF       ANSEL+0
;MyProject.c,14 :: 		TRISA = 0XFF;
	MOVLW      255
	MOVWF      TRISA+0
;MyProject.c,15 :: 		ANSELH=0X00;
	CLRF       ANSELH+0
;MyProject.c,16 :: 		TRISE = 0X00;
	CLRF       TRISE+0
;MyProject.c,17 :: 		TRISB = 0X00;
	CLRF       TRISB+0
;MyProject.c,18 :: 		TRISD = 0XFF;
	MOVLW      255
	MOVWF      TRISD+0
;MyProject.c,19 :: 		PORTB = 0X00;
	CLRF       PORTB+0
;MyProject.c,21 :: 		Chip_Select = 1;                       // Deselecccionar la memoria
	BSF        RC7_bit+0, BitPos(RC7_bit+0)
;MyProject.c,22 :: 		Chip_Select_Direction = 0;             // Set CS# pin as Output
	BCF        TRISC7_bit+0, BitPos(TRISC7_bit+0)
;MyProject.c,23 :: 		SPI1_Init();
	CALL       _SPI1_Init+0
;MyProject.c,25 :: 		Chip_Select = 1;                       // Seleccionar la memoria
	BSF        RC7_bit+0, BitPos(RC7_bit+0)
;MyProject.c,26 :: 		while(1) //Bucle infinito.
L_main0:
;MyProject.c,28 :: 		DIRECCION = ((PORTA)&0x0F)|0x40; //Captura de la dirección.
	MOVLW      15
	ANDWF      PORTA+0, 0
	MOVWF      main_DIRECCION_L0+0
	BSF        main_DIRECCION_L0+0, 6
;MyProject.c,30 :: 		Chip_Select = 0;                       // Seleccionar la memoria
	BCF        RC7_bit+0, BitPos(RC7_bit+0)
;MyProject.c,31 :: 		SPI1_Write(0b00000011);
	MOVLW      3
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;MyProject.c,32 :: 		SPI1_Write(DIRECCION);
	MOVF       main_DIRECCION_L0+0, 0
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;MyProject.c,33 :: 		DATO=SPI1_Read(0);
	CLRF       FARG_SPI1_Read_buffer+0
	CALL       _SPI1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_DATO_L0+0
;MyProject.c,34 :: 		Chip_Select = 1;                       // Deselecccionar la memoria
	BSF        RC7_bit+0, BitPos(RC7_bit+0)
;MyProject.c,36 :: 		PORTB = DATO;
	MOVF       R0+0, 0
	MOVWF      PORTB+0
;MyProject.c,37 :: 		delay_ms(100); //Retardo de 100 ms para graficar.
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
;MyProject.c,39 :: 		if( Button( &PORTA, 4, 10, 0) )
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
;MyProject.c,41 :: 		DATO = ~PORTD; //Captura del valor del dato.
	COMF       PORTD+0, 0
	MOVWF      main_DATO_L0+0
;MyProject.c,43 :: 		Chip_Select = 0;                       // Seleccionar la memoria
	BCF        RC7_bit+0, BitPos(RC7_bit+0)
;MyProject.c,44 :: 		SPI1_Write(0b00000110);                //Habilita la escritura
	MOVLW      6
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;MyProject.c,45 :: 		Chip_Select = 1;
	BSF        RC7_bit+0, BitPos(RC7_bit+0)
;MyProject.c,48 :: 		Chip_Select = 0;                       // Seleccionar la memoria
	BCF        RC7_bit+0, BitPos(RC7_bit+0)
;MyProject.c,49 :: 		SPI1_Write(0b00000010);
	MOVLW      2
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;MyProject.c,50 :: 		SPI1_Write(DIRECCION);
	MOVF       main_DIRECCION_L0+0, 0
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;MyProject.c,51 :: 		SPI1_Write(DATO);
	MOVF       main_DATO_L0+0, 0
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;MyProject.c,52 :: 		Chip_Select = 1;                       // Deselecccionar la memoria
	BSF        RC7_bit+0, BitPos(RC7_bit+0)
;MyProject.c,54 :: 		delay_ms(50);
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
;MyProject.c,56 :: 		}
L_main3:
;MyProject.c,57 :: 		Chip_Select = 0;                       // Seleccionar la memoria
	BCF        RC7_bit+0, BitPos(RC7_bit+0)
;MyProject.c,58 :: 		SPI1_Write(0b00000101);                   //Lee el status de la memoria
	MOVLW      5
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;MyProject.c,59 :: 		ESTADO=SPI1_Read(0);
	CLRF       FARG_SPI1_Read_buffer+0
	CALL       _SPI1_Read+0
;MyProject.c,60 :: 		PORTE=ESTADO;
	MOVF       R0+0, 0
	MOVWF      PORTE+0
;MyProject.c,61 :: 		Chip_Select = 1;                       // Deselecccionar la memoria
	BSF        RC7_bit+0, BitPos(RC7_bit+0)
;MyProject.c,62 :: 		}
	GOTO       L_main0
;MyProject.c,64 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
