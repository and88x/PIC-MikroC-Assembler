
_DAC_Output:

;programa 18.c,18 :: 		void DAC_Output(unsigned int valueDAC) {
;programa 18.c,21 :: 		Chip_Select = 0;                       // Seleccciona el DAC
	BCF         RC0_bit+0, BitPos(RC0_bit+0) 
;programa 18.c,24 :: 		temp = (valueDAC >> 8) & 0x0F;         // Guarda valueDAC[11..8] a temp[3..0]
	MOVF        FARG_DAC_Output_valueDAC+1, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       15
	ANDWF       R0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
;programa 18.c,25 :: 		temp |= 0x30;                          // Define la configuración del DAC, ver el datasheet del MCP4921
	MOVLW       48
	IORWF       FARG_SPI1_Write_data_+0, 1 
;programa 18.c,26 :: 		SPI1_Write(temp);                      // Envía el byte mas significativo por el SPI
	CALL        _SPI1_Write+0, 0
;programa 18.c,30 :: 		SPI1_Write(temp);                      // Envía el byte menos significativo por el SPI
	MOVF        FARG_DAC_Output_valueDAC+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;programa 18.c,32 :: 		Chip_Select = 1;                       // Deselecciona el DAC
	BSF         RC0_bit+0, BitPos(RC0_bit+0) 
;programa 18.c,33 :: 		despliegue=0;
	BCF         _despliegue+0, BitPos(_despliegue+0) 
;programa 18.c,34 :: 		}
L_end_DAC_Output:
	RETURN      0
; end of _DAC_Output

_interrupt:

