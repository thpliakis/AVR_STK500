;Part2

;Thomas Pliakis 9018, TEAM 6	

;This program compares the 2 16-bit long numbers and turns on the leds according to which switch is pressed and then freed based on the matrix
:given in lab1,part2. 



.INCLUDE "m16def.inc"  ;include the library of the mc

.DEF TEMP=R19
.DEF COMRESULT = R24

.CSEG
.org 0x0000		;Tell the assembler that the following is to start at address 0x0000 	



AEMLIST: .DB  0b00100000 ,0b00001010 ,0b00100011 ,0b00111010   ;TA AEM MAS,8202,9018

;ascii digits
AEM1: .DB 0b00111000 ,0b00110010 ,0b00110000 ,0b00110010 ;AEM 8202
AEM2: .DB 0b00111001 ,0b00110000 ,0b00110001 ,0b00111000 ;AEM 9018

START:


	LDI	R17, low(RAMEND)
	OUT	SPL, R17
	LDI	R17, high(RAMEND)
	OUT	SPH, R17

	CLR COMRESULT

;PORT INITIALAZATION
LDI TEMP,0xFF  
OUT DDRB,TEMP   ;Confiure portb as an output port
LDI TEMP,0xFF
OUT PORTB,TEMP   ;because temp=0xFF ola ta led sbhnoyn



;=============================================================================================================================


;CALL COMPARE FUNCTION 
RCALL COMPARE

;=============================================================================================================================

;Save in registers R22,R23,R24,R25 the values of every 2 digits of each AEM in BCD format.R22=AEM1LOW,R23=AEM2LOW,R24=AEM1HIGH,R25=AEM2HIGH.
	LDI ZL ,LOW(AEM1*2)
   	LDI ZH ,HIGH(AEM1*2)
	LPM R20,Z+
	LPM R21,Z+
	LPM R22,Z+
	LPM R23,Z+
	
	SUBI R22,0b00110000
	SUBI R23,0b00110000
	LSL R22
	LSL R22
	LSL R22
	LSL R22
	ADD R22,R23
	COM R22
	MOV R24,R22

	LDI ZL ,LOW(AEM2*2)
   	LDI ZH ,HIGH(AEM2*2)
	LPM R20,Z+
	LPM R21,Z+
	LPM R22,Z+
	LPM R23,Z+
	
	SUBI R22,0b00110000
	SUBI R23,0b00110000
	LSL R22
	LSL R22
	LSL R22
	LSL R22
	ADD R22,R23
	COM R22
	MOV R25,R22

	LDI ZL ,LOW(AEM1*2)
   	LDI ZH ,HIGH(AEM1*2)
	LPM R20,Z+
	LPM R21,Z+
	LPM R22,Z+
	LPM R23,Z+
	
	SUBI R20,0b00110000
	SUBI R21,0b00110000
	LSL R20
	LSL R20
	LSL R20
	LSL R20
	ADD R20,R21
	COM R20
	MOV R26,R20

	LDI ZL ,LOW(AEM2*2)
   	LDI ZH ,HIGH(AEM2*2)
	LPM R20,Z+
	LPM R21,Z+
	LPM R22,Z+
	LPM R23,Z+
	
	SUBI R20,0b00110000
	SUBI R21,0b00110000
	LSL R20
	LSL R20
	LSL R20
	LSL R20
	ADD R20,R21
	COM R20
	MOV R27,R20
	
;=============================================================================================================================

;Wait until a switch is pressed.

WAIT_ORDERS_1:
IN R16,PIND				;Read switches
CPI R16,0b11111110
BREQ SWITCH_0_PRESSED			;Branch if switch 0 is pressed
CPI R16,0b11111101
BREQ SWITCH_1_PRESSED			;Branch if switch 1 is pressed
CPI R16,0b11111011
BREQ SWITCH_2_PRESSED			;Branch if switch 2 is pressed
CPI R16,0b11110111
BREQ SWITCH_3_PRESSED			;Branch if switch 3 is pressed
CPI R16,0b01111111
BREQ SWITCH_7_PRESSED			;Branch if switch 7 is pressed
RJMP WAIT_ORDERS_1


;Loop that terminates when switch 0 has been freed.
SWITCH_0_PRESSED:
	SUB_LOOP_1_0:
		IN R16,PIND				;Read switches
		CPI R16,0b11111111			;Check if switch 0 has been freed.
		BREQ SWITCH_RELESHED_0			;Branch if switch 0 has been freed.
	RJMP SUB_LOOP_1_0	

;Loop that terminates when switch 1 has been freed.
SWITCH_1_PRESSED:
	SUB_LOOP_1_1:
		IN R16,PIND
		CPI R16,0b11111111
		BREQ SWITCH_RELESHED_1
	RJMP SUB_LOOP_1_1	

