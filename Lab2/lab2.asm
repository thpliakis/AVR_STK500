;Thomas Pliakis 9018, TEAM 6	
;Purpose :This program consists of 2 parts.The first is the security system in which we must press the correct conde in order to 
;         continue to the second part ,which the normal mode.The security system,which is activated after pressing the SW0, gives 2 tries
;         of inserting the correct code or terminates after 5 seconds if any code isn't pressed.The normal mode excutes all procedures
;          according to the given instructions in the task for lab2.

.INCLUDE "m16def.inc"  ;include the library of the mc

.DEF TEMP=R19
.DEF CorrectCode=R28
.DEF PressedCode=R27


.CSEG
.org 0x0000    ;Tell the assembler that the following is to start at address 0x0000.


START:

;Defining SRAM as stack

LDI	R17, low(RAMEND)
OUT	SPL, R17
LDI	R17, high(RAMEND)
OUT	SPH, R17

;PORT INITIALAZATION
LDI TEMP,0xFF  
OUT DDRB,TEMP   ;Configure portb as an output port
LDI TEMP,0xFF
OUT PORTB,TEMP   ;because temp=0xFF ola ta led sbhnoyn


;=============================================================================================================================

;INSERT AND SAVE CODE

;Press SW0 for 1 time in order to insert which code the security accept.
WAIT_ORDERS_1:
    IN R16,PIND	
    CPI R16,0b11111110
    BREQ SWITCH_0_PRESSED  
RJMP WAIT_ORDERS_1

;Loop that waits SW0 to be freed.
SWITCH_0_PRESSED:
	SUB_LOOP_0:
		IN R16,PIND	
		CPI R16,0b11111111	
		BREQ SWITCH_RELEASED_0	
	RJMP SUB_LOOP_0

SWITCH_RELEASED_0:

;Delay 5 seconds in order the code to be pressed.
    RCALL DELAY_5S
	IN R16,PIND
	MOV R25,R16                  ;Temporary save code in R25= CorrectCode 
    RCALL DELAY_1S

;Loop that waits in order SW7 to be pressed and continue the program.
WAIT_ORDERS_2: 
	IN R16,PIND
	CPI R16,0b01111111	
	BREQ SWITCH_7_PRESSED_TO_SAVE_CODE 
RJMP WAIT_ORDERS_2

;Loop that waits SW7 to be freed.
SWITCH_7_PRESSED_TO_SAVE_CODE:
	SUB_LOOP_TO_SAVE_CODE:
		IN R16,PIND	
		CPI R16,0b11111111	
		BREQ SWITCH_RELEASED_7_SAVE_CODE	
	RJMP SUB_LOOP_TO_SAVE_CODE

SWITCH_RELEASED_7_SAVE_CODE:
    COM R25
	MOV CorrectCode,R25                  ;Permanent save code in R28= CorrectCode 

;=============================================================================================================================

;SECURITY SYSTEM

;Wait to press SW0 in order this time to press the code by sequentialy pressing SW4-SW1.
WAIT_SW0_FOR_2_TIME:
    IN R16,PIND	
    CPI R16,0b11111110
    BREQ SWITCH_00_PRESSED 
RJMP WAIT_SW0_FOR_2_TIME

;Loop that wait SW0 to be freed.
SWITCH_00_PRESSED:
	SUB_LOOP_00:
		IN R16,PIND	
		CPI R16,0b11111111	
		BREQ SWITCH_RELEASED_00	
	RJMP SUB_LOOP_00

SWITCH_RELEASED_00:
	LDI TEMP,0b11111110                 
  	OUT PORTB,TEMP

CLR R17                      ;Register that helps count that 5 sec have passed without code.
LDI R24,2                    ;Register that saves how many times the wrong code is pressed.
LDI R26,5                    ;Register that is use to check if 1.25 sec have passed.Each bit has 1.25 sec time to be pressed.4x5x250ms=5000ms=5sec

;Press SW4 to insert first bit of the code.
WAIT_SW4_CODE_TO_BE_PRESSED:
    INC R17
	IN R16,PIND		     
	CPI R16,0b11101111  
	BREQ SWITCH_4_CODE_PRESSED
	DEC R26
	BREQ SWITCH_4_CODE_PRESSED         ;Branch if 1,25 sec have passed with SW4=1.
	RCALL DELAY_250mS    
RJMP WAIT_SW4_CODE_TO_BE_PRESSED

;Loop that wait SW4 to be freed.
SWITCH_4_CODE_PRESSED:
    COM R16                            ;Complement input and save it at PressedCode register.
    MOV PressedCode,R16
	SUB_LOOP_CODE_4:
        LDI R26,5                      ;5x250ms=1.25sec
		IN R16,PIND
		CPI R16,0b11111111
		BREQ WAIT_SW3_CODE_TO_BE_PRESSED
	RJMP SUB_LOOP_CODE_4

;Press SW3 to insert second bit of the code.
WAIT_SW3_CODE_TO_BE_PRESSED:
    INC R17
	IN R16,PIND		     
	CPI R16,0b11110111  
	BREQ SWITCH_3_CODE_PRESSED
	DEC R26
	BREQ SWITCH_3_CODE_PRESSED       ;Branch if 1,25 sec have passed with SW3=1.
	RCALL DELAY_250mS    
RJMP WAIT_SW3_CODE_TO_BE_PRESSED

;Loop that wait SW3 to be freed.
SWITCH_3_CODE_PRESSED:
    COM R16                          ;Complement input and add it at PressedCode register.
    ADD PressedCode,R16
	SUB_LOOP_CODE_3:
        LDI R26,5                    ;5x250ms=1.25sec
		IN R16,PIND
		CPI R16,0b11111111
		BREQ WAIT_SW2_CODE_TO_BE_PRESSED
	RJMP SUB_LOOP_CODE_3

;Press SW2 to insert third bit of the code.
WAIT_SW2_CODE_TO_BE_PRESSED:
    INC R17
	IN R16,PIND		     
	CPI R16,0b11111011  
	BREQ SWITCH_2_CODE_PRESSED
	DEC R26
	BREQ SWITCH_2_CODE_PRESSED        ;Branch if 1,25 sec have passed with SW2=1.
	RCALL DELAY_250mS    
RJMP WAIT_SW2_CODE_TO_BE_PRESSED

;Loop that wait SW2 to be freed.
SWITCH_2_CODE_PRESSED:
    COM R16                          ;Complement input and add it at PressedCode register.
    ADD PressedCode,R16
	SUB_LOOP_CODE_2:
        LDI R26,5                    ;5x250ms=1.25sec
		IN R16,PIND
		CPI R16,0b11111111
		BREQ WAIT_SW1_CODE_TO_BE_PRESSED
	RJMP SUB_LOOP_CODE_2

;Press SW1 to insert fourth bit of the code.
WAIT_SW1_CODE_TO_BE_PRESSED:
    INC R17
	IN R16,PIND		     
	CPI R16,0b11101111  
	BREQ SWITCH_1_CODE_PRESSED
	DEC R26
	BREQ SWITCH_1_CODE_PRESSED         ;Branch if 5 in total sec have passed with SW1=1.
    CPI R17,21
    BREQ SEC_5_HAVE_PASSED
	RCALL DELAY_250mS    
RJMP WAIT_SW1_CODE_TO_BE_PRESSED

;Loop that wait SW1 to be freed.
SWITCH_1_CODE_PRESSED:
    COM R16                          ;Complement input and add it at PressedCode register.
    ADD PressedCode,R16
	SUB_LOOP_CODE_1:
		IN R16,PIND
		CPI R16,0b11111111
		BREQ CHECK_CODE_PRESSED
	RJMP SUB_LOOP_CODE_1

;Branch here if 5 sec have passed without any code pressed
SEC_5_HAVE_PASSED:
	LDI R22,5                        ;Register that helps LED0 to turn on and off every sec for 5 sec.
	RCALL LED0_1_SEC
RJMP END                             ;Jump to te last line. 

;Branch here to check the code that has been pressed.
CHECK_CODE_PRESSED:
    CP CorrectCode,PressedCode
    BREQ CORRECT_CODE_PRESSED        ;Branch if the correct code is pressed.

;If the a wrong code is pressed the program continues here.
WRONG_CODE_PRESSED:
    LDI R22,5
    DEC R24
	BREQ WRONG_CODE_TWICE             ;Branch if the wrong code has been pressed twice.
	LDI R22,5                         ;Register that helps LED0 to turn on and off every sec for 5 sec.
	RCALL LED0_1_SEC                  ;Turn on and off the LED0 because the wrong code is pressed one time.
	LDI TEMP,0b11111110 
	OUT PORTB,TEMP                    ;Open LED0 and jump to try for second time to pressed the correct code.
