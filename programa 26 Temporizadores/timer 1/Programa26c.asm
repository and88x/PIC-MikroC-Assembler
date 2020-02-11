
_Timer1Int:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;Programa26c.c,8 :: 		void Timer1Int() org 0x1A{ // Direccion del Timer1 en la tabla de vectores de interrupciòn
;Programa26c.c,9 :: 		LATB++; // Valor del PORTB es incrementado
	MOV	LATB, WREG
	INC	W0
	MOV	WREG, LATB
;Programa26c.c,10 :: 		IFS0 = IFS0 & 0xFFF7; // Borrado de la bandera de Interrupción
	MOV	#65527, W1
	MOV	#lo_addr(IFS0), W0
	AND	W1, [W0], [W0]
;Programa26c.c,11 :: 		}
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

;Programa26c.c,12 :: 		void main(){
;Programa26c.c,13 :: 		TRISB = 0x0000; // PORTB como salida
	CLR	TRISB
;Programa26c.c,14 :: 		TRISA = 0x0010; // El pin PORTA<4>=1 T1CK es entrada
	MOV	#16, W0
	MOV	WREG, TRISA
;Programa26c.c,15 :: 		LATB = 0x0000; // Valor inicial para el puerto B
	CLR	LATB
;Programa26c.c,16 :: 		IPC0 = IPC0 | 0x1000; // Nivel de prioridad como 1
	MOV	#4096, W1
	MOV	#lo_addr(IPC0), W0
	IOR	W1, [W0], [W0]
;Programa26c.c,17 :: 		IEC0 = IEC0 | 0x0008; // Interrupción del Timer1 habilitado
	MOV	#8, W1
	MOV	#lo_addr(IEC0), W0
	IOR	W1, [W0], [W0]
;Programa26c.c,18 :: 		PR1 = 100; // Período de la interrupción es de 100 ciclos
	MOV	#100, W0
	MOV	WREG, PR1
;Programa26c.c,19 :: 		T1CON = 0x8012; // Timer1 es un contador sincrono de pulsos externos
	MOV	#32786, W0
	MOV	WREG, T1CON
;Programa26c.c,20 :: 		while(1) asm nop; // Bucle infinito
L_main0:
	NOP
	GOTO	L_main0
;Programa26c.c,21 :: 		}
L_end_main:
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main
