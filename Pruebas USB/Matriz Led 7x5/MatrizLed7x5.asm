
_main:

;MatrizLed7x5.c,64 :: 		void main() {
;MatrizLed7x5.c,65 :: 		LATB=0x7F;
	MOVLW       127
	MOVWF       LATB+0 
;MatrizLed7x5.c,66 :: 		TRISB = 0x00;
	CLRF        TRISB+0 
;MatrizLed7x5.c,67 :: 		LATD=0x00;
	CLRF        LATD+0 
;MatrizLed7x5.c,68 :: 		TRISD=0x00;
	CLRF        TRISD+0 
;MatrizLed7x5.c,69 :: 		CargarSalida(frase);
	MOVLW       _frase+0
	MOVWF       FARG_CargarSalida_M+0 
	MOVLW       hi_addr(_frase+0)
	MOVWF       FARG_CargarSalida_M+1 
	CALL        _CargarSalida+0, 0
;MatrizLed7x5.c,71 :: 		while (1){
L_main0:
;MatrizLed7x5.c,72 :: 		MostrarMatriz(MatrizLED);
	MOVLW       _MatrizLED+0
	MOVWF       FARG_MostrarMatriz_L+0 
	MOVLW       hi_addr(_MatrizLED+0)
	MOVWF       FARG_MostrarMatriz_L+1 
	CALL        _MostrarMatriz+0, 0
;MatrizLed7x5.c,73 :: 		}
	GOTO        L_main0
;MatrizLed7x5.c,74 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_CargarSalida:

;MatrizLed7x5.c,76 :: 		void CargarSalida(char *M){
;MatrizLed7x5.c,80 :: 		k=0;
	CLRF        CargarSalida_k_L0+0 
	CLRF        CargarSalida_k_L0+1 
;MatrizLed7x5.c,81 :: 		for (i=0; i<41; i++){
	CLRF        _i+0 
L_CargarSalida2:
	MOVLW       41
	SUBWF       _i+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_CargarSalida3
;MatrizLed7x5.c,82 :: 		if (*(M+i)==0) {
	MOVF        _i+0, 0 
	ADDWF       FARG_CargarSalida_M+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_CargarSalida_M+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_CargarSalida5
;MatrizLed7x5.c,83 :: 		break;
	GOTO        L_CargarSalida3
;MatrizLed7x5.c,84 :: 		} else if (*(M+i)>64) {
L_CargarSalida5:
	MOVF        _i+0, 0 
	ADDWF       FARG_CargarSalida_M+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_CargarSalida_M+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	SUBLW       64
	BTFSC       STATUS+0, 0 
	GOTO        L_CargarSalida7
;MatrizLed7x5.c,85 :: 		indice=*(M+i)-65;
	MOVF        _i+0, 0 
	ADDWF       FARG_CargarSalida_M+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_CargarSalida_M+1, 0 
	MOVWF       FSR0H 
	MOVLW       65
	SUBWF       POSTINC0+0, 0 
	MOVWF       CargarSalida_indice_L0+0 
;MatrizLed7x5.c,86 :: 		for (j=0;j<5;j++) {
	CLRF        CargarSalida_j_L0+0 
	CLRF        CargarSalida_j_L0+1 
L_CargarSalida8:
	MOVLW       128
	XORWF       CargarSalida_j_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__CargarSalida18
	MOVLW       5
	SUBWF       CargarSalida_j_L0+0, 0 
L__CargarSalida18:
	BTFSC       STATUS+0, 0 
	GOTO        L_CargarSalida9
;MatrizLed7x5.c,87 :: 		if (Alfabeto[indice][j] != 0) {
	MOVLW       5
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVWF       R2 
	MOVWF       R3 
	MOVF        CargarSalida_indice_L0+0, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVLW       _Alfabeto+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_Alfabeto+0)
	ADDWFC      R1, 1 
	MOVLW       higher_addr(_Alfabeto+0)
	ADDWFC      R2, 1 
	MOVF        CargarSalida_j_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       TBLPTRL 
	MOVF        CargarSalida_j_L0+1, 0 
	ADDWFC      R1, 0 
	MOVWF       TBLPTRH 
	MOVLW       0
	BTFSC       CargarSalida_j_L0+1, 7 
	MOVLW       255
	ADDWFC      R2, 0 
	MOVWF       TBLPTRU 
	TBLRD*+
	MOVFF       TABLAT+0, R1
	MOVF        R1, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_CargarSalida11
;MatrizLed7x5.c,88 :: 		*(MatrizLED+k)=Alfabeto[indice][j];
	MOVLW       _MatrizLED+0
	ADDWF       CargarSalida_k_L0+0, 0 
	MOVWF       FLOC__CargarSalida+0 
	MOVLW       hi_addr(_MatrizLED+0)
	ADDWFC      CargarSalida_k_L0+1, 0 
	MOVWF       FLOC__CargarSalida+1 
	MOVLW       5
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVWF       R2 
	MOVWF       R3 
	MOVF        CargarSalida_indice_L0+0, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVLW       _Alfabeto+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_Alfabeto+0)
	ADDWFC      R1, 1 
	MOVLW       higher_addr(_Alfabeto+0)
	ADDWFC      R2, 1 
	MOVF        CargarSalida_j_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       TBLPTRL 
	MOVF        CargarSalida_j_L0+1, 0 
	ADDWFC      R1, 0 
	MOVWF       TBLPTRH 
	MOVLW       0
	BTFSC       CargarSalida_j_L0+1, 7 
	MOVLW       255
	ADDWFC      R2, 0 
	MOVWF       TBLPTRU 
	TBLRD*+
	MOVFF       TABLAT+0, R0
	MOVFF       FLOC__CargarSalida+0, FSR1
	MOVFF       FLOC__CargarSalida+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;MatrizLed7x5.c,89 :: 		k++;
	INFSNZ      CargarSalida_k_L0+0, 1 
	INCF        CargarSalida_k_L0+1, 1 
;MatrizLed7x5.c,90 :: 		}
L_CargarSalida11:
;MatrizLed7x5.c,86 :: 		for (j=0;j<5;j++) {
	INFSNZ      CargarSalida_j_L0+0, 1 
	INCF        CargarSalida_j_L0+1, 1 
;MatrizLed7x5.c,91 :: 		}
	GOTO        L_CargarSalida8
L_CargarSalida9:
;MatrizLed7x5.c,92 :: 		*(MatrizLED+k)=0;
	MOVLW       _MatrizLED+0
	ADDWF       CargarSalida_k_L0+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_MatrizLED+0)
	ADDWFC      CargarSalida_k_L0+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;MatrizLed7x5.c,93 :: 		k++;
	INFSNZ      CargarSalida_k_L0+0, 1 
	INCF        CargarSalida_k_L0+1, 1 
;MatrizLed7x5.c,94 :: 		}
L_CargarSalida7:
;MatrizLed7x5.c,81 :: 		for (i=0; i<41; i++){
	INCF        _i+0, 1 
;MatrizLed7x5.c,95 :: 		}
	GOTO        L_CargarSalida2
L_CargarSalida3:
;MatrizLed7x5.c,96 :: 		}
L_end_CargarSalida:
	RETURN      0