RJMP WAIT_SW4_CODE_TO_BE_PRESSED

;Branch here if the wrong code is pressed twice.
WRONG_CODE_TWICE:                     ;Turn on and off all the LEDS for 5 seconds. 
	LDI TEMP,0b00000000 
	OUT PORTB,TEMP		;Turn-on leds.
	RCALL DELAY_1S
	LDI TEMP,0b11111111  
	OUT PORTB,TEMP		;Turn-off leds.
	RCALL DELAY_1S
	DEC R22      
	BRNE WRONG_CODE_TWICE        ;Loop
RJMP END                          ;Jump to te last line.

;=============================================================================================================================

;NORMAL MODE

;Branch here if the correct code is pressed.
CORRECT_CODE_PRESSED:
	LDI TEMP,0b11111101                           
	OUT PORTB,TEMP		;Turn-on led.

;Wait a switch to be pressed.
WAIT_ORDERS_3:
IN R16,PIND				         	;Read switches
CPI R16,0b11111101
BREQ SWITCH_1_PRESSED			;Branch if switch 1 is pressed
CPI R16,0b11111011
BREQ SWITCH_2_PRESSED			;Branch if switch 2 is pressed
CPI R16,0b11110111
BREQ SWITCH_3_PRESSED			;Branch if switch 3 is pressed
CPI R16,0b11101111
BREQ SWITCH_4_PRESSED			;Branch if switch 4 is pressed
CPI R16,0b11011111
BREQ SWITCH_5_PRESSED			;Branch if switch 5 is pressed
CPI R16,0b10111111
BREQ SWITCH_6_PRESSED			;Branch if switch 6 is pressed
CPI R16,0b01111111
BREQ SWITCH_7_PRESSED			;Branch if switch 7 is pressed
RJMP WAIT_ORDERS_3

;Loop that terminates when switch 1 has been freed.
SWITCH_1_PRESSED:
	SUB_LOOP_1_1:
		IN R16,PIND
		CPI R16,0b11111111
		BREQ SWITCH_RELEASED_1
	RJMP SUB_LOOP_1_1	

;Loop that terminates when switch 2 has been freed.
SWITCH_2_PRESSED:
	SUB_LOOP_1_2:
		IN R16,PIND
		CPI R16,0b11111111
		BREQ SWITCH_RELEASED_2
	RJMP SUB_LOOP_1_2

;Loop that terminates when switch 3 has been freed.
SWITCH_3_PRESSED:
	SUB_LOOP_1_3:
		IN R16,PIND
		CPI R16,0b11111111
		BREQ SWITCH_RELEASED_3
	RJMP SUB_LOOP_1_3

;Loop that terminates when switch 4 has been freed.
SWITCH_4_PRESSED:
	SUB_LOOP_1_4:
		IN R16,PIND
		CPI R16,0b11111111
		BREQ SWITCH_RELEASED_4
	RJMP SUB_LOOP_1_4

;Loop that terminates when switch 5 has been freed.
SWITCH_5_PRESSED:
	SUB_LOOP_1_5:
		IN R16,PIND
		CPI R16,0b11111111
		BREQ SWITCH_RELEASED_5
	RJMP SUB_LOOP_1_5

;Loop that terminates when switch 6 has been freed.
SWITCH_6_PRESSED:
	SUB_LOOP_1_6:
		IN R16,PIND
		CPI R16,0b11111111
		BREQ SWITCH_RELEASED_6
	RJMP SUB_LOOP_1_6

;Loop that terminates when switch 7 has been freed.
SWITCH_7_PRESSED:
	SUB_LOOP_1_7:
		IN R16,PIND
		CPI R16,0b11111111
		BREQ SWITCH_RELEASED_7
	RJMP SUB_LOOP_1_7

WAIT_ORDERS_33:
	RJMP WAIT_ORDERS_3

;Loop that waits SW0 to be pressed in order to restart normal mode.
END_LOOP:
	IN R16,PIND				            	;Read switches
	CPI R16,0b11111110
	BREQ CORRECT_CODE_PRESSED
RJMP END_LOOP