;programa 18.c,36 :: 		interrupt() {
;programa 18.c,37 :: 		if(TMR1IF_bit){
	BTFSS       TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
	GOTO        L_interrupt0
;programa 18.c,38 :: 		TMR1IF_bit=0;
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;programa 18.c,39 :: 		RD1_bit=~RD1_bit;
	BTG         RD1_bit+0, BitPos(RD1_bit+0) 
;programa 18.c,40 :: 		}
L_interrupt0:
;programa 18.c,41 :: 		if(CCP2IF_bit){
	BTFSS       CCP2IF_bit+0, BitPos(CCP2IF_bit+0) 
	GOTO        L_interrupt1
;programa 18.c,42 :: 		CCP2IF_bit=0;
	BCF         CCP2IF_bit+0, BitPos(CCP2IF_bit+0) 
;programa 18.c,43 :: 		RD1_bit=1;
	BSF         RD1_bit+0, BitPos(RD1_bit+0) 
;programa 18.c,44 :: 		TMR1H=0;
	CLRF        TMR1H+0 
;programa 18.c,45 :: 		TMR1L=0;
	CLRF        TMR1L+0 
;programa 18.c,46 :: 		}
L_interrupt1:
;programa 18.c,47 :: 		if(ADIF_bit){
	BTFSS       ADIF_bit+0, BitPos(ADIF_bit+0) 
	GOTO        L_interrupt2
;programa 18.c,48 :: 		ADIF_bit=0;
	BCF         ADIF_bit+0, BitPos(ADIF_bit+0) 
;programa 18.c,49 :: 		*puntero=ADRESL;
	MOVFF       _puntero+0, FSR1
	MOVFF       _puntero+1, FSR1H
	MOVF        ADRESL+0, 0 
	MOVWF       POSTINC1+0 
;programa 18.c,50 :: 		*(puntero+1)=ADRESH;
	MOVLW       1
	ADDWF       _puntero+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      _puntero+1, 0 
	MOVWF       FSR1H 
	MOVF        ADRESH+0, 0 
	MOVWF       POSTINC1+0 
;programa 18.c,52 :: 		x0[0] = (float)(value-512.0);
	MOVF        _value+0, 0 
	MOVWF       R0 
	MOVF        _value+1, 0 
	MOVWF       R1 
	CALL        _Word2Double+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       136
	MOVWF       R7 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _x0+0 
	MOVF        R1, 0 
	MOVWF       _x0+1 
	MOVF        R2, 0 
	MOVWF       _x0+2 
	MOVF        R3, 0 
	MOVWF       _x0+3 
;programa 18.c,54 :: 		y0[0] = x0[0]*0.145323883877042+x1[0]*0.290647767754085+x2[0]*0.145323883877042 + y1[0]*0.671029090774096
	MOVLW       201
	MOVWF       R4 
	MOVLW       207
	MOVWF       R5 
	MOVLW       20
	MOVWF       R6 
	MOVLW       124
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__interrupt+0 
	MOVF        R1, 0 
	MOVWF       FLOC__interrupt+1 
	MOVF        R2, 0 
	MOVWF       FLOC__interrupt+2 
	MOVF        R3, 0 
	MOVWF       FLOC__interrupt+3 
	MOVF        _x1+0, 0 
	MOVWF       R0 
	MOVF        _x1+1, 0 
	MOVWF       R1 
	MOVF        _x1+2, 0 
	MOVWF       R2 
	MOVF        _x1+3, 0 
	MOVWF       R3 
	MOVLW       201
	MOVWF       R4 
	MOVLW       207
	MOVWF       R5 
	MOVLW       20
	MOVWF       R6 
	MOVLW       125
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        FLOC__interrupt+0, 0 
	MOVWF       R4 
	MOVF        FLOC__interrupt+1, 0 
	MOVWF       R5 
	MOVF        FLOC__interrupt+2, 0 
	MOVWF       R6 
	MOVF        FLOC__interrupt+3, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__interrupt+0 
	MOVF        R1, 0 
	MOVWF       FLOC__interrupt+1 
	MOVF        R2, 0 
	MOVWF       FLOC__interrupt+2 
	MOVF        R3, 0 
	MOVWF       FLOC__interrupt+3 
	MOVF        _x2+0, 0 
	MOVWF       R0 
	MOVF        _x2+1, 0 
	MOVWF       R1 
	MOVF        _x2+2, 0 
	MOVWF       R2 
	MOVF        _x2+3, 0 
	MOVWF       R3 
	MOVLW       201
	MOVWF       R4 
	MOVLW       207
	MOVWF       R5 
	MOVLW       20
	MOVWF       R6 
	MOVLW       124
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        FLOC__interrupt+0, 0 
	MOVWF       R4 
	MOVF        FLOC__interrupt+1, 0 
	MOVWF       R5 
	MOVF        FLOC__interrupt+2, 0 
	MOVWF       R6 
	MOVF        FLOC__interrupt+3, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__interrupt+0 
	MOVF        R1, 0 
	MOVWF       FLOC__interrupt+1 
	MOVF        R2, 0 
	MOVWF       FLOC__interrupt+2 
	MOVF        R3, 0 
	MOVWF       FLOC__interrupt+3 
	MOVF        _y1+0, 0 
	MOVWF       R0 
	MOVF        _y1+1, 0 
	MOVWF       R1 
	MOVF        _y1+2, 0 
	MOVWF       R2 
	MOVF        _y1+3, 0 
	MOVWF       R3 
	MOVLW       144
	MOVWF       R4 
	MOVLW       200
	MOVWF       R5 
	MOVLW       43
	MOVWF       R6 
	MOVLW       126
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        FLOC__interrupt+0, 0 
	MOVWF       R4 
	MOVF        FLOC__interrupt+1, 0 
	MOVWF       R5 
	MOVF        FLOC__interrupt+2, 0 
	MOVWF       R6 
	MOVF        FLOC__interrupt+3, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__interrupt+0 
	MOVF        R1, 0 
	MOVWF       FLOC__interrupt+1 
	MOVF        R2, 0 
	MOVWF       FLOC__interrupt+2 
	MOVF        R3, 0 
	MOVWF       FLOC__interrupt+3 
	MOVF        _y2+0, 0 
	MOVWF       R0 
	MOVF        _y2+1, 0 
	MOVWF       R1 
	MOVF        _y2+2, 0 
	MOVWF       R2 
	MOVF        _y2+3, 0 
	MOVWF       R3 
	MOVLW       178
	MOVWF       R4 
	MOVLW       48
	MOVWF       R5 
	MOVLW       1
	MOVWF       R6 
	MOVLW       125
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
;programa 18.c,55 :: 		-y2[0]*0.252324626282266;
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVF        FLOC__interrupt+0, 0 
	MOVWF       R0 
	MOVF        FLOC__interrupt+1, 0 
	MOVWF       R1 
	MOVF        FLOC__interrupt+2, 0 
	MOVWF       R2 
	MOVF        FLOC__interrupt+3, 0 
	MOVWF       R3 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _y0+0 
	MOVF        R1, 0 
	MOVWF       _y0+1 
	MOVF        R2, 0 
	MOVWF       _y0+2 
	MOVF        R3, 0 
	MOVWF       _y0+3 
;programa 18.c,58 :: 		y2[0] = y1[0];
	MOVF        _y1+0, 0 
	MOVWF       _y2+0 
	MOVF        _y1+1, 0 
	MOVWF       _y2+1 
	MOVF        _y1+2, 0 
	MOVWF       _y2+2 
	MOVF        _y1+3, 0 
	MOVWF       _y2+3 
;programa 18.c,59 :: 		y1[0] = y0[0];
	MOVF        R0, 0 
	MOVWF       _y1+0 
	MOVF        R1, 0 
	MOVWF       _y1+1 
	MOVF        R2, 0 
	MOVWF       _y1+2 
	MOVF        R3, 0 
	MOVWF       _y1+3 
;programa 18.c,60 :: 		x2[0] = x1[0];
	MOVF        _x1+0, 0 
	MOVWF       _x2+0 
	MOVF        _x1+1, 0 
	MOVWF       _x2+1 
	MOVF        _x1+2, 0 
	MOVWF       _x2+2 
	MOVF        _x1+3, 0 
	MOVWF       _x2+3 
;programa 18.c,61 :: 		x1[0] = x0[0];
	MOVF        _x0+0, 0 
	MOVWF       _x1+0 
	MOVF        _x0+1, 0 
	MOVWF       _x1+1 
	MOVF        _x0+2, 0 
	MOVWF       _x1+2 
	MOVF        _x0+3, 0 
	MOVWF       _x1+3 
;programa 18.c,63 :: 		value = (unsigned int)(y0[0]+512);
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       136
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	CALL        _Double2Word+0, 0
	MOVF        R0, 0 
	MOVWF       _value+0 
	MOVF        R1, 0 
	MOVWF       _value+1 
;programa 18.c,65 :: 		if(value>aux_value)aux_value=value;
	MOVF        R1, 0 
	SUBWF       _aux_value+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt22
	MOVF        R0, 0 
	SUBWF       _aux_value+0, 0 
L__interrupt22:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt3
	MOVF        _value+0, 0 
	MOVWF       _aux_value+0 
	MOVF        _value+1, 0 
	MOVWF       _aux_value+1 
	GOTO        L_interrupt4
L_interrupt3:
;programa 18.c,67 :: 		aux_value=aux_value-10;
	MOVLW       10
	SUBWF       _aux_value+0, 0 
	MOVWF       R1 
	MOVLW       0
	SUBWFB      _aux_value+1, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       _aux_value+0 
	MOVF        R2, 0 
	MOVWF       _aux_value+1 
;programa 18.c,68 :: 		if (aux_value<0)aux_value=value;
	MOVLW       0
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt23
	MOVLW       0
	SUBWF       R1, 0 
L__interrupt23:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt5
	MOVF        _value+0, 0 
	MOVWF       _aux_value+0 
	MOVF        _value+1, 0 
	MOVWF       _aux_value+1 
L_interrupt5:
;programa 18.c,69 :: 		}
L_interrupt4:
;programa 18.c,70 :: 		promedio[j]=aux_value;
	MOVF        _j+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _promedio+0
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_promedio+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        _aux_value+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        _aux_value+1, 0 
	MOVWF       POSTINC1+0 
;programa 18.c,71 :: 		promedio_dato=0;
	CLRF        _promedio_dato+0 
	CLRF        _promedio_dato+1 
;programa 18.c,72 :: 		for(i=0;i<n_promedio;i++){
	CLRF        _i+0 
L_interrupt6:
	MOVLW       0
	MOVWF       R0 
	MOVF        _n_promedio+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt24
	MOVF        _n_promedio+0, 0 
	SUBWF       _i+0, 0 
L__interrupt24:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt7
;programa 18.c,73 :: 		promedio_dato=promedio_dato+promedio[i];
	MOVF        _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _promedio+0
	ADDWF       R0, 0 
	MOVWF       FSR2 
	MOVLW       hi_addr(_promedio+0)
	ADDWFC      R1, 0 
	MOVWF       FSR2H 
	MOVF        POSTINC2+0, 0 
	ADDWF       _promedio_dato+0, 1 
	MOVF        POSTINC2+0, 0 
	ADDWFC      _promedio_dato+1, 1 
;programa 18.c,72 :: 		for(i=0;i<n_promedio;i++){
	INCF        _i+0, 1 
;programa 18.c,74 :: 		}
	GOTO        L_interrupt6
L_interrupt7:
;programa 18.c,75 :: 		promedio_dato=promedio_dato/n_promedio;
	MOVF        _n_promedio+0, 0 
	MOVWF       R4 
	MOVF        _n_promedio+1, 0 
	MOVWF       R5 
	MOVF        _promedio_dato+0, 0 
	MOVWF       R0 
	MOVF        _promedio_dato+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _promedio_dato+0 
	MOVF        R1, 0 
	MOVWF       _promedio_dato+1 
;programa 18.c,76 :: 		j++;
	INCF        _j+0, 1 
;programa 18.c,77 :: 		k++;
	INFSNZ      _k+0, 1 
	INCF        _k+1, 1 
;programa 18.c,78 :: 		if(j>n_promedio)j=0;
	MOVLW       0
	SUBWF       _n_promedio+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt25
	MOVF        _j+0, 0 
	SUBWF       _n_promedio+0, 0 
L__interrupt25:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt9
	CLRF        _j+0 
L_interrupt9:
;programa 18.c,79 :: 		desviacion=desviacion+promedio_dato;
	MOVF        _promedio_dato+0, 0 
	ADDWF       _desviacion+0, 1 
	MOVF        _promedio_dato+1, 0 
	ADDWFC      _desviacion+1, 1 
	MOVLW       0
	ADDWFC      _desviacion+2, 1 
	ADDWFC      _desviacion+3, 1 
;programa 18.c,80 :: 		if(promedio_dato>umbral){
	MOVF        _promedio_dato+1, 0 
	SUBWF       _umbral+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt26
	MOVF        _promedio_dato+0, 0 
	SUBWF       _umbral+0, 0 
L__interrupt26:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt10
;programa 18.c,81 :: 		LATD0_bit=1;
	BSF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;programa 18.c,82 :: 		}
	GOTO        L_interrupt11
L_interrupt10:
;programa 18.c,84 :: 		LATD0_bit=0;
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;programa 18.c,85 :: 		}
L_interrupt11:
;programa 18.c,86 :: 		RD1_bit=0;
	BCF         RD1_bit+0, BitPos(RD1_bit+0) 
;programa 18.c,87 :: 		despliegue=1;
	BSF         _despliegue+0, BitPos(_despliegue+0) 
;programa 18.c,89 :: 		}
L_interrupt2:
;programa 18.c,90 :: 		}
L_end_interrupt:
L__interrupt21:
	RETFIE      1
; end of _interrupt

_main:

;programa 18.c,92 :: 		void main() {
;programa 18.c,93 :: 		TRISB=0XF0;
	MOVLW       240
	MOVWF       TRISB+0 
;programa 18.c,94 :: 		HA_1=1;
	BSF         LATB0_bit+0, BitPos(LATB0_bit+0) 
;programa 18.c,95 :: 		HA_2=0;
	BCF         LATB1_bit+0, BitPos(LATB1_bit+0) 
;programa 18.c,96 :: 		HA_3=0;
	BCF         LATB2_bit+0, BitPos(LATB2_bit+0) 
;programa 18.c,97 :: 		HA_4=0;
	BCF         LATB3_bit+0, BitPos(LATB3_bit+0) 
;programa 18.c,99 :: 		TRISD=0X00;
	CLRF        TRISD+0 
;programa 18.c,100 :: 		PORTD=0x00;
	CLRF        PORTD+0 
;programa 18.c,101 :: 		Chip_Select=0;
	BCF         RC0_bit+0, BitPos(RC0_bit+0) 
;programa 18.c,102 :: 		Chip_Select_Direction=0;
	BCF         TRISC0_bit+0, BitPos(TRISC0_bit+0) 
;programa 18.c,105 :: 		RD16_T1CON_bit=1;     //Habilita el TIMER1 en timer de 16 bits
	BSF         RD16_T1CON_bit+0, BitPos(RD16_T1CON_bit+0) 
;programa 18.c,106 :: 		T1RUN_bit=1;    //
	BSF         T1RUN_bit+0, BitPos(T1RUN_bit+0) 
;programa 18.c,107 :: 		T1CKPS0_bit=0;
	BCF         T1CKPS0_bit+0, BitPos(T1CKPS0_bit+0) 
;programa 18.c,108 :: 		T1CKPS1_bit=0;
	BCF         T1CKPS1_bit+0, BitPos(T1CKPS1_bit+0) 
;programa 18.c,109 :: 		T1OSCEN_bit=0;  //Oscilador del Timer1 apagado
	BCF         T1OSCEN_bit+0, BitPos(T1OSCEN_bit+0) 
;programa 18.c,110 :: 		T1SYNC_bit=0;   //No interesa con TMR1CS=0
	BCF         T1SYNC_bit+0, BitPos(T1SYNC_bit+0) 
;programa 18.c,111 :: 		TMR1CS_bit=0;   //FOSC/4
	BCF         TMR1CS_bit+0, BitPos(TMR1CS_bit+0) 
;programa 18.c,112 :: 		TMR1ON_bit=1;   //Encendido del Timer
	BSF         TMR1ON_bit+0, BitPos(TMR1ON_bit+0) 
;programa 18.c,115 :: 		T3CCP2_bit=0;  // Timer 1 es la fuente de reloj para los  modulos CCP
	BCF         T3CCP2_bit+0, BitPos(T3CCP2_bit+0) 
;programa 18.c,116 :: 		T3CCP1_bit=0;  //
	BCF         T3CCP1_bit+0, BitPos(T3CCP1_bit+0) 
;programa 18.c,120 :: 		CCP2CON= 0X0B; //Dispara del ADC
	MOVLW       11
	MOVWF       CCP2CON+0 
;programa 18.c,121 :: 		CCPR2H=0x0F;
	MOVLW       15
	MOVWF       CCPR2H+0 
;programa 18.c,122 :: 		CCPR2L=0xA0;
	MOVLW       160
	MOVWF       CCPR2L+0 
;programa 18.c,125 :: 		ADCON0=0x01;
	MOVLW       1
	MOVWF       ADCON0+0 
;programa 18.c,126 :: 		ADCON1=0x00;
	CLRF        ADCON1+0 
;programa 18.c,127 :: 		ADCON2=0b10000010;
	MOVLW       130
	MOVWF       ADCON2+0 
;programa 18.c,129 :: 		j=0;
	CLRF        _j+0 
;programa 18.c,130 :: 		k=0;
	CLRF        _k+0 
	CLRF        _k+1 
;programa 18.c,131 :: 		umbral=0;
	CLRF        _umbral+0 
	CLRF        _umbral+1 
;programa 18.c,132 :: 		n_promedio=10;
	MOVLW       10
	MOVWF       _n_promedio+0 
	MOVLW       0
	MOVWF       _n_promedio+1 
;programa 18.c,136 :: 		GIE_bit=1;
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;programa 18.c,137 :: 		PEIE_bit=1;
	BSF         PEIE_bit+0, BitPos(PEIE_bit+0) 
;programa 18.c,138 :: 		TMR1IE_bit=1;
	BSF         TMR1IE_bit+0, BitPos(TMR1IE_bit+0) 
;programa 18.c,139 :: 		CCP2IE_bit=1;
	BSF         CCP2IE_bit+0, BitPos(CCP2IE_bit+0) 
;programa 18.c,140 :: 		ADIE_bit=1;
	BSF         ADIE_bit+0, BitPos(ADIE_bit+0) 
;programa 18.c,142 :: 		TMR1IF_bit=0;
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;programa 18.c,144 :: 		puntero=&value;
	MOVLW       _value+0
	MOVWF       _puntero+0 
	MOVLW       hi_addr(_value+0)
	MOVWF       _puntero+1 
;programa 18.c,145 :: 		SPI1_Init();
	CALL        _SPI1_Init+0, 0
;programa 18.c,146 :: 		while(1){
L_main12:
;programa 18.c,147 :: 		if(!pulsante){
	BTFSC       RB7_bit+0, BitPos(RB7_bit+0) 
	GOTO        L_main14
;programa 18.c,148 :: 		while(!pulsante);
L_main15:
	BTFSC       RB7_bit+0, BitPos(RB7_bit+0) 
	GOTO        L_main16
	GOTO        L_main15
L_main16:
;programa 18.c,149 :: 		HA_1=~HA_1;
	BTG         LATB0_bit+0, BitPos(LATB0_bit+0) 
;programa 18.c,150 :: 		}
L_main14:
;programa 18.c,151 :: 		if(despliegue){
	BTFSS       _despliegue+0, BitPos(_despliegue+0) 
	GOTO        L_main17
;programa 18.c,152 :: 		DAC_Output(value<<2);                   // Envía el valor al DAC
	MOVF        _value+0, 0 
	MOVWF       FARG_DAC_Output_valueDAC+0 
	MOVF        _value+1, 0 
	MOVWF       FARG_DAC_Output_valueDAC+1 
	RLCF        FARG_DAC_Output_valueDAC+0, 1 
	BCF         FARG_DAC_Output_valueDAC+0, 0 
	RLCF        FARG_DAC_Output_valueDAC+1, 1 
	RLCF        FARG_DAC_Output_valueDAC+0, 1 
	BCF         FARG_DAC_Output_valueDAC+0, 0 
	RLCF        FARG_DAC_Output_valueDAC+1, 1 
	CALL        _DAC_Output+0, 0
;programa 18.c,153 :: 		despliegue=0;
	BCF         _despliegue+0, BitPos(_despliegue+0) 
;programa 18.c,154 :: 		}
L_main17:
;programa 18.c,155 :: 		if(k>1000){
	MOVF        _k+1, 0 
	SUBLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L__main28
	MOVF        _k+0, 0 
	SUBLW       232
L__main28:
	BTFSC       STATUS+0, 0 
	GOTO        L_main18
;programa 18.c,156 :: 		umbral=desviacion/k+20;
	MOVF        _k+0, 0 
	MOVWF       R4 
	MOVF        _k+1, 0 
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	MOVF        _desviacion+0, 0 
	MOVWF       R0 
	MOVF        _desviacion+1, 0 
	MOVWF       R1 
	MOVF        _desviacion+2, 0 
	MOVWF       R2 
	MOVF        _desviacion+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_S+0, 0
	MOVLW       20
	ADDWF       R0, 0 
	MOVWF       _umbral+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       _umbral+1 
;programa 18.c,157 :: 		k=0;
	CLRF        _k+0 
	CLRF        _k+1 
;programa 18.c,158 :: 		desviacion=0;
	CLRF        _desviacion+0 
	CLRF        _desviacion+1 
	CLRF        _desviacion+2 
	CLRF        _desviacion+3 
;programa 18.c,160 :: 		}
L_main18:
;programa 18.c,161 :: 		}
	GOTO        L_main12
;programa 18.c,163 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
