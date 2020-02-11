
_Timer1Int:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;Programa26d.c,12 :: 		void Timer1Int() org 0x1A{// Direccion del Timer1 en la tabla de vectores de interrupciòn
;Programa26d.c,13 :: 		LATB = TMR1; // La duración del Pulso es desplegado en el puerto B
	MOV	TMR1, WREG
	MOV	WREG, LATB
;Programa26d.c,14 :: 		TMR1=0;
	CLR	TMR1
;Programa26d.c,15 :: 		IFS0 = IFS0 & 0xFFF7; // Borrado de la bandera de Interrupción
	MOV	#65527, W1
	MOV	#lo_addr(IFS0), W0
	AND	W1, [W0], [W0]
;Programa26d.c,16 :: 		}
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

;Programa26d.c,17 :: 		main(){
;Programa26d.c,18 :: 		TRISB = 0x0000; // PORTB como salida
	CLR	TRISB
;Programa26d.c,19 :: 		TRISA = 0x0010; // El pin PORTA<4>=1 T1CK es entrada
	MOV	#16, W0
	MOV	WREG, TRISA
;Programa26d.c,20 :: 		LATB = 0x0000; // Valor inicial para el puerto B
	CLR	LATB
;Programa26d.c,21 :: 		IPC0 = IPC0 | 0x1000; // Nivel de prioridad como 1
	MOV	#4096, W1
	MOV	#lo_addr(IPC0), W0
	IOR	W1, [W0], [W0]
;Programa26d.c,22 :: 		IEC0 = IEC0 | 0x0008; // Interrupción del Timer1 habilitado
	MOV	#8, W1
	MOV	#lo_addr(IEC0), W0
	IOR	W1, [W0], [W0]
;Programa26d.c,23 :: 		TMR1=0;
	CLR	TMR1
;Programa26d.c,24 :: 		PR1 = 0xFFFF; // Periodo es el máximo
	MOV	#65535, W0
	MOV	WREG, PR1
;Programa26d.c,25 :: 		T1CON = 0x8040; // Timer1 está habilitado, reloj interno está bajo T1CK=1
	MOV	#32832, W0
	MOV	WREG, T1CON
;Programa26d.c,26 :: 		while (1) asm nop; // Bucle infinito
L_main0:
	NOP
	GOTO	L_main0
;Programa26d.c,27 :: 		}
L_end_main:
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main
