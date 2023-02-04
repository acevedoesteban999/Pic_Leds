List P=16F84A
#include "P16F84A.inc"
__CONFIG _XT_OSC & _PWRTE_ON &  _CP_OFF & _WDT_OFF
;================================VAR================================
CBLOCK 0X0C
	Modo
	Cont0
	Cont1
	Led
	Var0
	Var1
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
	BCF TRISB,0			;Deberia de ser BSF pero el hadwere funciona con BCF
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
	clrf Led	
	MOVLW d'1'
	movwf Modo
	BSF INTCON,7		;Habilitar todas las Interrupt
LOOP
	GOTO LOOP 

;================================INTERRUPT================================
Ref_Modo0
	DECFSZ Cont0,1
	goto M0_Continue0
	movlW d'100'
	movwf Cont0
	clrf PORTA
	btfsc Led,0
	goto M0_Continue1
	bsf Led,0
	goto M0_Continue0
   M0_Continue1
	bcf Led,0
   M0_Continue0
	DECFSZ Cont1,1
	goto _ExtM0
	movlW d'20'
	movwf Cont1
	btfsc Led,0
	goto M0_Continue2
	btfsc PORTA,0
	goto M0_Continue3
	movlw b'00000011'
	movwf PORTA
	goto _ExtM0
   M0_Continue3
	clrf PORTA
	goto _ExtM0
   M0_Continue2
	btfsc PORTA,2
	goto M0_Continue4
	movlw b'00001100'
	movwf PORTA
	goto _ExtM0
   M0_Continue4
	clrf PORTA
	goto _ExtM0
  _ExtM0
	return

Ref_Modo1
	DECFSZ Cont0,1
	goto M1_Continue0
	movlW d'50'
	movwf Cont0
	clrf PORTA
	movlw d'3'
	xorwf Led,0
	btfsc STATUS,2
	goto M1_Continue1
	incf Led
	goto M1_Continue0
   M1_Continue1	
	movwf Led
   M1_Continue0
	DECFSZ Cont1,1
	goto _ExtM1
	movlW d'10'
	movwf Cont1	
	movf Led,0
	movwf Var0
	incf Var0	
	movlw 1
	movwf Var1
   Ciclo
	bcf STATUS,0
	DECFSZ Var0,1	
	goto Rotar
	goto M1_Continue2
  Rotar
	RLF Var1,1
	goto Ciclo
  M1_Continue2
	movf PORTA,0
	xorwf Var1,0
	btfsc STATUS,2	
	goto M1_Continue3
	movf Var1,0
	movwf PORTA
	goto _ExtM1
  M1_Continue3	
	clrf PORTA
	goto _ExtM1
  _ExtM1
	return
Ref_Modo2
	movlw b'00000011'
	movwf PORTA
	_ExtM2
	return
Ref_Modo3
	movlw b'00001100'
	movwf PORTA
	_ExtM3
	return
AT_INTERR
	BTFSC INTCON,T0IF
    goto _T0
	goto _X0
  _T0
	MOVLW d'245'		
	MOVWF TMR0	
	movlw d'0'
	xorwf Modo,0	
	btfss STATUS,2
	goto T0Continue0
	call Ref_Modo0
	goto _ExtT0
  T0Continue0
	movlw d'1'
	xorwf Modo,0
	btfss STATUS,2
	goto T0Continue1
	call Ref_Modo1
	goto _ExtT0
  T0Continue1
	movlw d'2'
	xorwf Modo,0
	btfss STATUS,2
	goto T0Continue2
	call Ref_Modo2
	goto _ExtT0
  T0Continue2
	movlw d'3'
	xorwf Modo,0
	btfss STATUS,2
	goto _ExtT0
	call Ref_Modo3
	goto _ExtT0
 
  _ExtT0
	BCF INTCON,T0IF
	RETFIE
  _X0
	;clrf Led
	movlw d'3'
	xorwf Modo,0
	btfsc STATUS,2
	goto  X0Continue0
	incf Modo
	goto _ExtX0
   X0Continue0
	movwf Modo
  _ExtX0
	BCF INTCON,INTF
	RETFIE

end