; end of _CargarSalida

_MostrarMatriz:

;MatrizLed7x5.c,97 :: 		void MostrarMatriz(char *L){
;MatrizLed7x5.c,98 :: 		for (i = 20; i<27; i++ ){
	MOVLW       20
	MOVWF       _i+0 
L_MostrarMatriz12:
	MOVLW       27
	SUBWF       _i+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_MostrarMatriz13
;MatrizLed7x5.c,99 :: 		LATD=0x00;
	CLRF        LATD+0 
;MatrizLed7x5.c,100 :: 		asm rrncf LATB,1;
	RRNCF       LATB+0, 1, 1
;MatrizLed7x5.c,101 :: 		LATD=*(L+i);
	MOVF        _i+0, 0 
	ADDWF       FARG_MostrarMatriz_L+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_MostrarMatriz_L+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       LATD+0 
;MatrizLed7x5.c,102 :: 		delay_us(10);
	MOVLW       39
	MOVWF       R13, 0
L_MostrarMatriz15:
	DECFSZ      R13, 1, 1
	BRA         L_MostrarMatriz15
	NOP
	NOP
;MatrizLed7x5.c,98 :: 		for (i = 20; i<27; i++ ){
	INCF        _i+0, 1 
;MatrizLed7x5.c,103 :: 		}
	GOTO        L_MostrarMatriz12
L_MostrarMatriz13:
;MatrizLed7x5.c,104 :: 		LATB=0x7F;
	MOVLW       127
	MOVWF       LATB+0 
;MatrizLed7x5.c,105 :: 		}
L_end_MostrarMatriz:
	RETURN      0
; end of _MostrarMatriz