;Loop that terminates when switch 2 has been freed.
SWITCH_2_PRESSED:
	SUB_LOOP_1_2:
		IN R16,PIND
		CPI R16,0b11111111
		BREQ SWITCH_RELESHED_2
	RJMP SUB_LOOP_1_2

;Loop that terminates when switch 3 has been freed.
SWITCH_3_PRESSED:
	SUB_LOOP_1_3:
		IN R16,PIND
		CPI R16,0b11111111
		BREQ SWITCH_RELESHED_3
	RJMP SUB_LOOP_1_3

;Loop that terminates when switch 7 has been freed.
SWITCH_7_PRESSED:
	SUB_LOOP_1_7:
		IN R16,PIND
		CPI R16,0b11111111
		BREQ SWITCH_RELESHED_7
	RJMP SUB_LOOP_1_7



SWITCH_RELESHED_0:
	CPI COMRESULT,2			;Regisster that remembers which AEM is bigger and which is smaller.Thus, the appropriate part of the
					   program is executed.
	BREQ AEM2_IS_BIGGER_0           ;Execute if COMRESULT=2. Skip if COMRESULT!=2.
	

    AEM1_IS_BIGGER_0:
	MOV TEMP,R24                      
	OUT PORTB,TEMP
	RCALL DELAY_10S
	LDI TEMP,0B11111111  ;Turn-off leds
	OUT PORTB,TEMP
	RJMP END

    AEM2_IS_BIGGER_0:
	MOV TEMP,R25                      
	OUT PORTB,TEMP
	RCALL DELAY_10S
	LDI TEMP,0B11111111  ;Turn-off leds
	OUT PORTB,TEMP
	RJMP END


SWITCH_RELESHED_1:
	CPI COMRESULT,2			;Regisster that remembers which AEM is bigger and which is smaller.Thus, the appropriate part of the
					   program is executed.
	BREQ AEM2_IS_BIGGER_1		;Execute if COMRESULT=2. Skip if COMRESULT!=2.
	

    AEM1_IS_BIGGER_1:
	MOV TEMP,R26                      
	OUT PORTB,TEMP
	RCALL DELAY_10S
	LDI TEMP,0B11111111  ;Turn-off leds
	OUT PORTB,TEMP
	RJMP END

    AEM2_IS_BIGGER_1:
	MOV TEMP,R27                
	OUT PORTB,TEMP
	RCALL DELAY_10S
	LDI TEMP,0B11111111  ;Turn-off leds
	OUT PORTB,TEMP
	RJMP END

SWITCH_RELESHED_2:
	CPI COMRESULT,1			;Regisster that remembers which AEM is bigger and which is smaller.Thus, the appropriate part of the
					   program is executed.
	BREQ AEM2_IS_SMALLER_2		;Execute if COMRESULT=1. Skip if COMRESULT!=1.
	

    AEM1_IS_SMALLER_2:
	MOV TEMP,R24 
	OUT PORTB,TEMP
	RCALL DELAY_10S
	LDI TEMP,0B11111111  ;Turn-off leds
	OUT PORTB,TEMP
	RJMP END

    AEM2_IS_SMALLER_2:
	MOV TEMP,R25
	OUT PORTB,TEMP
	RCALL DELAY_10S
	LDI TEMP,0B11111111  ;Turn-off leds
	OUT PORTB,TEMP
	RJMP END

SWITCH_RELESHED_3:
	CPI COMRESULT,1			;Regisster that remembers which AEM is bigger and which is smaller.Thus, the appropriate part of the
					   program is executed.
	BREQ AEM2_IS_SMALLER_3		;Execute if COMRESULT=1. Skip if COMRESULT!=1.
	

    AEM1_IS_SMALLER_3:
	MOV TEMP,R26
	OUT PORTB,TEMP
	RCALL DELAY_10S
	LDI TEMP,0B11111111  ;Turn-off leds
	OUT PORTB,TEMP
	RJMP END

    AEM2_IS_SMALLER_3:
	MOV TEMP,R27 
	OUT PORTB,TEMP
	RCALL DELAY_10S
	LDI TEMP,0B11111111  ;Turn-off leds
	OUT PORTB,TEMP
	RJMP END

SWITCH_RELESHED_7:
LDI ZL ,LOW(AEMLIST*2)
LDI ZH ,HIGH(AEMLIST*2)
LPM R20,Z+
LPM R21,Z+
LPM R22,Z+
LPM R23,Z+

SBRC R21,0				;Check if the last bit of the first AEM is cleared to determine if the number is odd or even, and 						 skip the next instruction if the number is odd.
RJMP CHECK_SECOND_AEM                   ;Execute if AEM1=even. Skip if if AEM1 is odd.
SBRC R23,0				;Check if the last bit of the secind AEM is cleared to determine if the number is odd or even, and 						 skip the next instruction if the number is odd.
RJMP AEM1_ODD_AEM2_EVEN			;Execute if AEM1=odd,AEM2=even. Skip if if AEM2 is odd.
 
    LDI TEMP,0b11111101                           ;Execute if both AEMS are odd.
	OUT PORTB,TEMP		;Turn-on leds.
	RCALL DELAY_5S
	LDI TEMP,0B11111111  
	OUT PORTB,TEMP		;Turn-off leds.
