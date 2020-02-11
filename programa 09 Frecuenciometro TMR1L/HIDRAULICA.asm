
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;HIDRAULICA.c,22 :: 		interrupt(){
;HIDRAULICA.c,23 :: 		if(CCP1IF_bit){
	BTFSS      CCP1IF_bit+0, BitPos(CCP1IF_bit+0)
	GOTO       L_interrupt0
;HIDRAULICA.c,25 :: 		CCP1IF_bit=0;     //Borra la interrupcion externa 0
	BCF        CCP1IF_bit+0, BitPos(CCP1IF_bit+0)
;HIDRAULICA.c,26 :: 		TMR1L=0X00;
	CLRF       TMR1L+0
;HIDRAULICA.c,27 :: 		TMR1H=0X00;
	CLRF       TMR1H+0
;HIDRAULICA.c,28 :: 		*(puntero)= CCPR1L;
	MOVF       _puntero+0, 0
	MOVWF      FSR
	MOVF       CCPR1L+0, 0
	MOVWF      INDF+0
;HIDRAULICA.c,29 :: 		*(puntero+1)= CCPR1H;
	INCF       _puntero+0, 0
	MOVWF      FSR
	MOVF       CCPR1H+0, 0
	MOVWF      INDF+0
;HIDRAULICA.c,32 :: 		distancia=contador;
	MOVF       _contador+0, 0
	MOVWF      _distancia+0
	MOVF       _contador+1, 0
	MOVWF      _distancia+1
	MOVF       _contador+2, 0
	MOVWF      _distancia+2
	MOVF       _contador+3, 0
	MOVWF      _distancia+3
;HIDRAULICA.c,33 :: 		contador=0;
	CLRF       _contador+0
	CLRF       _contador+1
	CLRF       _contador+2
	CLRF       _contador+3
;HIDRAULICA.c,35 :: 		bandera=1;
	BSF        _bandera+0, BitPos(_bandera+0)
;HIDRAULICA.c,36 :: 		}
L_interrupt0:
;HIDRAULICA.c,37 :: 		if(TMR1IF_bit){
	BTFSS      TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
	GOTO       L_interrupt1
;HIDRAULICA.c,38 :: 		TMR1IF_bit=0;     //Borra la interrupcion externa 0
	BCF        TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
;HIDRAULICA.c,39 :: 		*(puntero16+1)=*(puntero16+1)+1;
	MOVLW      2
	ADDWF      _puntero16+0, 0
	MOVWF      R2+0
	MOVLW      2
	ADDWF      _puntero16+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	ADDLW      1
	MOVWF      R0+0
	MOVLW      0
	BTFSC      STATUS+0, 0
	ADDLW      1
	INCF       FSR, 1
	ADDWF      INDF+0, 0
	MOVWF      R0+1
	MOVF       R2+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
	MOVF       R0+1, 0
	INCF       FSR, 1
	MOVWF      INDF+0
;HIDRAULICA.c,40 :: 		}
L_interrupt1:
;HIDRAULICA.c,41 :: 		}
L_end_interrupt:
L__interrupt9:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;HIDRAULICA.c,43 :: 		void main() {
;HIDRAULICA.c,45 :: 		Lcd_init();
	CALL       _Lcd_Init+0
;HIDRAULICA.c,46 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;HIDRAULICA.c,47 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;HIDRAULICA.c,49 :: 		Lcd_Out(1,1,"Hola.");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_HIDRAULICA+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HIDRAULICA.c,52 :: 		GIE_bit=1;        //Habilitadas las interrupciones
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;HIDRAULICA.c,53 :: 		PEIE_bit=1;
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;HIDRAULICA.c,54 :: 		CCP1IE_bit=1;     //Habilitada la interrupcion externa 0
	BSF        CCP1IE_bit+0, BitPos(CCP1IE_bit+0)
;HIDRAULICA.c,55 :: 		TMR1IE_bit=1;     //Habilitada la interrupcion externa 0
	BSF        TMR1IE_bit+0, BitPos(TMR1IE_bit+0)
;HIDRAULICA.c,56 :: 		TRISC2_bit=1;
	BSF        TRISC2_bit+0, BitPos(TRISC2_bit+0)
;HIDRAULICA.c,57 :: 		TRISC7_bit=0;
	BCF        TRISC7_bit+0, BitPos(TRISC7_bit+0)
;HIDRAULICA.c,58 :: 		T1CON=0x01;       //Configuracion en 16 bits, escalad por 1 y encendido del timer 1
	MOVLW      1
	MOVWF      T1CON+0
;HIDRAULICA.c,59 :: 		CCP1CON=0b00000101;               //Configuración del CCP1   CCP1CON=0b00000101 cada flanco de subida ;
	MOVLW      5
	MOVWF      CCP1CON+0
;HIDRAULICA.c,60 :: 		puntero16=&contador;
	MOVLW      _contador+0
	MOVWF      _puntero16+0
;HIDRAULICA.c,61 :: 		puntero=&contador;
	MOVLW      _contador+0
	MOVWF      _puntero+0
;HIDRAULICA.c,62 :: 		bandera=0;
	BCF        _bandera+0, BitPos(_bandera+0)
;HIDRAULICA.c,63 :: 		TMR1ON_bit=1;
	BSF        TMR1ON_bit+0, BitPos(TMR1ON_bit+0)
;HIDRAULICA.c,64 :: 		while(1){
L_main2:
;HIDRAULICA.c,66 :: 		if(bandera){
	BTFSS      _bandera+0, BitPos(_bandera+0)
	GOTO       L_main4
;HIDRAULICA.c,68 :: 		bandera=0;
	BCF        _bandera+0, BitPos(_bandera+0)
;HIDRAULICA.c,69 :: 		frecuencia=1000000./distancia;
	MOVF       _distancia+0, 0
	MOVWF      R0+0
	MOVF       _distancia+1, 0
	MOVWF      R0+1
	MOVF       _distancia+2, 0
	MOVWF      R0+2
	MOVF       _distancia+3, 0
	MOVWF      R0+3
	CALL       _longint2double+0
	MOVF       R0+0, 0
	MOVWF      R4+0
	MOVF       R0+1, 0
	MOVWF      R4+1
	MOVF       R0+2, 0
	MOVWF      R4+2
	MOVF       R0+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      36
	MOVWF      R0+1
	MOVLW      116
	MOVWF      R0+2
	MOVLW      146
	MOVWF      R0+3
	CALL       _Div_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _frecuencia+0
	MOVF       R0+1, 0
	MOVWF      _frecuencia+1
	MOVF       R0+2, 0
	MOVWF      _frecuencia+2
	MOVF       R0+3, 0
	MOVWF      _frecuencia+3
;HIDRAULICA.c,70 :: 		floatToStr(frecuencia, txt1);
	MOVF       R0+0, 0
	MOVWF      FARG_FloatToStr_fnum+0
	MOVF       R0+1, 0
	MOVWF      FARG_FloatToStr_fnum+1
	MOVF       R0+2, 0
	MOVWF      FARG_FloatToStr_fnum+2
	MOVF       R0+3, 0
	MOVWF      FARG_FloatToStr_fnum+3
	MOVLW      _txt1+0
	MOVWF      FARG_FloatToStr_str+0
	CALL       _FloatToStr+0
;HIDRAULICA.c,71 :: 		Lcd_Out(2,1,txt1); Lcd_out_cp("Hz     ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt1+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
	MOVLW      ?lstr2_HIDRAULICA+0
	MOVWF      FARG_Lcd_Out_CP_text+0
	CALL       _Lcd_Out_CP+0
;HIDRAULICA.c,72 :: 		delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_main5:
	DECFSZ     R13+0, 1
	GOTO       L_main5
	DECFSZ     R12+0, 1
	GOTO       L_main5
	NOP
;HIDRAULICA.c,73 :: 		}
	GOTO       L_main6
L_main4:
;HIDRAULICA.c,75 :: 		RC7_bit=~RC7_bit;
	MOVLW
	XORWF      RC7_bit+0, 1
;HIDRAULICA.c,76 :: 		delay_us(10);
	MOVLW      6
	MOVWF      R13+0
L_main7:
	DECFSZ     R13+0, 1
	GOTO       L_main7
	NOP
;HIDRAULICA.c,77 :: 		}
L_main6:
;HIDRAULICA.c,80 :: 		}
	GOTO       L_main2
;HIDRAULICA.c,81 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
