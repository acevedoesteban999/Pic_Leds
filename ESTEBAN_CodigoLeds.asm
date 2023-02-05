List P=16F84A
#include "P16F84A.inc"
__CONFIG _XT_OSC & _PWRTE_ON &  _CP_OFF & _WDT_OFF
;================================VAR================================
CBLOCK 0X0C
	Modo
	SubModo
	Cont0
	Cont1
	Cont2
	Cont3
	Var0
	Var1
	Var2
	Var3
	Var4
ENDC
;================================VECTOR================================
ORG	00h
	goto Main
	
ORG 04h
	goto AT_INTERR


;================================MAIN================================
Main 
	;Banco 1
	bsf STATUS,5		;Selecc Banco
	BCF TRISA,0			;Conf Puerto Out
	BCF TRISA,1	
	BCF TRISA,2			
	BCF TRISA,3
	BSF TRISB,0			;Deberia de ser BSF pero el hadwere funciona con BCF
	MOVLW b'00000111'	;Prescalar de 256 para TM0				
	MOVWF OPTION_REG
	MOVLW b'00110000'		;Habilitador Interrupciones
	MOVWF INTCON
	;Banco 0
	BCF STATUS,5		;Selecc Banco
	MOVLW d'245'		
	MOVWF TMR0
	CLRF PORTA			;Apagar leds 
	BCF PORTB,0
	MOVLW d'1'
	movwf Cont0
	movwf Cont1
	movwf Cont2
	movwf Cont3
	clrf Var0
	clrf Var1
	clrf Var2
	clrf Var3	
	clrf SubModo
	MOVLW d'0'
	movwf Modo
	BSF INTCON,7		;Habilitar todas las Interrupt
LOOP
	GOTO LOOP 
;================================================================================================
;										SUBRUTINAS
;================================================================================================

;========================MODO0_1========================
Ref_Modo0
	DECFSZ Cont0,1
	goto M0Continue0
	movlW d'50'
	movwf Cont0
	clrf PORTA
	btfsc Var2,0
	goto M0Continue1
	bsf Var2,0
	goto M0Continue0
   M0Continue1
	bcf Var2,0
   M0Continue0
	DECFSZ Cont1,1
	goto ExtM0
	movlW d'10'
	movwf Cont1
	btfsc Var2,0
	goto M0Continue2
	btfsc PORTA,0
	goto M0Continue3
	movlw b'00000011'
	movwf PORTA
	goto ExtM0
   M0Continue3
	clrf PORTA
	goto ExtM0
   M0Continue2
	btfsc PORTA,2
	goto M0Continue4
	movlw b'00001100'
	movwf PORTA
	goto ExtM0
   M0Continue4
	clrf PORTA
	goto ExtM0
  ExtM0
	return
;========================MODO0_1========================
Ref_Modo1_0
	DECFSZ Cont0,1
	goto M1_0Continue0
	movlW d'30'
	movwf Cont0
	clrf PORTA
	movlw d'3'
	xorwf Var2,0
	btfsc STATUS,2
	goto M1_0Continue1
	incf Var2
	goto M1_0Continue0
   M1_0Continue1	
	movwf Var2
   M1_0Continue0
	DECFSZ Cont1,1
	goto ExtM1_0
	movlW d'10'
	movwf Cont1	
	movf Var2,0
	movwf Var0
	incf Var0	
	movlw 1
	movwf Var1
   M1_0Ciclo
	bcf STATUS,0
	DECFSZ Var0,1	
	goto M1_0Rotar
	goto M1_0Continue2
  M1_0Rotar
	RLF Var1,1
	goto M1_0Ciclo
  M1_0Continue2
	movf PORTA,0
	xorwf Var1,0
	btfsc STATUS,2	
	goto M1_0Continue3
	movf Var1,0
	movwf PORTA
	goto ExtM1_0
  M1_0Continue3	
	clrf PORTA
	goto ExtM1_0
  ExtM1_0
	return
;========================MODO1_1========================
Ref_Modo1_1
	DECFSZ Cont0,1
	goto M1_1Continue0
	movlW d'30'
	movwf Cont0
	clrf PORTA
	movlw d'0'
	xorwf Var2,0
	btfsc STATUS,2
	goto M1_1Continue1
	decf Var2
	goto M1_1Continue0
   M1_1Continue1	
	movlw d'3'
	movwf Var2
   M1_1Continue0
	DECFSZ Cont1,1
	goto ExtM1_1
	movlW d'10'
	movwf Cont1	
	movf Var2,0
	movwf Var0
	movf Var0,0
	sublw d'3'
	movwf Var0
	incf Var0
	movlw d'8'
	movwf Var1
   M1_1Ciclo
	bcf STATUS,0
	DECFSZ Var0,1	
	goto M1_1Rotar
	goto M1_1Continue2
  M1_1Rotar
	RRF Var1,1
	goto M1_1Ciclo
  M1_1Continue2
	movf PORTA,0
	xorwf Var1,0
	btfsc STATUS,2	
	goto M1_1Continue3
	movf Var1,0
	movwf PORTA
	goto ExtM1_1
  M1_1Continue3	
	clrf PORTA
	goto ExtM1_1
  ExtM1_1
	return