RJMP END7	

CHECK_SECOND_AEM:
	SBRC R23,0
RJMP SECOND_AEM_IS__EVEN	                      ;Execute if AEM1=even,AEM2=even. Skip if if AEM2 is odd.
    LDI TEMP,0b11111111                           ;Execute if AEM1=even,AEM2=ODD.
	OUT PORTB,TEMP		;Turn-on leds.
	RCALL DELAY_5S
	LDI TEMP,0B11111111  
	OUT PORTB,TEMP		;Turn-off leds.
RJMP END7


SECOND_AEM_IS__EVEN:                               ;Execute if AEM1=even,AEM2=even.
	LDI TEMP,0b11111110
	OUT PORTB,TEMP		;Turn-on leds.
	RCALL DELAY_5S
	LDI TEMP,0B11111111  
	OUT PORTB,TEMP		;Turn-off leds.
RJMP END7


AEM1_ODD_AEM2_EVEN:
	LDI TEMP,0b11111100                           ;Execute if AEM1=odd,AEM2=even.
	OUT PORTB,TEMP		;Turn-on leds.
	RCALL DELAY_5S
	LDI TEMP,0B11111111
	OUT PORTB,TEMP		;Turn-off leds.
RJMP END7




END7:
NOP
RJMP END7



;=============================================================================================================================

;DELAY FUNCTION

DELAY_5S:
ldi  r16, 102
    ldi  r17, 118
    ldi  r18, 194
L2: dec  r18
    brne L2
    dec  r17
    brne L2
    dec  r16
    brne L2	
RET

DELAY_10S:
    ldi  r25, 2
    ldi  r16, 150
    ldi  r17, 216
    ldi  r18, 9
L1: dec  r18
    brne L1
    dec  r17
    brne L1
    dec  r16
    brne L1
    dec  r25
    brne L1
RET


;COMPARE FUNCTION
COMPARE:
LDI ZL ,LOW(AEMLIST*2)
LDI ZH ,HIGH(AEMLIST*2)
LPM R20,Z+
LPM R21,Z+
LPM R22,Z+
LPM R23,Z+

CP R21,R23		;Compare the 8 least significant bits of each 16-bit long numbers.
CPC R20,R22		;Compare the 8 most significant bits of each 16-bit long numbers and also take into account the previous carry.
BRSH IFTRUE					;Branch if AEM1 > AEM2
ELSE:   						; Execute if AEM1 < AEM2
	LDI COMRESULT,2                               ;Save that AEM2 is bigger.
	LDI ZL ,LOW(AEM1*2)
   	LDI ZH ,HIGH(AEM1*2)
	LPM R20,Z+
	LPM R21,Z+
	LPM R22,Z+
	LPM R23,Z+
	
	SUBI R22,0b00110000			;Subtrack 48 from ASCII digit to get the wanted binary number.
	SUBI R23,0b00110000			;Subtrack 48 from ASCII digit to get the wanted binary number.
	SWAP R22				;Swap in order to move the 4 bit number to the most significants bits.
	ADD R22,R23				;Add the two binary digits to create the BCD format.	
	COM R22					;Compliment the BCD form in order to open correctly the leds.
	MOV TEMP,R22      			
	OUT PORTB,TEMP		;Turn-on leds.
	RCALL DELAY_5S
	LDI TEMP,0B11111111  
	OUT PORTB,TEMP		;Turn-off leds.
RET

IFTRUE:						;Execute if AEM1 > AEM2.
	LDI COMRESULT,1				;Save that AEM1 is bigger.
	LDI ZL ,LOW(AEM2*2)
   	LDI ZH ,HIGH(AEM2*2)
	LPM R20,Z+
	LPM R21,Z+
	LPM R22,Z+
	LPM R23,Z+
	
	SUBI R22,0b00110000			;Subtrack 48 from ASCII digit to get the wanted binary number.
	SUBI R23,0b00110000			;Subtrack 48 from ASCII digit to get the wanted binary number.
	SWAP R22 				;Swap in order to move the 4 bit number to the most significants bits.
	ADD R22,R23				;Add the two binary digits to create the BCD format.	
	COM R22					;Compliment the BCD form in order to open correctly the leds.
	MOV TEMP,R22
	OUT PORTB,TEMP		;Turn-on leds.	
	RCALL DELAY_5S
	LDI TEMP,0B11111111  
	OUT PORTB,TEMP		;Turn-off leds.
RET

END:
