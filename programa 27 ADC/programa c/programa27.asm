
_Move_Delay:

;programa27.c,25 :: 		void Move_Delay() {                  // Function used for text moving
;programa27.c,26 :: 		Delay_ms(500);                     // You can change the moving speed here
	MOV	#13, W8
	MOV	#46904, W7
L_Move_Delay0:
	DEC	W7
	BRA NZ	L_Move_Delay0
	DEC	W8
	BRA NZ	L_Move_Delay0
	NOP
;programa27.c,27 :: 		}
L_end_Move_Delay:
	RETURN
; end of _Move_Delay

_main:
	MOV	#2048, W15
	MOV	#6142, W0
	MOV	WREG, 32
	MOV	#1, W0
	MOV	WREG, 52
	MOV	#4, W0
	IOR	68

;programa27.c,29 :: 		void main(){
;programa27.c,30 :: 		RPINR18=0xFF07;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#65287, W0
	MOV	WREG, RPINR18
;programa27.c,31 :: 		RPOR3=0x0003;
	MOV	#3, W0
	MOV	WREG, RPOR3
;programa27.c,32 :: 		ADPCFG = 0xFFFF;                   // Configure AN pins as digital I/O
	MOV	#65535, W0
	MOV	WREG, ADPCFG
;programa27.c,34 :: 		Lcd_Init();                        // Initialize LCD
	CALL	_Lcd_Init
;programa27.c,36 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOV.B	#1, W10
	CALL	_Lcd_Cmd
;programa27.c,37 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOV.B	#12, W10
	CALL	_Lcd_Cmd
;programa27.c,38 :: 		Lcd_Out(1,6,txt3);                 // Write text in first row
	MOV	#lo_addr(_txt3), W12
	MOV	#6, W11
	MOV	#1, W10
	CALL	_Lcd_Out
;programa27.c,40 :: 		Lcd_Out(2,6,txt4);                 // Write text in second row
	MOV	#lo_addr(_txt4), W12
	MOV	#6, W11
	MOV	#2, W10
	CALL	_Lcd_Out
;programa27.c,41 :: 		Delay_ms(2000);
	MOV	#51, W8
	MOV	#56549, W7
L_main2:
	DEC	W7
	BRA NZ	L_main2
	DEC	W8
	BRA NZ	L_main2
;programa27.c,42 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOV.B	#1, W10
	CALL	_Lcd_Cmd
;programa27.c,44 :: 		Lcd_Out(1,1,txt1);                 // Write text in first row
	MOV	#lo_addr(_txt1), W12
	MOV	#1, W11
	MOV	#1, W10
	CALL	_Lcd_Out
;programa27.c,45 :: 		Lcd_Out(2,5,txt2);                 // Write text in second row
	MOV	#lo_addr(_txt2), W12
	MOV	#5, W11
	MOV	#2, W10
	CALL	_Lcd_Out
;programa27.c,46 :: 		UART1_Init(9600);               // Initialize UART module at 9600 bps
	MOV	#9600, W10
	MOV	#0, W11
	CALL	_UART1_Init
;programa27.c,47 :: 		Delay_ms(1000);
	MOV	#26, W8
	MOV	#28274, W7
L_main4:
	DEC	W7
	BRA NZ	L_main4
	DEC	W8
	BRA NZ	L_main4
;programa27.c,50 :: 		AD1PCFGL = 0xFFFE;        //1th channel is sampled and coverted
	MOV	#65534, W0
	MOV	WREG, AD1PCFGL
;programa27.c,51 :: 		AD1CON1 = 0x0040;        //ADC off, output_format=INTEGER
	MOV	#64, W0
	MOV	WREG, AD1CON1
;programa27.c,54 :: 		AD1CHS0  = 0x0000;          //
	CLR	AD1CHS0
;programa27.c,55 :: 		AD1CSSL = 0;               //No scan
	CLR	AD1CSSL
;programa27.c,56 :: 		AD1CON3 = 0x0F00;        //TAD = internalTCY
	MOV	#3840, W0
	MOV	WREG, AD1CON3
;programa27.c,65 :: 		TMR3   = 0;             //Reset TIMER3 counter
	CLR	TMR3
;programa27.c,66 :: 		PR3    = 0x3FFF;        //PR3, number of TIMER3 clocks between two conversions start
	MOV	#16383, W0
	MOV	WREG, PR3
;programa27.c,67 :: 		T3CON  = 0x8010;        //TIMER3 ON, prescale 1:1
	MOV	#32784, W0
	MOV	WREG, T3CON
;programa27.c,69 :: 		AD1CON1.F15 = 1;         //ADC on
	BSET	AD1CON1, #15
;programa27.c,70 :: 		AD1CON1.F2  = 1;         //ASAM=1, start sampling after conversion ends
	BSET	AD1CON1, #2
;programa27.c,77 :: 		while(1) {                         // Endless loop
L_main6:
;programa27.c,81 :: 		SAMP_bit = 1;                  //SAMP=1, start sampling
	BSET	SAMP_bit, BitPos(SAMP_bit+0)
;programa27.c,83 :: 		while (DONE_bit)
L_main8:
	BTSS	DONE_bit, BitPos(DONE_bit+0)
	GOTO	L_main9
;programa27.c,84 :: 		asm nop;                         //Wait for DONE bit in ADCON1
	NOP
	GOTO	L_main8
L_main9:
;programa27.c,85 :: 		conversion=ADC1BUF0;
	MOV	ADC1BUF0, WREG
	CLR	W1
	CALL	__Long2Float
	MOV	W0, _conversion
	MOV	W1, _conversion+2
;programa27.c,86 :: 		FloatToStr(conversion, texto);
	MOV	_texto, W12
	MOV.D	W0, W10
	CALL	_FloatToStr
;programa27.c,88 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOV.B	#1, W10
	CALL	_Lcd_Cmd
;programa27.c,89 :: 		UART_Write(ADC1BUF0);
	MOV	ADC1BUF0, W10
	CALL	_UART_Write
;programa27.c,90 :: 		Lcd_chr(1,1,ADC1BUF0);
	MOV	ADC1BUF0, W12
	MOV	#1, W11
	MOV	#1, W10
	CALL	_Lcd_Chr
;programa27.c,91 :: 		Lcd_Out(2,1,texto);
	MOV	_texto, W12
	MOV	#1, W11
	MOV	#2, W10
	CALL	_Lcd_Out
;programa27.c,93 :: 		}
	GOTO	L_main6
;programa27.c,95 :: 		}
L_end_main:
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main
