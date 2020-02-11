
_SI3:

;programa 17.c,2 :: 		void SI3(int t){
;programa 17.c,3 :: 		Sound_Play(246, t);
	MOVLW       246
	MOVWF       FARG_Sound_Play_freq_in_hz+0 
	MOVLW       0
	MOVWF       FARG_Sound_Play_freq_in_hz+1 
	MOVF        FARG_SI3_t+0, 0 
	MOVWF       FARG_Sound_Play_duration_ms+0 
	MOVF        FARG_SI3_t+1, 0 
	MOVWF       FARG_Sound_Play_duration_ms+1 
	CALL        _Sound_Play+0, 0
;programa 17.c,4 :: 		}
L_end_SI3:
	RETURN      0
; end of _SI3

_DO:

;programa 17.c,5 :: 		void DO(int t){
;programa 17.c,6 :: 		Sound_Play(262, t);
	MOVLW       6
	MOVWF       FARG_Sound_Play_freq_in_hz+0 
	MOVLW       1
	MOVWF       FARG_Sound_Play_freq_in_hz+1 
	MOVF        FARG_DO_t+0, 0 
	MOVWF       FARG_Sound_Play_duration_ms+0 
	MOVF        FARG_DO_t+1, 0 
	MOVWF       FARG_Sound_Play_duration_ms+1 
	CALL        _Sound_Play+0, 0
;programa 17.c,7 :: 		}
L_end_DO:
	RETURN      0
; end of _DO

_DO_s:

;programa 17.c,8 :: 		void DO_s(int t){
;programa 17.c,9 :: 		Sound_Play(277, t);
	MOVLW       21
	MOVWF       FARG_Sound_Play_freq_in_hz+0 
	MOVLW       1
	MOVWF       FARG_Sound_Play_freq_in_hz+1 
	MOVF        FARG_DO_s_t+0, 0 
	MOVWF       FARG_Sound_Play_duration_ms+0 
	MOVF        FARG_DO_s_t+1, 0 
	MOVWF       FARG_Sound_Play_duration_ms+1 
	CALL        _Sound_Play+0, 0
;programa 17.c,10 :: 		}
L_end_DO_s:
	RETURN      0
; end of _DO_s

_RE:

;programa 17.c,11 :: 		void RE(int t){
;programa 17.c,12 :: 		Sound_Play(293, t);
	MOVLW       37
	MOVWF       FARG_Sound_Play_freq_in_hz+0 
	MOVLW       1
	MOVWF       FARG_Sound_Play_freq_in_hz+1 
	MOVF        FARG_RE_t+0, 0 
	MOVWF       FARG_Sound_Play_duration_ms+0 
	MOVF        FARG_RE_t+1, 0 
	MOVWF       FARG_Sound_Play_duration_ms+1 
	CALL        _Sound_Play+0, 0
;programa 17.c,13 :: 		}
L_end_RE:
	RETURN      0
; end of _RE

_RE_s:

;programa 17.c,14 :: 		void RE_s(int t){
;programa 17.c,15 :: 		Sound_Play(311, t);
	MOVLW       55
	MOVWF       FARG_Sound_Play_freq_in_hz+0 
	MOVLW       1
	MOVWF       FARG_Sound_Play_freq_in_hz+1 
	MOVF        FARG_RE_s_t+0, 0 
	MOVWF       FARG_Sound_Play_duration_ms+0 
	MOVF        FARG_RE_s_t+1, 0 
	MOVWF       FARG_Sound_Play_duration_ms+1 
	CALL        _Sound_Play+0, 0
;programa 17.c,16 :: 		}
L_end_RE_s:
	RETURN      0
; end of _RE_s

_MI:

;programa 17.c,17 :: 		void MI(int t){
;programa 17.c,18 :: 		Sound_Play(330, t);
	MOVLW       74
	MOVWF       FARG_Sound_Play_freq_in_hz+0 
	MOVLW       1
	MOVWF       FARG_Sound_Play_freq_in_hz+1 
	MOVF        FARG_MI_t+0, 0 
	MOVWF       FARG_Sound_Play_duration_ms+0 
	MOVF        FARG_MI_t+1, 0 
	MOVWF       FARG_Sound_Play_duration_ms+1 
	CALL        _Sound_Play+0, 0
;programa 17.c,19 :: 		}
L_end_MI:
	RETURN      0
; end of _MI

_FA:

;programa 17.c,20 :: 		void FA(int t){
;programa 17.c,21 :: 		Sound_Play(349, t);
	MOVLW       93
	MOVWF       FARG_Sound_Play_freq_in_hz+0 
	MOVLW       1
	MOVWF       FARG_Sound_Play_freq_in_hz+1 
	MOVF        FARG_FA_t+0, 0 
	MOVWF       FARG_Sound_Play_duration_ms+0 
	MOVF        FARG_FA_t+1, 0 
	MOVWF       FARG_Sound_Play_duration_ms+1 
	CALL        _Sound_Play+0, 0
;programa 17.c,22 :: 		}
L_end_FA:
	RETURN      0
; end of _FA

_FA_s:

;programa 17.c,23 :: 		void FA_s(int t){
;programa 17.c,24 :: 		Sound_Play(369, t);
	MOVLW       113
	MOVWF       FARG_Sound_Play_freq_in_hz+0 
	MOVLW       1
	MOVWF       FARG_Sound_Play_freq_in_hz+1 
	MOVF        FARG_FA_s_t+0, 0 
	MOVWF       FARG_Sound_Play_duration_ms+0 
	MOVF        FARG_FA_s_t+1, 0 
	MOVWF       FARG_Sound_Play_duration_ms+1 
	CALL        _Sound_Play+0, 0
;programa 17.c,25 :: 		}
L_end_FA_s:
	RETURN      0
; end of _FA_s

_SOL:

;programa 17.c,26 :: 		void SOL(int t){
;programa 17.c,27 :: 		Sound_Play(391, t);
	MOVLW       135
	MOVWF       FARG_Sound_Play_freq_in_hz+0 
	MOVLW       1
	MOVWF       FARG_Sound_Play_freq_in_hz+1 
	MOVF        FARG_SOL_t+0, 0 
	MOVWF       FARG_Sound_Play_duration_ms+0 
	MOVF        FARG_SOL_t+1, 0 
	MOVWF       FARG_Sound_Play_duration_ms+1 
	CALL        _Sound_Play+0, 0
;programa 17.c,28 :: 		}
L_end_SOL:
	RETURN      0
; end of _SOL

_SOL_s:

;programa 17.c,29 :: 		void SOL_s(int t){
;programa 17.c,30 :: 		Sound_Play(415, t);
	MOVLW       159
	MOVWF       FARG_Sound_Play_freq_in_hz+0 
	MOVLW       1
	MOVWF       FARG_Sound_Play_freq_in_hz+1 
	MOVF        FARG_SOL_s_t+0, 0 
	MOVWF       FARG_Sound_Play_duration_ms+0 
	MOVF        FARG_SOL_s_t+1, 0 
	MOVWF       FARG_Sound_Play_duration_ms+1 
	CALL        _Sound_Play+0, 0
;programa 17.c,31 :: 		}
L_end_SOL_s:
	RETURN      0
; end of _SOL_s

_LA:

;programa 17.c,32 :: 		void LA(int t){
;programa 17.c,33 :: 		Sound_Play(440, t);
	MOVLW       184
	MOVWF       FARG_Sound_Play_freq_in_hz+0 
	MOVLW       1
	MOVWF       FARG_Sound_Play_freq_in_hz+1 
	MOVF        FARG_LA_t+0, 0 
	MOVWF       FARG_Sound_Play_duration_ms+0 
	MOVF        FARG_LA_t+1, 0 
	MOVWF       FARG_Sound_Play_duration_ms+1 
	CALL        _Sound_Play+0, 0
;programa 17.c,34 :: 		}
L_end_LA:
	RETURN      0
; end of _LA

_LA_s:

;programa 17.c,35 :: 		void LA_s(int t){
;programa 17.c,36 :: 		Sound_Play(466, t);
	MOVLW       210
	MOVWF       FARG_Sound_Play_freq_in_hz+0 
	MOVLW       1
	MOVWF       FARG_Sound_Play_freq_in_hz+1 
	MOVF        FARG_LA_s_t+0, 0 
	MOVWF       FARG_Sound_Play_duration_ms+0 
	MOVF        FARG_LA_s_t+1, 0 
	MOVWF       FARG_Sound_Play_duration_ms+1 
	CALL        _Sound_Play+0, 0
;programa 17.c,37 :: 		}
L_end_LA_s:
	RETURN      0
; end of _LA_s

_Si:

;programa 17.c,38 :: 		void Si(int t){
;programa 17.c,39 :: 		Sound_Play(494, t);
	MOVLW       238
	MOVWF       FARG_Sound_Play_freq_in_hz+0 
	MOVLW       1
	MOVWF       FARG_Sound_Play_freq_in_hz+1 
	MOVF        FARG_Si_t+0, 0 
	MOVWF       FARG_Sound_Play_duration_ms+0 
	MOVF        FARG_Si_t+1, 0 
	MOVWF       FARG_Sound_Play_duration_ms+1 
	CALL        _Sound_Play+0, 0
;programa 17.c,40 :: 		}
L_end_Si:
	RETURN      0
; end of _Si

_LA3:

;programa 17.c,41 :: 		void LA3(int t){
;programa 17.c,42 :: 		Sound_Play(220, t);
	MOVLW       220
	MOVWF       FARG_Sound_Play_freq_in_hz+0 
	MOVLW       0
	MOVWF       FARG_Sound_Play_freq_in_hz+1 
	MOVF        FARG_LA3_t+0, 0 
	MOVWF       FARG_Sound_Play_duration_ms+0 
	MOVF        FARG_LA3_t+1, 0 
	MOVWF       FARG_Sound_Play_duration_ms+1 
	CALL        _Sound_Play+0, 0
;programa 17.c,43 :: 		}
L_end_LA3:
	RETURN      0
; end of _LA3

_SOL3:

;programa 17.c,44 :: 		void SOL3(int t){
;programa 17.c,45 :: 		Sound_Play(196, t);
	MOVLW       196
	MOVWF       FARG_Sound_Play_freq_in_hz+0 
	MOVLW       0
	MOVWF       FARG_Sound_Play_freq_in_hz+1 
	MOVF        FARG_SOL3_t+0, 0 
	MOVWF       FARG_Sound_Play_duration_ms+0 
	MOVF        FARG_SOL3_t+1, 0 
	MOVWF       FARG_Sound_Play_duration_ms+1 
	CALL        _Sound_Play+0, 0
;programa 17.c,46 :: 		}
L_end_SOL3:
	RETURN      0
; end of _SOL3

_Tone1:

;programa 17.c,49 :: 		void Tone1() {
;programa 17.c,50 :: 		Sound_Play(659, 250); // Frecuencia = 659Hz, duración = 250ms
	MOVLW       147
	MOVWF       FARG_Sound_Play_freq_in_hz+0 
	MOVLW       2
	MOVWF       FARG_Sound_Play_freq_in_hz+1 
	MOVLW       250
	MOVWF       FARG_Sound_Play_duration_ms+0 
	MOVLW       0
	MOVWF       FARG_Sound_Play_duration_ms+1 
	CALL        _Sound_Play+0, 0
;programa 17.c,51 :: 		}
L_end_Tone1:
	RETURN      0
; end of _Tone1

_Tone2:

;programa 17.c,53 :: 		void Tone2() {
;programa 17.c,54 :: 		Sound_Play(698, 250); // Frecuencia = 698Hz, duración = 250ms
	MOVLW       186
	MOVWF       FARG_Sound_Play_freq_in_hz+0 
	MOVLW       2
	MOVWF       FARG_Sound_Play_freq_in_hz+1 
	MOVLW       250
	MOVWF       FARG_Sound_Play_duration_ms+0 
	MOVLW       0
	MOVWF       FARG_Sound_Play_duration_ms+1 
	CALL        _Sound_Play+0, 0
;programa 17.c,55 :: 		}
L_end_Tone2:
	RETURN      0
; end of _Tone2

_Tone3:

;programa 17.c,57 :: 		void Tone3() {
;programa 17.c,58 :: 		Sound_Play(784, 250); // Frecuencia = 784Hz, duración = 250ms
	MOVLW       16
	MOVWF       FARG_Sound_Play_freq_in_hz+0 
	MOVLW       3
	MOVWF       FARG_Sound_Play_freq_in_hz+1 
	MOVLW       250
	MOVWF       FARG_Sound_Play_duration_ms+0 
	MOVLW       0
	MOVWF       FARG_Sound_Play_duration_ms+1 
	CALL        _Sound_Play+0, 0
;programa 17.c,59 :: 		}
L_end_Tone3:
	RETURN      0
; end of _Tone3

_Melody1:

;programa 17.c,61 :: 		void Melody1() { // Componer una melodía divertida 1
;programa 17.c,62 :: 		Tone1(); Tone2(); Tone3(); Tone3();
	CALL        _Tone1+0, 0
	CALL        _Tone2+0, 0
	CALL        _Tone3+0, 0
	CALL        _Tone3+0, 0
;programa 17.c,63 :: 		Tone1(); Tone2(); Tone3(); Tone3();
	CALL        _Tone1+0, 0
	CALL        _Tone2+0, 0
	CALL        _Tone3+0, 0
	CALL        _Tone3+0, 0
;programa 17.c,64 :: 		Tone1(); Tone2(); Tone3();
	CALL        _Tone1+0, 0
	CALL        _Tone2+0, 0
	CALL        _Tone3+0, 0
;programa 17.c,65 :: 		Tone1(); Tone2(); Tone3(); Tone3();
	CALL        _Tone1+0, 0
	CALL        _Tone2+0, 0
	CALL        _Tone3+0, 0
	CALL        _Tone3+0, 0
;programa 17.c,66 :: 		Tone1(); Tone2(); Tone3();
	CALL        _Tone1+0, 0
	CALL        _Tone2+0, 0
	CALL        _Tone3+0, 0
;programa 17.c,67 :: 		Tone3(); Tone3(); Tone2(); Tone2(); Tone1();
	CALL        _Tone3+0, 0
	CALL        _Tone3+0, 0
	CALL        _Tone2+0, 0
	CALL        _Tone2+0, 0
	CALL        _Tone1+0, 0
;programa 17.c,68 :: 		}
L_end_Melody1:
	RETURN      0
; end of _Melody1

_dragon_ball_gt:

;programa 17.c,69 :: 		void dragon_ball_gt() {
;programa 17.c,70 :: 		int t2 = 260;
	MOVLW       4
	MOVWF       dragon_ball_gt_t2_L0+0 
	MOVLW       1
	MOVWF       dragon_ball_gt_t2_L0+1 
	MOVLW       130
	MOVWF       dragon_ball_gt_t_L0+0 
	MOVLW       0
	MOVWF       dragon_ball_gt_t_L0+1 
	MOVLW       134
	MOVWF       dragon_ball_gt_t3_L0+0 
	MOVLW       1
	MOVWF       dragon_ball_gt_t3_L0+1 
;programa 17.c,73 :: 		MI(t3); MI(t3); DO(t2); RE(t2); MI(t2); FA(t2);
	MOVF        dragon_ball_gt_t3_L0+0, 0 
	MOVWF       FARG_MI_t+0 
	MOVF        dragon_ball_gt_t3_L0+1, 0 
	MOVWF       FARG_MI_t+1 
	CALL        _MI+0, 0
	MOVF        dragon_ball_gt_t3_L0+0, 0 
	MOVWF       FARG_MI_t+0 
	MOVF        dragon_ball_gt_t3_L0+1, 0 
	MOVWF       FARG_MI_t+1 
	CALL        _MI+0, 0
	MOVF        dragon_ball_gt_t2_L0+0, 0 
	MOVWF       FARG_DO_t+0 
	MOVF        dragon_ball_gt_t2_L0+1, 0 
	MOVWF       FARG_DO_t+1 
	CALL        _DO+0, 0
	MOVF        dragon_ball_gt_t2_L0+0, 0 
	MOVWF       FARG_RE_t+0 
	MOVF        dragon_ball_gt_t2_L0+1, 0 
	MOVWF       FARG_RE_t+1 
	CALL        _RE+0, 0
	MOVF        dragon_ball_gt_t2_L0+0, 0 
	MOVWF       FARG_MI_t+0 
	MOVF        dragon_ball_gt_t2_L0+1, 0 
	MOVWF       FARG_MI_t+1 
	CALL        _MI+0, 0
	MOVF        dragon_ball_gt_t2_L0+0, 0 
	MOVWF       FARG_FA_t+0 
	MOVF        dragon_ball_gt_t2_L0+1, 0 
	MOVWF       FARG_FA_t+1 
	CALL        _FA+0, 0
;programa 17.c,74 :: 		MI(t3); RE(t3); DO(t3); SI3(t3);
	MOVF        dragon_ball_gt_t3_L0+0, 0 
	MOVWF       FARG_MI_t+0 
	MOVF        dragon_ball_gt_t3_L0+1, 0 
	MOVWF       FARG_MI_t+1 
	CALL        _MI+0, 0
	MOVF        dragon_ball_gt_t3_L0+0, 0 
	MOVWF       FARG_RE_t+0 
	MOVF        dragon_ball_gt_t3_L0+1, 0 
	MOVWF       FARG_RE_t+1 
	CALL        _RE+0, 0
	MOVF        dragon_ball_gt_t3_L0+0, 0 
	MOVWF       FARG_DO_t+0 
	MOVF        dragon_ball_gt_t3_L0+1, 0 
	MOVWF       FARG_DO_t+1 
	CALL        _DO+0, 0
	MOVF        dragon_ball_gt_t3_L0+0, 0 
	MOVWF       FARG_SI3_t+0 
	MOVF        dragon_ball_gt_t3_L0+1, 0 
	MOVWF       FARG_SI3_t+1 
	CALL        _SI3+0, 0
;programa 17.c,75 :: 		DO(t3); DO(t3); LA3(t2); SI3(t2); DO(t2); RE(t2);
	MOVF        dragon_ball_gt_t3_L0+0, 0 
	MOVWF       FARG_DO_t+0 
	MOVF        dragon_ball_gt_t3_L0+1, 0 
	MOVWF       FARG_DO_t+1 
	CALL        _DO+0, 0
	MOVF        dragon_ball_gt_t3_L0+0, 0 
	MOVWF       FARG_DO_t+0 
	MOVF        dragon_ball_gt_t3_L0+1, 0 
	MOVWF       FARG_DO_t+1 
	CALL        _DO+0, 0
	MOVF        dragon_ball_gt_t2_L0+0, 0 
	MOVWF       FARG_LA3_t+0 
	MOVF        dragon_ball_gt_t2_L0+1, 0 
	MOVWF       FARG_LA3_t+1 
	CALL        _LA3+0, 0
	MOVF        dragon_ball_gt_t2_L0+0, 0 
	MOVWF       FARG_SI3_t+0 
	MOVF        dragon_ball_gt_t2_L0+1, 0 
	MOVWF       FARG_SI3_t+1 
	CALL        _SI3+0, 0
	MOVF        dragon_ball_gt_t2_L0+0, 0 
	MOVWF       FARG_DO_t+0 
	MOVF        dragon_ball_gt_t2_L0+1, 0 
	MOVWF       FARG_DO_t+1 
	CALL        _DO+0, 0
	MOVF        dragon_ball_gt_t2_L0+0, 0 
	MOVWF       FARG_RE_t+0 
	MOVF        dragon_ball_gt_t2_L0+1, 0 
	MOVWF       FARG_RE_t+1 
	CALL        _RE+0, 0
;programa 17.c,76 :: 		DO(t3); SI3(t3); LA3(t3); SOL3(t3);
	MOVF        dragon_ball_gt_t3_L0+0, 0 
	MOVWF       FARG_DO_t+0 
	MOVF        dragon_ball_gt_t3_L0+1, 0 
	MOVWF       FARG_DO_t+1 
	CALL        _DO+0, 0
	MOVF        dragon_ball_gt_t3_L0+0, 0 
	MOVWF       FARG_SI3_t+0 
	MOVF        dragon_ball_gt_t3_L0+1, 0 
	MOVWF       FARG_SI3_t+1 
	CALL        _SI3+0, 0
	MOVF        dragon_ball_gt_t3_L0+0, 0 
	MOVWF       FARG_LA3_t+0 
	MOVF        dragon_ball_gt_t3_L0+1, 0 
	MOVWF       FARG_LA3_t+1 
	CALL        _LA3+0, 0
	MOVF        dragon_ball_gt_t3_L0+0, 0 
	MOVWF       FARG_SOL3_t+0 
	MOVF        dragon_ball_gt_t3_L0+1, 0 
	MOVWF       FARG_SOL3_t+1 
	CALL        _SOL3+0, 0
;programa 17.c,77 :: 		LA3(t*4); LA3(t2); DO(t2); FA(t3);
	MOVF        dragon_ball_gt_t_L0+0, 0 
	MOVWF       FARG_LA3_t+0 
	MOVF        dragon_ball_gt_t_L0+1, 0 
	MOVWF       FARG_LA3_t+1 
	RLCF        FARG_LA3_t+0, 1 
	BCF         FARG_LA3_t+0, 0 
	RLCF        FARG_LA3_t+1, 1 
	RLCF        FARG_LA3_t+0, 1 
	BCF         FARG_LA3_t+0, 0 
	RLCF        FARG_LA3_t+1, 1 
	CALL        _LA3+0, 0
	MOVF        dragon_ball_gt_t2_L0+0, 0 
	MOVWF       FARG_LA3_t+0 
	MOVF        dragon_ball_gt_t2_L0+1, 0 
	MOVWF       FARG_LA3_t+1 
	CALL        _LA3+0, 0
	MOVF        dragon_ball_gt_t2_L0+0, 0 
	MOVWF       FARG_DO_t+0 
	MOVF        dragon_ball_gt_t2_L0+1, 0 
	MOVWF       FARG_DO_t+1 
	CALL        _DO+0, 0
	MOVF        dragon_ball_gt_t3_L0+0, 0 
	MOVWF       FARG_FA_t+0 
	MOVF        dragon_ball_gt_t3_L0+1, 0 
	MOVWF       FARG_FA_t+1 
	CALL        _FA+0, 0
;programa 17.c,78 :: 		MI(t2); DO(t3); RE(t3); MI(t); FA(t); MI(t);
	MOVF        dragon_ball_gt_t2_L0+0, 0 
	MOVWF       FARG_MI_t+0 
	MOVF        dragon_ball_gt_t2_L0+1, 0 
	MOVWF       FARG_MI_t+1 
	CALL        _MI+0, 0
	MOVF        dragon_ball_gt_t3_L0+0, 0 
	MOVWF       FARG_DO_t+0 
	MOVF        dragon_ball_gt_t3_L0+1, 0 
	MOVWF       FARG_DO_t+1 
	CALL        _DO+0, 0
	MOVF        dragon_ball_gt_t3_L0+0, 0 
	MOVWF       FARG_RE_t+0 
	MOVF        dragon_ball_gt_t3_L0+1, 0 
	MOVWF       FARG_RE_t+1 
	CALL        _RE+0, 0
	MOVF        dragon_ball_gt_t_L0+0, 0 
	MOVWF       FARG_MI_t+0 
	MOVF        dragon_ball_gt_t_L0+1, 0 
	MOVWF       FARG_MI_t+1 
	CALL        _MI+0, 0
	MOVF        dragon_ball_gt_t_L0+0, 0 
	MOVWF       FARG_FA_t+0 
	MOVF        dragon_ball_gt_t_L0+1, 0 
	MOVWF       FARG_FA_t+1 
	CALL        _FA+0, 0
	MOVF        dragon_ball_gt_t_L0+0, 0 
	MOVWF       FARG_MI_t+0 
	MOVF        dragon_ball_gt_t_L0+1, 0 
	MOVWF       FARG_MI_t+1 
	CALL        _MI+0, 0
;programa 17.c,79 :: 		RE(t); DO(t); RE(t); DO(t3); DO(t2); SI3(t2); DO(t2);
	MOVF        dragon_ball_gt_t_L0+0, 0 
	MOVWF       FARG_RE_t+0 
	MOVF        dragon_ball_gt_t_L0+1, 0 
	MOVWF       FARG_RE_t+1 
	CALL        _RE+0, 0
	MOVF        dragon_ball_gt_t_L0+0, 0 
	MOVWF       FARG_DO_t+0 
	MOVF        dragon_ball_gt_t_L0+1, 0 
	MOVWF       FARG_DO_t+1 
	CALL        _DO+0, 0
	MOVF        dragon_ball_gt_t_L0+0, 0 
	MOVWF       FARG_RE_t+0 
	MOVF        dragon_ball_gt_t_L0+1, 0 
	MOVWF       FARG_RE_t+1 
	CALL        _RE+0, 0
	MOVF        dragon_ball_gt_t3_L0+0, 0 
	MOVWF       FARG_DO_t+0 
	MOVF        dragon_ball_gt_t3_L0+1, 0 
	MOVWF       FARG_DO_t+1 
	CALL        _DO+0, 0
	MOVF        dragon_ball_gt_t2_L0+0, 0 
	MOVWF       FARG_DO_t+0 
	MOVF        dragon_ball_gt_t2_L0+1, 0 
	MOVWF       FARG_DO_t+1 
	CALL        _DO+0, 0
	MOVF        dragon_ball_gt_t2_L0+0, 0 
	MOVWF       FARG_SI3_t+0 
	MOVF        dragon_ball_gt_t2_L0+1, 0 
	MOVWF       FARG_SI3_t+1 
	CALL        _SI3+0, 0
	MOVF        dragon_ball_gt_t2_L0+0, 0 
	MOVWF       FARG_DO_t+0 
	MOVF        dragon_ball_gt_t2_L0+1, 0 
	MOVWF       FARG_DO_t+1 
	CALL        _DO+0, 0
;programa 17.c,80 :: 		}
L_end_dragon_ball_gt:
	RETURN      0
; end of _dragon_ball_gt

_ToneA:

;programa 17.c,82 :: 		void ToneA() { // Tono A
;programa 17.c,83 :: 		Sound_Play( 880, 50);
	MOVLW       112
	MOVWF       FARG_Sound_Play_freq_in_hz+0 
	MOVLW       3
	MOVWF       FARG_Sound_Play_freq_in_hz+1 
	MOVLW       50
	MOVWF       FARG_Sound_Play_duration_ms+0 
	MOVLW       0
	MOVWF       FARG_Sound_Play_duration_ms+1 
	CALL        _Sound_Play+0, 0
;programa 17.c,84 :: 		}
L_end_ToneA:
	RETURN      0
; end of _ToneA

_ToneC:

;programa 17.c,86 :: 		void ToneC() { // Tono C
;programa 17.c,87 :: 		Sound_Play(1046, 50);
	MOVLW       22
	MOVWF       FARG_Sound_Play_freq_in_hz+0 
	MOVLW       4
	MOVWF       FARG_Sound_Play_freq_in_hz+1 
	MOVLW       50
	MOVWF       FARG_Sound_Play_duration_ms+0 
	MOVLW       0
	MOVWF       FARG_Sound_Play_duration_ms+1 
	CALL        _Sound_Play+0, 0
;programa 17.c,88 :: 		}
L_end_ToneC:
	RETURN      0
