
_Move_Delay:

;programa27.c,26 :: 		void Move_Delay() {                  // Function used for text moving
;programa27.c,27 :: 		Delay_ms(500);                     // You can change the moving speed here
	MOV	#13, W8
	MOV	#46904, W7
L_Move_Delay0:
	DEC	W7
	BRA NZ	L_Move_Delay0
	DEC	W8
	BRA NZ	L_Move_Delay0
	NOP
;programa27.c,28 :: 		}
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

;programa27.c,30 :: 		void main(){
;programa27.c,31 :: 		RPINR18=0xFF07;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#65287, W0
	MOV	WREG, RPINR18
;programa27.c,32 :: 		RPOR3=0x0003;
	MOV	#3, W0
	MOV	WREG, RPOR3
;programa27.c,33 :: 		ADPCFG = 0xFFFF;                   // Configure AN pins as digital I/O
	MOV	#65535, W0
	MOV	WREG, ADPCFG
;programa27.c,35 :: 		Lcd_Init();                        // Initialize LCD
	CALL	_Lcd_Init
;programa27.c,37 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOV.B	#1, W10
	CALL	_Lcd_Cmd
;programa27.c,38 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOV.B	#12, W10
	CALL	_Lcd_Cmd
;programa27.c,39 :: 		Lcd_Out(1,6,txt3);                 // Write text in first row
	MOV	#lo_addr(_txt3), W12
	MOV	#6, W11
	MOV	#1, W10
	CALL	_Lcd_Out
;programa27.c,41 :: 		Lcd_Out(2,6,txt4);                 // Write text in second row
	MOV	#lo_addr(_txt4), W12
	MOV	#6, W11
	MOV	#2, W10
	CALL	_Lcd_Out
;programa27.c,42 :: 		Delay_ms(2000);
	MOV	#51, W8
	MOV	#56549, W7
L_main2:
	DEC	W7
	BRA NZ	L_main2
	DEC	W8
	BRA NZ	L_main2
;programa27.c,43 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOV.B	#1, W10
	CALL	_Lcd_Cmd
;programa27.c,45 :: 		Lcd_Out(1,1,txt1);                 // Write text in first row
	MOV	#lo_addr(_txt1), W12
	MOV	#1, W11
	MOV	#1, W10
	CALL	_Lcd_Out
;programa27.c,46 :: 		Lcd_Out(2,5,txt2);                 // Write text in second row
	MOV	#lo_addr(_txt2), W12
	MOV	#5, W11
	MOV	#2, W10
	CALL	_Lcd_Out
;programa27.c,47 :: 		UART1_Init(9600);               // Initialize UART module at 9600 bps
	MOV	#9600, W10
	MOV	#0, W11
	CALL	_UART1_Init
;programa27.c,48 :: 		Delay_ms(2000);
	MOV	#51, W8
	MOV	#56549, W7
L_main4:
	DEC	W7
	BRA NZ	L_main4
	DEC	W8
	BRA NZ	L_main4
;programa27.c,51 :: 		AD1PCFGL = 0xFFFE;        //1th channel is sampled and coverted
	MOV	#65534, W0
	MOV	WREG, AD1PCFGL
;programa27.c,52 :: 		AD1CON1 = 0;              //ADC off, output_format=INTEGER
	CLR	AD1CON1
;programa27.c,55 :: 		AD1CHS0  = 0x0000;          //
	CLR	AD1CHS0
;programa27.c,56 :: 		AD1CSSL = 0;               //No scan
	CLR	AD1CSSL
;programa27.c,57 :: 		AD1CON3 = 0x1003;          //ADCS=3 (min TAD for 10MHz is 3*TCY=300ns)
	MOV	#4099, W0
	MOV	WREG, AD1CON3
;programa27.c,58 :: 		AD1CON2 = 0;               //Interrupt upon completion of one sample/convert
	CLR	AD1CON2
;programa27.c,59 :: 		AD1CON1.F15 = 1;           //ADC on
	BSET	AD1CON1, #15
;programa27.c,62 :: 		while(1) {                         // Endless loop
L_main6:
;programa27.c,64 :: 		AD1CON1.F1 = 1;                  //Start sampling (SAMP=1)
	BSET	AD1CON1, #1
;programa27.c,65 :: 		Delay_ms(100);                   //Wait for 100ms (sampling ...)
	MOV	#3, W8
	MOV	#35594, W7
L_main8:
	DEC	W7
	BRA NZ	L_main8
	DEC	W8
	BRA NZ	L_main8
	NOP
;programa27.c,66 :: 		AD1CON1.F1 = 0;                  //Clear SAMP bit (trigger conversion)
	BCLR	AD1CON1, #1
;programa27.c,67 :: 		while (AD1CON1.F0 == 0)
L_main10:
	BTSC	AD1CON1, #0
	GOTO	L_main11
;programa27.c,68 :: 		asm nop;                         //Wait for DONE bit in ADCON1
	NOP
	GOTO	L_main10
L_main11:
;programa27.c,69 :: 		conversion=5.*ADC1BUF0/1024.;
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
;programa27.c,70 :: 		FloatToStr(conversion, txt);
	MOV	#lo_addr(_txt), W12
	MOV.D	W0, W10
	CALL	_FloatToStr
;programa27.c,72 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOV.B	#1, W10
	CALL	_Lcd_Cmd
;programa27.c,73 :: 		UART_Write_Text(txt);
	MOV	#lo_addr(_txt), W10
	CALL	_UART_Write_Text
;programa27.c,74 :: 		Lcd_Out(1,1,txt);
	MOV	#lo_addr(_txt), W12
	MOV	#1, W11
	MOV	#1, W10
	CALL	_Lcd_Out
;programa27.c,77 :: 		}
	GOTO	L_main6
;programa27.c,79 :: 		}
L_end_main:
	POP	W12
	POP	W11
	POP	W10
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main
