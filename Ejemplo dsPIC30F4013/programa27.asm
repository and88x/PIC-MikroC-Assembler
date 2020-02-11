
_ADC1Int:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;programa27.c,7 :: 		void ADC1Int() org 0x2E{               // Dirección en el vector de interrupciones para el timer 3
;programa27.c,8 :: 		LATB15_bit = ~LATB15_bit;            // Invierte el puerto B15
	BTG	LATB15_bit, BitPos(LATB15_bit+0)
;programa27.c,9 :: 		IFS0bits.AD1IF=0;                            // Borra la petición de interrupción
	BCLR	IFS0bits, #13
;programa27.c,10 :: 		}
L_end_ADC1Int:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _ADC1Int

_Timer3Int:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;programa27.c,12 :: 		void Timer3Int() org 0x24{             // Dirección en el vector de interrupciones para el timer 3
;programa27.c,13 :: 		LATB14_bit = ~LATB14_bit;            // Invierte el puerto B14
	BTG	LATB14_bit, BitPos(LATB14_bit+0)
;programa27.c,14 :: 		IFS0bits.T3IF = 0;                            // Borra la petición de interrupción
	BCLR	IFS0bits, #8
;programa27.c,15 :: 		}
L_end_Timer3Int:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _Timer3Int

_main:
	MOV	#2048, W15
	MOV	#6142, W0
	MOV	WREG, 32
	MOV	#1, W0
	MOV	WREG, 52
	MOV	#4, W0
	IOR	68

