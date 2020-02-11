
_Timer1Int:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;Programa26a.c,6 :: 		void Timer1Int() org 0x1A{// Direccion del Timer1 en la tabla de vectores de interrupciòn
;Programa26a.c,7 :: 		LATB = ~LATB; // Inversión del PORTB
	COM	LATB
;Programa26a.c,8 :: 		IFS0 = IFS0 & 0xFFF7; // Borrado de la bandera de Interrupción
	MOV	#65527, W1
	MOV	#lo_addr(IFS0), W0
	AND	W1, [W0], [W0]
;Programa26a.c,9 :: 		}
L_end_Timer1Int:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _Timer1Int

_main:
	MOV	#2048, W15
	MOV	#6142, W0
	MOV	WREG, 32
	MOV	#1, W0
	MOV	WREG, 52
	MOV	#4, W0
	IOR	68

;Programa26a.c,10 :: 		void main(){
;Programa26a.c,12 :: 		TRISB = 0; // PORTB como salida
	CLR	TRISB
;Programa26a.c,13 :: 		LATB = 0xAAAA; // Valor inicial para el puerto B
	MOV	#43690, W0
	MOV	WREG, LATB
;Programa26a.c,14 :: 		IPC0 = IPC0 | 0x1000; // Nivel de prioridad como 1
	MOV	#4096, W1
	MOV	#lo_addr(IPC0), W0
	IOR	W1, [W0], [W0]
;Programa26a.c,15 :: 		IEC0 = IEC0 | 0x0008; // Interrupción del Timer1 habilitado
	MOV	#8, W1
	MOV	#lo_addr(IEC0), W0
	IOR	W1, [W0], [W0]
;Programa26a.c,16 :: 		PR1 = 5000; // Período de la interrupción es de 10000 ciclos
	MOV	#5000, W0
	MOV	WREG, PR1
;Programa26a.c,17 :: 		T1CON = 0x8030; // Timer1 habilitado(reloj interno divido para 256)
	MOV	#32816, W0
	MOV	WREG, T1CON
;Programa26a.c,18 :: 		while(1) asm nop; // Bucle infinito
L_main0:
	NOP
	GOTO	L_main0
;Programa26a.c,19 :: 		}
L_end_main:
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main