; end of _ToneC

_ToneE:

;programa 17.c,90 :: 		void ToneE() { // Tono E
;programa 17.c,91 :: 		Sound_Play(1318, 50);
	MOVLW       38
	MOVWF       FARG_Sound_Play_freq_in_hz+0 
	MOVLW       5
	MOVWF       FARG_Sound_Play_freq_in_hz+1 
	MOVLW       50
	MOVWF       FARG_Sound_Play_duration_ms+0 
	MOVLW       0
	MOVWF       FARG_Sound_Play_duration_ms+1 
	CALL        _Sound_Play+0, 0
;programa 17.c,92 :: 		}
L_end_ToneE:
	RETURN      0
; end of _ToneE

_Melody2:

;programa 17.c,94 :: 		void Melody2() { // Componer una melodía divertida 2
;programa 17.c,97 :: 		for (i = 9; i > 0; i--) {
	MOVLW       9
	MOVWF       Melody2_i_L0+0 
L_Melody20:
	MOVF        Melody2_i_L0+0, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_Melody21
;programa 17.c,98 :: 		ToneA(); ToneC(); ToneE();
	CALL        _ToneA+0, 0
	CALL        _ToneC+0, 0
	CALL        _ToneE+0, 0
;programa 17.c,97 :: 		for (i = 9; i > 0; i--) {
	DECF        Melody2_i_L0+0, 1 
;programa 17.c,99 :: 		}
	GOTO        L_Melody20
L_Melody21:
;programa 17.c,100 :: 		}
L_end_Melody2:
	RETURN      0
; end of _Melody2

_main:

;programa 17.c,102 :: 		void main() {
;programa 17.c,104 :: 		TRISC = 0x0F;                // Pines RB7-RB4 se configuran como entradas
	MOVLW       15
	MOVWF       TRISC+0 
;programa 17.c,107 :: 		Sound_Init(&PORTD, 3);
	MOVLW       PORTD+0
	MOVWF       FARG_Sound_Init_snd_port+0 
	MOVLW       hi_addr(PORTD+0)
	MOVWF       FARG_Sound_Init_snd_port+1 
	MOVLW       3
	MOVWF       FARG_Sound_Init_snd_pin+0 
	CALL        _Sound_Init+0, 0
;programa 17.c,108 :: 		Sound_Play(1000, 500);
	MOVLW       232
	MOVWF       FARG_Sound_Play_freq_in_hz+0 
	MOVLW       3
	MOVWF       FARG_Sound_Play_freq_in_hz+1 
	MOVLW       244
	MOVWF       FARG_Sound_Play_duration_ms+0 
	MOVLW       1
	MOVWF       FARG_Sound_Play_duration_ms+1 
	CALL        _Sound_Play+0, 0
;programa 17.c,110 :: 		while (1) {
L_main3:
;programa 17.c,111 :: 		if (Button(&PORTC,0,1,1)) // RB7 genera Tono1
	MOVLW       PORTC+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTC+0)
	MOVWF       FARG_Button_port+1 
	CLRF        FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main5
;programa 17.c,112 :: 		Tone1();
	CALL        _Tone1+0, 0
L_main5:
;programa 17.c,113 :: 		while (PORTC & 0x01) ;    // Esperar que se suelte el botón
L_main6:
	BTFSS       PORTC+0, 0 
	GOTO        L_main7
	GOTO        L_main6
L_main7:
;programa 17.c,114 :: 		if (Button(&PORTC,1,1,1)) // RB6 genera Tono2
	MOVLW       PORTC+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTC+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       1
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main8
;programa 17.c,115 :: 		Tone2();
	CALL        _Tone2+0, 0
L_main8:
;programa 17.c,116 :: 		while (PORTC & 0x02) ;    // Esperar que se suelte el botón
L_main9:
	BTFSS       PORTC+0, 1 
	GOTO        L_main10
	GOTO        L_main9
L_main10:
;programa 17.c,117 :: 		if (Button(&PORTC,2,1,1)) // RB5 genera melodía 2
	MOVLW       PORTC+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTC+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       2
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main11
;programa 17.c,119 :: 		dragon_ball_gt();
	CALL        _dragon_ball_gt+0, 0
L_main11:
;programa 17.c,120 :: 		while (PORTB & 0x04) ;    // Esperar que se suelte el botón
L_main12:
	BTFSS       PORTB+0, 2 
	GOTO        L_main13
	GOTO        L_main12
L_main13:
;programa 17.c,121 :: 		if (Button(&PORTC,3,1,1)) // RB4 genera melodía 1
	MOVLW       PORTC+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTC+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       3
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main14
;programa 17.c,122 :: 		Melody1();
	CALL        _Melody1+0, 0
L_main14:
;programa 17.c,123 :: 		while (PORTB & 0x08) ;    // Esperar que se suelte el botón
L_main15:
	BTFSS       PORTB+0, 3 
	GOTO        L_main16
	GOTO        L_main15
L_main16:
;programa 17.c,124 :: 		}
	GOTO        L_main3
;programa 17.c,125 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
