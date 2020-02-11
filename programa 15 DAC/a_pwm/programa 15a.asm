
_main:

;programa 15a.c,10 :: 		void main( void )
;programa 15a.c,13 :: 		unsigned short n=0;
	CLRF        main_n_L0+0 
;programa 15a.c,15 :: 		PWM1_Init(15625);   //averiguar por que este valor
	BCF         T2CON+0, 0, 0
	BCF         T2CON+0, 1, 0
	MOVLW       127
	MOVWF       PR2+0, 0
	CALL        _PWM1_Init+0, 0
;programa 15a.c,18 :: 		PWM1_Start();
	CALL        _PWM1_Start+0, 0
;programa 15a.c,20 :: 		while(1) //Bucle infinito.
L_main0:
;programa 15a.c,24 :: 		for( n=0; n<20; n++ )
	CLRF        main_n_L0+0 
L_main2:
	MOVLW       20
	SUBWF       main_n_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main3
;programa 15a.c,27 :: 		PWM1_Set_Duty( Seno[n] );
	MOVLW       _Seno+0
	ADDWF       main_n_L0+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_Seno+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_Seno+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_PWM1_Set_Duty_new_duty+0
	CALL        _PWM1_Set_Duty+0, 0
;programa 15a.c,29 :: 		delay_us(50);
	MOVLW       33
	MOVWF       R13, 0
L_main5:
	DECFSZ      R13, 1, 1
	BRA         L_main5
;programa 15a.c,24 :: 		for( n=0; n<20; n++ )
	INCF        main_n_L0+0, 1 
;programa 15a.c,30 :: 		}
	GOTO        L_main2
L_main3:
;programa 15a.c,31 :: 		}
	GOTO        L_main0
;programa 15a.c,34 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