;========================MODO2========================
Ref_Modo2
	movlw d'0'
	xorwf Var2,0
	btfss STATUS,2
	goto M2Continue0
	bsf PORTA,0
	bcf Var3,0
	movlw d'1'
	xorwf Cont0,0
	btfsc STATUS,2
	goto M2Continue1
	incf Cont1
	goto M2Continue1
M2Continue0
	movlw d'3'
	xorwf Var2,0
	btfss STATUS,2
	goto M2Continue1
	bsf PORTA,3
	bsf Var3,0
	movlw d'1'
	xorwf Cont0,0
	btfsc STATUS,2
	goto M2Continue1
	incf Cont1
  M2Continue1
	btfsc Var3,0
	goto M2Continue2
	goto Ref_Modo1_0
  M2Continue2
	goto Ref_Modo1_1

;========================MODO3========================
Ref_Modo3
	DECFSZ Cont0,1
	goto ExtM3
	movlW d'10'
	movwf Cont0
	btfsc PORTA,0
	goto M3Continue0
	movlw b'00001111'
	movwf PORTA
	goto ExtM3
  M3Continue0	
	clrf PORTA
	goto ExtM3
  ExtM3
	return


;========================MODO4========================
Ref_Modo4
	DECFSZ Cont0,1
	goto ExtM4
	btfsc Var0,0
	goto M4Continue1
	incf Var1		
	movf Var1,0
	movwf Cont0
	movlw d'33'
	xorwf Var1,0	
	btfss STATUS,2
	goto M4Continue0
	bsf Var0,0
	goto M4Continue0
  M4Continue1
	decf Var1
	movf Var1,0		
	movwf Cont0
	movlw d'1'
	xorwf Var1,0	
	btfss STATUS,2
	goto M4Continue0
	bcf Var0,0
  M4Continue0
	btfsc PORTA,0
	goto M4Continue2
	movlw b'00001111'
	movwf PORTA
	goto ExtM4
  M4Continue2
	clrf PORTA
	goto ExtM4
   ExtM4
	return
;========================MODO5========================
Ref_Modo5
	DECFSZ Cont2,1
	goto M5Continue0
	movlW d'100'	
	movwf Cont2
	DECFSZ Cont3,1
	goto M5Continue0
	movlW d'3'	
	movwf Cont3
	clrf Var2
	clrf PORTA
	movlw d'3'
	xorwf SubModo,0	
	btfss STATUS,2
	goto M5Continue1
	movwf SubModo
	goto M5Continue0	
  M5Continue1
	incf SubModo
  M5Continue0 
	movlw d'0'
	xorwf SubModo,0	
	btfss STATUS,2
	goto M5Continue2
	goto Ref_Modo0	
  M5Continue2
	movlw d'1'
	xorwf SubModo,0	
	btfss STATUS,2
	goto M5Continue3
	goto Ref_Modo1_0	
  M5Continue3
	movlw d'2'
	xorwf SubModo,0	
	btfss STATUS,2
	goto M5Continue4
	goto Ref_Modo3	
  M5Continue4
	goto Ref_Modo1_1
;================================================================================================
;										INTERRUPCIONES
;================================================================================================
AT_INTERR
	BTFSC INTCON,T0IF
    goto _T0
	goto _X0
;========================TIMER========================
  _T0
	MOVLW d'235'		
	MOVWF TMR0	
	movlw d'0'
	xorwf Modo,0	
	btfss STATUS,2
	goto T0Continue0
	call Ref_Modo0
	goto ExtT0
  T0Continue0
	movlw d'1'
	xorwf Modo,0
	btfss STATUS,2
	goto T0Continue1
	call Ref_Modo1_0
	goto ExtT0
  T0Continue1
	movlw d'2'
	xorwf Modo,0
	btfss STATUS,2
	goto T0Continue2
	call Ref_Modo2
	goto ExtT0
  T0Continue2
	movlw d'3'
	xorwf Modo,0
	btfss STATUS,2
	goto T0Continue3
	call Ref_Modo3
	goto ExtT0
  T0Continue3
	movlw d'4'
	xorwf Modo,0
	btfss STATUS,2
	goto T0Continue4
	call Ref_Modo4
	goto ExtT0
  T0Continue4
	call Ref_Modo5
	goto ExtT0
 ;========================EXTERNA========================
  ExtT0
	BCF INTCON,T0IF
	RETFIE
  _X0
	clrf Var0
	clrf Var1
	clrf Var2
	clrf Var3
	clrf SubModo
	movlw d'1'
	movwf Cont0
	movwf Cont1
	movwf Cont2
	movwf Cont3
	movlw d'5'
	xorwf Modo,0
	btfsc STATUS,2
	goto  X0Continue0
	incf Modo
	goto ExtX0
   X0Continue0
	movwf Modo
  ExtX0
	BCF INTCON,INTF
	RETFIE

end