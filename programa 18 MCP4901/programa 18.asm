
_DAC_Output:

;programa 18.c,9 :: 		void DAC_Output(unsigned int valueDAC) {
;programa 18.c,12 :: 		Chip_Select = 0;                       // Seleccciona el DAC
	BCF         RC0_bit+0, BitPos(RC0_bit+0) 
;programa 18.c,15 :: 		temp = (valueDAC >> 8) & 0x0F;         // Guarda valueDAC[11..8] a temp[3..0]
	MOVF        FARG_DAC_Output_valueDAC+1, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       15
	ANDWF       R0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
;programa 18.c,16 :: 		temp |= 0x30;                          // Define la configuración del DAC, ver el datasheet del MCP4921
	MOVLW       48
	IORWF       FARG_SPI1_Write_data_+0, 1 
;programa 18.c,17 :: 		SPI1_Write(temp);                      // Envía el byte mas significativo por el SPI
	CALL        _SPI1_Write+0, 0
;programa 18.c,21 :: 		SPI1_Write(temp);                      // Envía el byte menos significativo por el SPI
	MOVF        FARG_DAC_Output_valueDAC+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;programa 18.c,23 :: 		Chip_Select = 1;                       // Deselecciona el DAC
	BSF         RC0_bit+0, BitPos(RC0_bit+0) 
;programa 18.c,24 :: 		despliegue=0;
	BCF         _despliegue+0, BitPos(_despliegue+0) 
;programa 18.c,25 :: 		}
L_end_DAC_Output:
	RETURN      0
; end of _DAC_Output

_interrupt:

;programa 18.c,27 :: 		interrupt() {
;programa 18.c,28 :: 		if(TMR1IF_bit){
	BTFSS       TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
	GOTO        L_interrupt0
;programa 18.c,29 :: 		TMR1IF_bit=0;
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;programa 18.c,30 :: 		RD1_bit=~RD1_bit;
	BTG         RD1_bit+0, BitPos(RD1_bit+0) 
;programa 18.c,31 :: 		}
L_interrupt0:
;programa 18.c,32 :: 		if(CCP2IF_bit){
	BTFSS       CCP2IF_bit+0, BitPos(CCP2IF_bit+0) 
	GOTO        L_interrupt1
;programa 18.c,33 :: 		CCP2IF_bit=0;
	BCF         CCP2IF_bit+0, BitPos(CCP2IF_bit+0) 
;programa 18.c,34 :: 		RD1_bit=1;
	BSF         RD1_bit+0, BitPos(RD1_bit+0) 
;programa 18.c,35 :: 		TMR1H=0;
	CLRF        TMR1H+0 
;programa 18.c,36 :: 		TMR1L=0;
	CLRF        TMR1L+0 
;programa 18.c,37 :: 		}
L_interrupt1:
;programa 18.c,38 :: 		if(ADIF_bit){
	BTFSS       ADIF_bit+0, BitPos(ADIF_bit+0) 
	GOTO        L_interrupt2
;programa 18.c,39 :: 		ADIF_bit=0;
	BCF         ADIF_bit+0, BitPos(ADIF_bit+0) 
;programa 18.c,40 :: 		*puntero=ADRESL;
	MOVFF       _puntero+0, FSR1
	MOVFF       _puntero+1, FSR1H
	MOVF        ADRESL+0, 0 
	MOVWF       POSTINC1+0 
;programa 18.c,41 :: 		*(puntero+1)=ADRESH;
	MOVLW       1
	ADDWF       _puntero+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      _puntero+1, 0 
	MOVWF       FSR1H 
	MOVF        ADRESH+0, 0 
	MOVWF       POSTINC1+0 
;programa 18.c,42 :: 		RD1_bit=0;
	BCF         RD1_bit+0, BitPos(RD1_bit+0) 
;programa 18.c,43 :: 		despliegue=1;
	BSF         _despliegue+0, BitPos(_despliegue+0) 
;programa 18.c,44 :: 		}
L_interrupt2:
;programa 18.c,45 :: 		}
L_end_interrupt:
L__interrupt8:
	RETFIE      1
; end of _interrupt

_main:

;programa 18.c,47 :: 		void main() {
;programa 18.c,48 :: 		TRISD=0X00;
	CLRF        TRISD+0 
;programa 18.c,49 :: 		PORTD=0x00;
	CLRF        PORTD+0 
;programa 18.c,50 :: 		Chip_Select=0;
	BCF         RC0_bit+0, BitPos(RC0_bit+0) 
;programa 18.c,51 :: 		Chip_Select_Direction=0;
	BCF         TRISC0_bit+0, BitPos(TRISC0_bit+0) 
;programa 18.c,54 :: 		RD16_T1CON_bit=1;     //Habilita el TIMER1 en timer de 16 bits
	BSF         RD16_T1CON_bit+0, BitPos(RD16_T1CON_bit+0) 
;programa 18.c,55 :: 		T1RUN_bit=1;    //
	BSF         T1RUN_bit+0, BitPos(T1RUN_bit+0) 
;programa 18.c,56 :: 		T1CKPS0_bit=0;
	BCF         T1CKPS0_bit+0, BitPos(T1CKPS0_bit+0) 
;programa 18.c,57 :: 		T1CKPS1_bit=0;
	BCF         T1CKPS1_bit+0, BitPos(T1CKPS1_bit+0) 
;programa 18.c,58 :: 		T1OSCEN_bit=0;  //Oscilador del Timer1 apagado
	BCF         T1OSCEN_bit+0, BitPos(T1OSCEN_bit+0) 
;programa 18.c,59 :: 		T1SYNC_bit=0;   //No interesa con TMR1CS=0
	BCF         T1SYNC_bit+0, BitPos(T1SYNC_bit+0) 
;programa 18.c,60 :: 		TMR1CS_bit=0;   //FOSC/4
	BCF         TMR1CS_bit+0, BitPos(TMR1CS_bit+0) 
;programa 18.c,61 :: 		TMR1ON_bit=1;   //Encendido del Timer
	BSF         TMR1ON_bit+0, BitPos(TMR1ON_bit+0) 
;programa 18.c,64 :: 		T3CCP2_bit=0;  // Timer 1 es la fuente de reloj para los  modulos CCP
	BCF         T3CCP2_bit+0, BitPos(T3CCP2_bit+0) 
;programa 18.c,65 :: 		T3CCP1_bit=0;  //
	BCF         T3CCP1_bit+0, BitPos(T3CCP1_bit+0) 
;programa 18.c,69 :: 		CCP2CON= 0X0B; //Dispara del ADC
	MOVLW       11
	MOVWF       CCP2CON+0 
;programa 18.c,70 :: 		CCPR2H=0x13;
	MOVLW       19
	MOVWF       CCPR2H+0 
;programa 18.c,71 :: 		CCPR2L=0x88;
	MOVLW       136
	MOVWF       CCPR2L+0 
;programa 18.c,74 :: 		ADCON0=0x01;
	MOVLW       1
	MOVWF       ADCON0+0 
;programa 18.c,75 :: 		ADCON1=0x00;
	CLRF        ADCON1+0 
;programa 18.c,77 :: 		ADCON2=0b10111110;
	MOVLW       190
	MOVWF       ADCON2+0 
;programa 18.c,82 :: 		GIE_bit=1;
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;programa 18.c,83 :: 		PEIE_bit=1;
	BSF         PEIE_bit+0, BitPos(PEIE_bit+0) 
;programa 18.c,84 :: 		TMR1IE_bit=1;
	BSF         TMR1IE_bit+0, BitPos(TMR1IE_bit+0) 
;programa 18.c,85 :: 		CCP2IE_bit=1;
	BSF         CCP2IE_bit+0, BitPos(CCP2IE_bit+0) 
;programa 18.c,86 :: 		ADIE_bit=1;
	BSF         ADIE_bit+0, BitPos(ADIE_bit+0) 
;programa 18.c,88 :: 		TMR1IF_bit=0;
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;programa 18.c,90 :: 		puntero=&value;
	MOVLW       _value+0
	MOVWF       _puntero+0 
	MOVLW       hi_addr(_value+0)
	MOVWF       _puntero+1 
;programa 18.c,91 :: 		SPI1_Init();
	CALL        _SPI1_Init+0, 0
;programa 18.c,92 :: 		while(1){
L_main3:
;programa 18.c,93 :: 		if(despliegue){
	BTFSS       _despliegue+0, BitPos(_despliegue+0) 
	GOTO        L_main5
;programa 18.c,95 :: 		despliegue=0;
	BCF         _despliegue+0, BitPos(_despliegue+0) 
;programa 18.c,96 :: 		}
L_main5:
;programa 18.c,97 :: 		}
	GOTO        L_main3
;programa 18.c,99 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
