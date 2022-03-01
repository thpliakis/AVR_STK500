;Part1

;Thomas Pliakis 9018,TEAM 6	

;This program compares the 2 16-bit long numbers and turns on the leds according to the given instructions in the task for lab1,part1 and then
;checks if the numbers are odd or even and again turns on the leds according to the given matrix in the task for lab1,part1. 



.INCLUDE "m16def.inc"  ;include the library of the mc

.DEF TEMP=R19


.CSEG
.org 0x0000    ;Tell the assembler that the following is to start at address 0x0000.



AEMLIST: .DB  0b00100000 ,0b00001010 ,0b00100011 ,0b00111010   ;TA AEM MAS,8202,9018

;ascii digits
AEM1: .DB 0b00111000 ,0b00110010 ,0b00110000 ,0b00110010 ;AEM 8202
AEM2: .DB 0b00111001 ,0b00110000 ,0b00110001 ,0b00111000 ;AEM 9018



START:

;Defining SRAM as stack
	LDI	R17, low(RAMEND)
	OUT	SPL, R17
	LDI	R17, high(RAMEND)
	OUT	SPH, R17

	


;PORT INITIALAZATION
LDI TEMP,0xFF  
OUT DDRB,TEMP   ;Confiure portb as an output port
LDI TEMP,0xFF
OUT PORTB,TEMP   ;because temp=0xFF ola ta led sbhnoyn



;=============================================================================================================================

;CALL COMPARE FUNCTION 			
RCALL COMPARE


;Check if the AEMS are odd or even
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
RJMP END	

CHECK_SECOND_AEM:
	SBRC R23,0
RJMP SECOND_AEM_IS__EVEN	                      ;Execute if AEM1=even,AEM2=even. Skip if if AEM2 is odd.
   	LDI TEMP,0b11111111                           ;Execute if AEM1=even,AEM2=ODD.
	OUT PORTB,TEMP		;Turn-on leds.
	RCALL DELAY_5S
	LDI TEMP,0B11111111  
	OUT PORTB,TEMP		;Turn-off leds.
RJMP END


SECOND_AEM_IS__EVEN:                               ;Execute if AEM1=even,AEM2=even.
	LDI TEMP,0b11111110
	OUT PORTB,TEMP		;Turn-on leds.
	RCALL DELAY_5S
	LDI TEMP,0B11111111  
	OUT PORTB,TEMP		;Turn-off leds.
RJMP END


AEM1_ODD_AEM2_EVEN:
	LDI TEMP,0b11111100                           ;Execute if AEM1=odd,AEM2=even.
	OUT PORTB,TEMP		;Turn-on leds.
	RCALL DELAY_5S
	LDI TEMP,0B11111111
	OUT PORTB,TEMP		;Turn-off leds.
RJMP END


END:
NOP
RJMP END




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
ELSE:                                               ; Execute if AEM1 < AEM2
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

IFTRUE:
	LDI ZL ,LOW(AEM2*2)			; Execute if AEM1 > AEM2.
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