;programa27.c,17 :: 		void main(){
;programa27.c,18 :: 		RPOR3=0x0003;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#3, W0
	MOV	WREG, RPOR3
;programa27.c,20 :: 		UART1_Init(9600);               // Initialize UART module at 9600 bps
	MOV	#9600, W10
	MOV	#0, W11
	CALL	_UART1_Init
;programa27.c,21 :: 		Delay_ms(1000);
	MOV	#26, W8
	MOV	#28274, W7
L_main0:
	DEC	W7
	BRA NZ	L_main0
	DEC	W8
	BRA NZ	L_main0
;programa27.c,24 :: 		AD1CON1bits.DONE=0;
	BCLR	AD1CON1bits, #0
;programa27.c,25 :: 		AD1CON1bits.SAMP=0;
	BCLR	AD1CON1bits, #1
;programa27.c,26 :: 		AD1CON1bits.ASAM=1;
	BSET	AD1CON1bits, #2
;programa27.c,27 :: 		AD1CON1bits.SIMSAM=1;
	BSET	AD1CON1bits, #3
;programa27.c,28 :: 		AD1CON1bits.SSRC=2;
	MOV.B	#64, W0
	MOV.B	W0, W1
	MOV	#lo_addr(AD1CON1bits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#224, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(AD1CON1bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(AD1CON1bits), W0
	MOV.B	W1, [W0]
;programa27.c,29 :: 		AD1CON1bits.FORM=0;
	MOV	AD1CON1bits, W1
	MOV	#64767, W0
	AND	W1, W0, W0
	MOV	WREG, AD1CON1bits
;programa27.c,30 :: 		AD1CON1bits.AD12B=0;
	BCLR	AD1CON1bits, #10
;programa27.c,31 :: 		AD1CON1bits.ADSIDL=0;
	BCLR	AD1CON1bits, #13
;programa27.c,32 :: 		AD1CON1bits.ADON=1;
	BSET	AD1CON1bits, #15
;programa27.c,34 :: 		AD1CON3 = 0x1003;   //ADCS=3 (min TAD for 10MHz (16TAD) is 3*TCY=300ns)
	MOV	#4099, W0
	MOV	WREG, AD1CON3
;programa27.c,35 :: 		AD1CON2 = 0x0300;   //Interrupt upon completion of one sample/convert
	MOV	#768, W0
	MOV	WREG, AD1CON2
;programa27.c,38 :: 		AD1CHS123 = 0x0101;
	MOV	#257, W0
	MOV	WREG, AD1CHS123
;programa27.c,41 :: 		AD1CHS0  = 0x0000;
	CLR	AD1CHS0
;programa27.c,42 :: 		AD1CSSL = 0;               //No scan
	CLR	AD1CSSL
;programa27.c,43 :: 		AD1PCFGL = 0xFFE0;    //AN0 to AN5 como analógicos
	MOV	#65504, W0
	MOV	WREG, AD1PCFGL
;programa27.c,44 :: 		AD1CON1.F15 = 1;           //ADC on
	BSET	AD1CON1, #15
;programa27.c,47 :: 		IPC1  = IPC1 | 0x1000;    // Prioridad del Timer3 es 1
	MOV	#4096, W1
	MOV	#lo_addr(IPC1), W0
	IOR	W1, [W0], [W0]
;programa27.c,48 :: 		T3IE_bit = 1;
	BSET	T3IE_bit, BitPos(T3IE_bit+0)
;programa27.c,49 :: 		IEC0  = IEC0 | 0x0080;    // Habilitación de interrupción del Timer3
	MOV	#128, W1
	MOV	#lo_addr(IEC0), W0
	IOR	W1, [W0], [W0]
;programa27.c,50 :: 		PR2   = 34464;            // Período de interrupción es 100 000 ciclos
	MOV	#34464, W0
	MOV	WREG, PR2
;programa27.c,51 :: 		PR3   = 0x0001;           // Total PR3/2=1*65536 + 34464
	MOV	#1, W0
	MOV	WREG, PR3
;programa27.c,52 :: 		T3CON = 0x8000;           //10000000 00000000
	MOV	#32768, W0
	MOV	WREG, T3CON
;programa27.c,54 :: 		TRISB15_bit=0;
	BCLR	TRISB15_bit, BitPos(TRISB15_bit+0)
;programa27.c,55 :: 		TRISB14_bit=0;
	BCLR	TRISB14_bit, BitPos(TRISB14_bit+0)
;programa27.c,56 :: 		LATB15_bit=0;
	BCLR	LATB15_bit, BitPos(LATB15_bit+0)
;programa27.c,57 :: 		LATB14_bit=0;
	BCLR	LATB14_bit, BitPos(LATB14_bit+0)
;programa27.c,59 :: 		while(1) {                         // Endless loop
L_main2:
;programa27.c,61 :: 		AD1CON1.F1 = 1;                  //Start sampling (SAMP=1)
	BSET	AD1CON1, #1
;programa27.c,62 :: 		Delay_ms(100);                   //Wait for 100ms (sampling ...)
	MOV	#3, W8
	MOV	#35594, W7
L_main4:
	DEC	W7
	BRA NZ	L_main4
	DEC	W8
	BRA NZ	L_main4
	NOP
;programa27.c,63 :: 		AD1CON1.F1 = 0;                  //Clear SAMP bit (trigger conversion)
	BCLR	AD1CON1, #1
;programa27.c,64 :: 		while (AD1CON1.F0 == 0)
L_main6:
	BTSC	AD1CON1, #0
	GOTO	L_main7
;programa27.c,65 :: 		asm nop;                         //Wait for DONE bit in ADCON1
	NOP
	GOTO	L_main6
L_main7:
;programa27.c,66 :: 		conversion=5.*ADC1BUF0/1024.;
	MOV	ADC1BUF0, WREG
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#16544, W3
	CALL	__Mul_FP
	MOV	#0, W2
	MOV	#17536, W3
	CALL	__Div_FP
	MOV	W0, _conversion
	MOV	W1, _conversion+2
;programa27.c,67 :: 		FloatToStr(conversion, txt);
	MOV	#lo_addr(_txt), W12
	MOV.D	W0, W10
	CALL	_FloatToStr
;programa27.c,68 :: 		UART_Write_Text("AN0=");
	MOV	#lo_addr(?lstr1_programa27), W10
	CALL	_UART_Write_Text
;programa27.c,69 :: 		UART_Write_Text(txt);
	MOV	#lo_addr(_txt), W10
	CALL	_UART_Write_Text
;programa27.c,70 :: 		UART_Write(9);
	MOV	#9, W10
	CALL	_UART_Write
;programa27.c,72 :: 		conversion=5.*ADC1BUF1/1024.;
	MOV	ADC1BUF1, WREG
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#16544, W3
	CALL	__Mul_FP
	MOV	#0, W2
	MOV	#17536, W3
	CALL	__Div_FP
	MOV	W0, _conversion
	MOV	W1, _conversion+2
;programa27.c,73 :: 		FloatToStr(conversion, txt);
	MOV	#lo_addr(_txt), W12
	MOV.D	W0, W10
	CALL	_FloatToStr
;programa27.c,74 :: 		UART_Write_Text("AN1=");
	MOV	#lo_addr(?lstr2_programa27), W10
	CALL	_UART_Write_Text
;programa27.c,75 :: 		UART_Write_Text(txt);
	MOV	#lo_addr(_txt), W10
	CALL	_UART_Write_Text
;programa27.c,76 :: 		UART_Write(9);
	MOV	#9, W10
	CALL	_UART_Write
;programa27.c,78 :: 		conversion=5.*ADC1BUF2/1024.;
	MOV	ADC1BUF2, WREG
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#16544, W3
	CALL	__Mul_FP
	MOV	#0, W2
	MOV	#17536, W3
	CALL	__Div_FP
	MOV	W0, _conversion
	MOV	W1, _conversion+2
;programa27.c,79 :: 		FloatToStr(conversion, txt);
	MOV	#lo_addr(_txt), W12
	MOV.D	W0, W10
	CALL	_FloatToStr
;programa27.c,80 :: 		UART_Write_Text("AN2=");
	MOV	#lo_addr(?lstr3_programa27), W10
	CALL	_UART_Write_Text
;programa27.c,81 :: 		UART_Write_Text(txt);
	MOV	#lo_addr(_txt), W10
	CALL	_UART_Write_Text
;programa27.c,82 :: 		UART_Write(9);
	MOV	#9, W10
	CALL	_UART_Write
;programa27.c,84 :: 		conversion=5.*ADC1BUF3/1024.;
	MOV	ADC1BUF3, WREG
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#16544, W3
	CALL	__Mul_FP
	MOV	#0, W2
	MOV	#17536, W3
	CALL	__Div_FP
	MOV	W0, _conversion
	MOV	W1, _conversion+2
;programa27.c,85 :: 		FloatToStr(conversion, txt);
	MOV	#lo_addr(_txt), W12
	MOV.D	W0, W10
	CALL	_FloatToStr
;programa27.c,86 :: 		UART_Write_Text("AN3=");
	MOV	#lo_addr(?lstr4_programa27), W10
	CALL	_UART_Write_Text
;programa27.c,87 :: 		UART_Write_Text(txt);
	MOV	#lo_addr(_txt), W10
	CALL	_UART_Write_Text
;programa27.c,88 :: 		UART_Write(9);
	MOV	#9, W10
	CALL	_UART_Write
;programa27.c,89 :: 		UART_Write(13);
	MOV	#13, W10
	CALL	_UART_Write
;programa27.c,90 :: 		delay_ms(1000);
	MOV	#26, W8
	MOV	#28274, W7
L_main8:
	DEC	W7
	BRA NZ	L_main8
	DEC	W8
	BRA NZ	L_main8
;programa27.c,91 :: 		}
	GOTO	L_main2
;programa27.c,93 :: 		}
L_end_main:
	POP	W12
	POP	W11
	POP	W10
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main
