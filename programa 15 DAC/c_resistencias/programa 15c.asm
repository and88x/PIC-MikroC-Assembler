
_main:

;programa 15c.c,9 :: 		void main( void )
;programa 15c.c,12 :: 		unsigned short n=0;
	CLRF        main_n_L0+0 
;programa 15c.c,14 :: 		TRISC = 0;
	CLRF        TRISC+0 
;programa 15c.c,15 :: 		PORTC = 127;
	MOVLW       127
	MOVWF       PORTC+0 
;programa 15c.c,16 :: 		while(1) //Bucle infinito.
L_main0:
;programa 15c.c,20 :: 		for( n=0; n<20; n++ )
	CLRF        main_n_L0+0 
L_main2:
	MOVLW       20
	SUBWF       main_n_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main3
;programa 15c.c,23 :: 		PORTC = Seno[n];
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
	MOVFF       TABLAT+0, PORTC+0
;programa 15c.c,25 :: 		delay_us(50);
	MOVLW       33
	MOVWF       R13, 0
L_main5:
	DECFSZ      R13, 1, 1
	BRA         L_main5
;programa 15c.c,20 :: 		for( n=0; n<20; n++ )
	INCF        main_n_L0+0, 1 
;programa 15c.c,26 :: 		}
	GOTO        L_main2
L_main3:
;programa 15c.c,27 :: 		}
	GOTO        L_main0
;programa 15c.c,28 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
