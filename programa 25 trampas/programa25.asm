
_IntDet:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;programa25.c,3 :: 		void IntDet() org 0x0014{    //vector INT0
;programa25.c,4 :: 		LATA--;                    //porta es decrementado
	MOV	LATA, WREG
	DEC	W0
	MOV	WREG, LATA
;programa25.c,5 :: 		IFS0.F0 = 0;               //bandera de interrupcion borrada
	BCLR	IFS0, #0
;programa25.c,6 :: 		}
L_end_IntDet:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _IntDet

_TrapTrap:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;programa25.c,8 :: 		void TrapTrap() org 0x000C{
;programa25.c,9 :: 		INTCON1.F4 = 0;
	BCLR	INTCON1, #4
;programa25.c,12 :: 		LATA = 5;
	MOV	#5, W0
	MOV	WREG, LATA
;programa25.c,13 :: 		LATB++;    //Contador de ocurrencias del la trampa
	MOV	LATB, WREG
	INC	W0
	MOV	WREG, LATB
;programa25.c,14 :: 		}
L_end_TrapTrap:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _TrapTrap

_main:
	MOV	#2048, W15
	MOV	#6142, W0
	MOV	WREG, 32
	MOV	#1, W0
	MOV	WREG, 52
	MOV	#4, W0
	IOR	68

;programa25.c,16 :: 		void main(){
;programa25.c,17 :: 		TRISB = 0x0080;
	MOV	#128, W0
	MOV	WREG, TRISB
;programa25.c,18 :: 		TRISA = 0x0;
	CLR	TRISA
;programa25.c,19 :: 		LATB=0X0;
	CLR	LATB
;programa25.c,20 :: 		LATA = 0x05;
	MOV	#5, W0
	MOV	WREG, LATA
;programa25.c,21 :: 		IFS0 = 0;     //Bandera de interrupcion borrada
	CLR	IFS0
;programa25.c,22 :: 		INTCON1 = 0;  //Bandera de trampa borrada
	CLR	INTCON1
;programa25.c,23 :: 		IEC0 = 1;     //INterrupcíon en el flanco de subida INT0 (RB6) habilitado
	MOV	#1, W0
	MOV	WREG, IEC0
;programa25.c,24 :: 		while(1){
L_main0:
;programa25.c,25 :: 		valor = 256 / LATA; //Si LATA=0 se produce un error y se llama a la rutina de atención de trampa
	MOV	#256, W0
	MOV	LATA, W2
	REPEAT	#17
	DIV.U	W0, W2
	MOV	W0, _valor
;programa25.c,26 :: 		}
	GOTO	L_main0
;programa25.c,27 :: 		}
L_end_main:
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main
