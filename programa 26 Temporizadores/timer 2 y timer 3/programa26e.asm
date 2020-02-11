
_Timer23Int:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;programa26e.c,9 :: 		void Timer23Int() org 0x24{ // Dirección en el vector de interrupciones para el timer 3
;programa26e.c,10 :: 		LATB = ~LATB;            // Invierte el puerto B
	COM	LATB
;programa26e.c,11 :: 		IFS0 = 0;                 // Borra la petición de interrupción
	CLR	IFS0
;programa26e.c,12 :: 		}
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

;programa26e.c,14 :: 		void main(){
;programa26e.c,15 :: 		TRISB = 0x0000;                // Port B es salida
	CLR	TRISB
;programa26e.c,16 :: 		LATB  = 0xAAAA;           // Valor inicial para el puerto B
	MOV	#43690, W0
	MOV	WREG, LATB
;programa26e.c,17 :: 		IPC1  = IPC1 | 0x1000;    // Prioridad del Timer3 es 1
	MOV	#4096, W1
	MOV	#lo_addr(IPC1), W0
	IOR	W1, [W0], [W0]
;programa26e.c,18 :: 		T3IE_bit = 1;
	BSET	T3IE_bit, BitPos(T3IE_bit+0)
;programa26e.c,19 :: 		IEC0  = IEC0 | 0x0080;    // Habilitación de interrupción del Timer3
	MOV	#128, W1
	MOV	#lo_addr(IEC0), W0
	IOR	W1, [W0], [W0]
;programa26e.c,20 :: 		PR2   = 34464;            // Período de interrupción es 100 000 ciclos
	MOV	#34464, W0
	MOV	WREG, PR2
;programa26e.c,21 :: 		PR3   = 0x0001;           // Total PR3/2=1*65536 + 34464
	MOV	#1, W0
	MOV	WREG, PR3
;programa26e.c,22 :: 		T2CON = 0x8038;           // Timer2/3 es habilitado, reloj interno es  dividido para 256
	MOV	#32824, W0
	MOV	WREG, T2CON
;programa26e.c,23 :: 		while(1) asm nop;         // Bucle sin fin
L_main0:
	NOP
	GOTO	L_main0
;programa26e.c,24 :: 		}
L_end_main:
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main
