
_Timer23Int:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;programa26f.c,1 :: 		void Timer23Int() org 0x22{ //Address in the interrupt vector table of timer3
;programa26f.c,2 :: 		LATB++;                   //Increments the value of PORTD
	MOV	LATB, WREG
	INC	W0
	MOV	WREG, LATB
;programa26f.c,3 :: 		IFS0 = 0;                 // Clear interrupt request
	CLR	IFS0
;programa26f.c,4 :: 		}
L_end_Timer23Int:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _Timer23Int

_main:
	MOV	#2048, W15
	MOV	#6142, W0
	MOV	WREG, 32
	MOV	#1, W0
	MOV	WREG, 52
	MOV	#4, W0
	IOR	68

;programa26f.c,6 :: 		void main(){
;programa26f.c,7 :: 		TRISB = 0;             //PORTD is output
	CLR	TRISB
;programa26f.c,8 :: 		TRISA = 0x10; // El pin PORTA<4>=1 T1CK es entrada
	MOV	#16, W0
	MOV	WREG, TRISA
;programa26f.c,9 :: 		LATB  = 0;             //Initial value at PORTD is set
	CLR	LATB
;programa26f.c,10 :: 		IPC1  = IPC1 | 0x1000; //Interrupt priority of timer3 is 1
	MOV	#4096, W1
	MOV	#lo_addr(IPC1), W0
	IOR	W1, [W0], [W0]
;programa26f.c,11 :: 		IEC0  = IEC0 | 0x0080; //Interrupt of timer3 enabled
	MOV	#128, W1
	MOV	#lo_addr(IEC0), W0
	IOR	W1, [W0], [W0]
;programa26f.c,12 :: 		PR2   = 10;            //Interrupt peiod is 10 clocks
	MOV	#10, W0
	MOV	WREG, PR2
;programa26f.c,13 :: 		PR3   = 0;             //Total PR3/2=0*65536 + 10
	CLR	PR3
;programa26f.c,14 :: 		T2CON = 0x800A;        //Timer2/3 is synchronous counter of external pulses
	MOV	#32778, W0
	MOV	WREG, T2CON
;programa26f.c,15 :: 		while(1) asm nop;      //Endless loop
L_main0:
	NOP
	GOTO	L_main0
;programa26f.c,16 :: 		}
L_end_main:
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main