SWITCH_RELEASED_1:
	IN R16,PIND				            	;Read switches
	CPI R16,0b11111011              ;Loop that wait SW2 to be pressed and bypass it.
	BREQ WAIT_ORDERS_33 
RJMP SWITCH_RELEASED_1

SWITCH_RELEASED_2:
	LDI TEMP,0b11110011 
	OUT PORTB,TEMP		;Turn-on leds.
RJMP END_LOOP               ;Jump to the END_LOOP which loops until SW0 is pressed and normal mode is restarted.

SWITCH_RELEASED_3:
	IN R16,PIND				            	;Read switches
	CPI R16,0b11101111                 ;Wait for a switch between SW4-SW7 to be pressed and bypass it.
	BREQ SWITCH_PRESSED_44
	CPI R16,0b11011111 
    BREQ SWITCH_PRESSED_55
	CPI R16,0b10111111
	BREQ SWITCH_6_PRESSED_66
	CPI R16,0b01111111
	BREQ SWITCH_7_PRESSED_77
RJMP SWITCH_RELEASED_3

SWITCH_RELEASED_4:
	LDI TEMP,0b11101011 
	OUT PORTB,TEMP		;Turn-on leds.
RJMP END_LOOP              ;Jump to the END_LOOP which loops until SW0 is pressed and normal mode is restarted.

SWITCH_RELEASED_5:
	LDI TEMP,0b11011011 
	OUT PORTB,TEMP		;Turn-on leds.
RJMP END_LOOP             ;Jump to the END_LOOP which loops until SW0 is pressed and normal mode is restarted. 

SWITCH_RELEASED_6:
	LDI TEMP,0b10111011 
	OUT PORTB,TEMP		;Turn-on leds.
RJMP END_LOOP              ;Jump to the END_LOOP which loops until SW0 is pressed and normal mode is restarted.

SWITCH_RELEASED_7:
	LDI TEMP,0b01111011 
	OUT PORTB,TEMP		;Turn-on leds.
RJMP END_LOOP               ;Jump to the END_LOOP which loops until SW0 is pressed and normal mode is restarted.

;========================
;Loops that bypass SW4-SW7

;Loop that terminates when switch 4 has been freed.
SWITCH_PRESSED_44:
	SUB_LOOP_2_4:
		IN R16,PIND
		CPI R16,0b11111111
		BREQ WAIT_ORDERS_33
	RJMP SUB_LOOP_2_4

;Loop that terminates when switch 5 has been freed.
SWITCH_PRESSED_55:
	SUB_LOOP_2_5:
		IN R16,PIND
		CPI R16,0b11111111
		BREQ WAIT_ORDERS_33
	RJMP SUB_LOOP_2_5

;Loop that terminates when switch 6 has been freed.
SWITCH_6_PRESSED_66:
	SUB_LOOP_2_6:
		IN R16,PIND
		CPI R16,0b11111111
		BREQ WAIT_ORDERS_33
	RJMP SUB_LOOP_2_6

;Loop that terminates when switch 7 has been freed.
SWITCH_7_PRESSED_77:
	SUB_LOOP_2_7:
		IN R16,PIND
		CPI R16,0b11111111
		BREQ WAIT_ORDERS_33
	RJMP SUB_LOOP_2_7
;==================================

;=============================================================================================================================

;Function that turn on and off the led0 using  R22.
LED0_1_SEC:
	LDI TEMP,0b11111110 
	OUT PORTB,TEMP		;Turn-on leds.
	RCALL DELAY_1S
	LDI TEMP,0b11111111  
	OUT PORTB,TEMP		;Turn-off leds.
	RCALL DELAY_1S
	DEC R22
	BRNE LED0_1_SEC
RET


;DELAY FUNCTION

DELAY_250mS:
    ldi  r18, 6
    ldi  r19, 19
    ldi  r20, 174
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
RET

DELAY_5S:
    ldi  r18, 203
    ldi  r19, 236
    ldi  r20, 133
L2: dec  r20
    brne L2
    dec  r19
    brne L2
    dec  r18
    brne L2
    nop
RET

DELAY_1S:
    ldi  r18, 21
    ldi  r19, 75
    ldi  r20, 191
L3: dec  r20
    brne L3
    dec  r19
    brne L3
    dec  r18
    brne L3
    nop
RET

END:

