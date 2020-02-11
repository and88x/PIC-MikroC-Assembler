
_interrupt_int0:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;programa24.c,3 :: 		void interrupt_int0() iv IVT_ADDR_INT0INTERRUPT ics ICS_AUTO {
;programa24.c,4 :: 		LATA++;
	MOV	LATA, WREG
	INC	W0
	MOV	WREG, LATA
;programa24.c,5 :: 		INT0IF_bit = 0;                // bandera de interrupción borrada
	BCLR	INT0IF_bit, BitPos(INT0IF_bit+0)
;programa24.c,6 :: 		}
L_end_interrupt_int0:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _interrupt_int0

_interrupt_int1:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;programa24.c,8 :: 		void interrupt_int1() iv IVT_ADDR_INT1INTERRUPT ics ICS_AUTO {
;programa24.c,9 :: 		LATA--;
	MOV	LATA, WREG
	DEC	W0
	MOV	WREG, LATA
;programa24.c,10 :: 		INT1IF_bit = 0;                // bandera de interrupción borrada
	BCLR	INT1IF_bit, BitPos(INT1IF_bit+0)
;programa24.c,11 :: 		}
L_end_interrupt_int1:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _interrupt_int1

_main:
	MOV	#2048, W15
	MOV	#6142, W0
	MOV	WREG, 32
	MOV	#1, W0
	MOV	WREG, 52
	MOV	#4, W0
	IOR	68

;programa24.c,15 :: 		void main(){
;programa24.c,16 :: 		TRISA = 0;      //porta como salidas
	CLR	TRISA
;programa24.c,17 :: 		TRISB = 0xFFFF; //portb como entradas
	MOV	#65535, W0
	MOV	WREG, TRISB
;programa24.c,18 :: 		AD1PCFGL=0XFFFF;//Todas las entradadas son digitales
	MOV	#65535, W0
	MOV	WREG, AD1PCFGL
;programa24.c,19 :: 		IPC5BITS.INT1IP=7; //La prioridad de la interrupcion INT1 es 7, la mas alta
	MOV	#lo_addr(IPC5bits), W0
	MOV.B	[W0], W0
	IOR.B	W0, #7, W1
	MOV	#lo_addr(IPC5bits), W0
	MOV.B	W1, [W0]
;programa24.c,20 :: 		RPINR0BITS.INT1R=0;//La ubicación de la entrada de la INT1 es RP0
	MOV	RPINR0bits, W1
	MOV	#57599, W0
	AND	W1, W0, W0
	MOV	WREG, RPINR0bits
;programa24.c,21 :: 		INT0IE_bit = 1;
	BSET	INT0IE_bit, BitPos(INT0IE_bit+0)
;programa24.c,22 :: 		INT1IE_bit = 1;
	BSET	INT1IE_bit, BitPos(INT1IE_bit+0)
;programa24.c,23 :: 		INT0IF_bit = 0;
	BCLR	INT0IF_bit, BitPos(INT0IF_bit+0)
;programa24.c,24 :: 		INT1IF_bit = 0;
	BCLR	INT1IF_bit, BitPos(INT1IF_bit+0)
;programa24.c,27 :: 		while(1) asm nop;
L_main0:
	NOP
	GOTO	L_main0
;programa24.c,28 :: 		}
L_end_main:
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main
