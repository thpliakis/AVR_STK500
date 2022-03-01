;lab3.asm

;Thomas Pliakis 9018, TEAM 6	

;Purpose: The program simulates a washing machine, which takes as inputs the prewash option and the
;          washing program. Theni it executes them turning on and off the corresponding leds. 

.INCLUDE "m16def.inc"  ;include the library of the mc

.DEF TEMP=R19
.DEF PREWASH_TIME=R25

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
CLR R24                           ;Register R24 is used to check if the drainage-rinse is required (0=Not required,1=required).

;Wait SW6 to be pressed and the washing machine start.
WAIT_START_BUTTON:
IN R16,PIND				            	;Read switches
CPI R16,0b10111111
BREQ SWITCH_6_PRESSED                  ;Branch if SW6 is pressed.
RJMP WAIT_START_BUTTON 

;Loop that waits SW6 to be freed.
SWITCH_6_PRESSED:
  	SUB_LOOP_1:
		IN R16,PIND				;Read switches
		CPI R16,0b11111111		;Check if switch 6 has been freed.
		BREQ SWITCH_6_RELEASED	;Branch if switch 6 has been freed.
	RJMP SUB_LOOP_1

SWITCH_6_RELEASED:

;Intialize some helpful values.
LDI R17,20                        ;Register that helps to wait 5 second in order the user to choose prewash or not to.
CLR R22                           ;Register in it is saved prewash or not prewash.
LDI PREWASH_TIME,16               ;Register that helps to count the prewash time (16x250ms=2sec).

;Wait 5 seconds the user to insert if he wants or not prewash.
WAIT_PREWASH:                     
	IN R16,PIND				      ;Read switches
	CPI R16,0b11111011            
	BREQ SWITCH_2_PRESSED         
	DEC R17
	BREQ GO_TO_WAIT_WASH_PROGRAM                         
	RCALL DELAY_250mS              ;Delay 20x250ms=5000ms=5sec 
RJMP WAIT_PREWASH 

;Loop that waits SW2 to be freed with selecting the prewash option.
SWITCH_2_PRESSED:
	SUB_LOOP_2:
        LDI R22,1
		IN R16,PIND
		CPI R16,0b11111111
		BREQ WAIT_WASH_PROGRAM
	RJMP SUB_LOOP_2

;Loop that waits SW2 to be freed without selecting the prewash option.
GO_TO_WAIT_WASH_PROGRAM:
	SUB_LOOP_2_2:
		IN R16,PIND
		CPI R16,0b11111111
		BREQ WAIT_WASH_PROGRAM
	RJMP SUB_LOOP_2_2

;Waiting loop for wash program to be selected.
WAIT_WASH_PROGRAM:
	LDI TEMP,0b11000111             ;Indicate which switches must be pressed in order to choose a program.
	OUT PORTB,TEMP
	RCALL DELAY_5S                  ;Wait 5 seconds so the user see which he can press and manage to press them.
	LDI TEMP,0b11111111             ;Turn off leds.
	OUT PORTB,TEMP 
	IN R16,PIND				        ;Read switches
	CPI R16,0b11000111    
    BREQ PROGRAM_0_SELECTED      	;Branch if the zero program is selected.
	CPI R16,0b11001111            
	BREQ PROGRAM_1_SELECTED      	;Branch if the first program is selected.
	CPI R16,0b11010111            
	BREQ PROGRAM_2_SELECTED      	;Branch if the second program is selected.
	CPI R16,0b11011111            
	BREQ PROGRAM_3_SELECTED      	;Branch if the third program is selected.
	CPI R16,0b11100111           
	BREQ PROGRAM_4_SELECTED      	;Branch if the fourth program is selected.
	CPI R16,0b11101111           
	BREQ PROGRAM_5_SELECTED      	;Branch if the fifth program is selected.
	CPI R16,0b11110111          
	BREQ PROGRAM_6_SELECTED      	;Branch if the sixth program is selected.
	CPI R16,0b11111111           
	BREQ PROGRAM_7_SELECTED     	;Branch in seventh program if no other program is selected.
RJMP WAIT_WASH_PROGRAM

;Loop that waits switches for the program to be freed.
PROGRAM_0_SELECTED:
	SUB_LOOP_10:
        LDI R23,16                  ;Register R23 helps count the duration of each program.
		LDI R24,1                   ;Register R24 is used only on the first 4 program to check if the drainage-rinse is required. 
		IN R16,PIND
		CPI R16,0b11111111
		BREQ PRESS_6_TO_EXECUTE_PROGRAM
	RJMP SUB_LOOP_10

;Loop that waits switches for the program to be freed.
PROGRAM_1_SELECTED:
	SUB_LOOP_11:
        LDI R23,32
		LDI R24,1
		IN R16,PIND
		CPI R16,0b11111111
		BREQ PRESS_6_TO_EXECUTE_PROGRAM
	RJMP SUB_LOOP_11

;Loop that waits switches for the program to be freed.
PROGRAM_2_SELECTED:
	SUB_LOOP_12:
        LDI R23,48
		LDI R24,1
		IN R16,PIND
		CPI R16,0b11111111
		BREQ PRESS_6_TO_EXECUTE_PROGRAM
	RJMP SUB_LOOP_12

;Loop that waits switches for the program to be freed.
PROGRAM_3_SELECTED:
	SUB_LOOP_13:
        LDI R23,72
		LDI R24,1
		IN R16,PIND
		CPI R16,0b11111111
		BREQ PRESS_6_TO_EXECUTE_PROGRAM
	RJMP SUB_LOOP_13

;Loop that waits switches for the program to be freed.
PROGRAM_4_SELECTED:
	SUB_LOOP_14:
        LDI R23,16
		IN R16,PIND
		CPI R16,0b11111111
		BREQ PRESS_6_TO_EXECUTE_PROGRAM
	RJMP SUB_LOOP_14

;Loop that waits switches for the program to be freed.
PROGRAM_5_SELECTED:      	
	SUB_LOOP_15:
        LDI R23,32
		IN R16,PIND
		CPI R16,0b11111111
		BREQ PRESS_6_TO_EXECUTE_PROGRAM
	RJMP SUB_LOOP_15

;Loop that waits switches for the program to be freed.
PROGRAM_6_SELECTED: 
	SUB_LOOP_16:
        LDI R23,48
		IN R16,PIND
		CPI R16,0b11111111
		BREQ PRESS_6_TO_EXECUTE_PROGRAM
	RJMP SUB_LOOP_16

;Loop that waits switches for the program to be freed.
PROGRAM_7_SELECTED:
	SUB_LOOP_17:
        LDI R23,72
		IN R16,PIND
		CPI R16,0b11111111
		BREQ PRESS_6_TO_EXECUTE_PROGRAM
	RJMP SUB_LOOP_17

;Loop that waits SW6 to be pressed so the washing ,after selecing a program, starts.
PRESS_6_TO_EXECUTE_PROGRAM:
    IN R16,PIND				            	;Read switches
    CPI R16,0b10111111
    BREQ SWITCH_62_PRESSED                  ;Branch if SW6 is pressed.
RJMP PRESS_6_TO_EXECUTE_PROGRAM 

;Wait SW6 to be freed.
SWITCH_62_PRESSED:
  	SUB_LOOP_66:
		IN R16,PIND				;Read switches
		CPI R16,0b11111111		;Check if switch 6 has been freed.
		BREQ CHECK_SW1
	RJMP SUB_LOOP_66

;In this loop is check for 10 sec if the overload switch is pressed.
CHECK_SW1:
    LDI R17,40
CHECK_SW1_FOR_10_SEC:
    IN R16,PIND				            	;Read switches
    CPI R16,0b11111101
    BREQ SWITCH_PRESSED_111                  ;Branch if SW1 is pressed.
	DEC R17
	BREQ EXECUTE_PROGRAM                         
	RCALL DELAY_250mS              ;Delay 40x250ms=10000ms=10sec 
RJMP CHECK_SW1_FOR_10_SEC

;Wait SW1 to be freed.
SWITCH_PRESSED_111:
  	SUB_LOOP_111:
		IN R16,PIND				;Read switches
		CPI R16,0b11111111		;Check if switch 1 has been freed.
		BREQ OVERLOAD          	;Branch if switch 1 has been freed.
	RJMP SUB_LOOP_111

;Wait in overload mode until SW1is pressed again.
OVERLOAD:
	LDI TEMP,0b11111101
	OUT PORTB,TEMP 
	RCALL DELAY_1S
	LDI TEMP,0b11111111
	OUT PORTB,TEMP
	RCALL DELAY_1S
    IN R16,PIND				            	;Read switches
    CPI R16,0b11111101
    BREQ NOT_OVERLOAD                ;Branch if SW0 is pressed.
 RJMP OVERLOAD 
 
;Wait SW1 to be freed.
 NOT_OVERLOAD:
  	SUB_LOOP_NOT_OVERLOAD: 
		IN R16,PIND				;Read switches
		CPI R16,0b11111111		;Check if switch 1 has been freed.
		BREQ EXECUTE_PROGRAM	;Branch if switch 1 has been freed.
	RJMP SUB_LOOP_NOT_OVERLOAD
    
;Execute main washing program.
EXECUTE_PROGRAM:
    TST R22                     ;Check for prewash.
    BRNE PREWASH                ;Branch if prewash is needed.
WASHING_LED_TURN_ON:
    LDI TEMP,0b11110111                                                         
    OUT PORTB,TEMP              ;Turn on leds to indicate to witch washing step the washing machine is.
WASHING:
	LDI TEMP,0b11110111                                                         
    OUT PORTB,TEMP
   	IN R16,PIND				      ;Read switches
	SBRS R16,0                  ;Check bit 0 to see if SW0 has been pressed and skip next command if it does not.
    RCALL DOOR_OPENED
	SBRS R16,7                  ;Check bit 7 to see if SW7 has been pressed and skip next command if it does not.
    RCALL WATER_SORTAGE          
    DEC R23
    BREQ FINISH_MAIN_WASHING         ;Check if R23 is zero,which means that the program has finished, and branch.
    RCALL DELAY_250mS
RJMP WASHING

;Finish main washing
FINISH_MAIN_WASHING:
    TST R24 
    BRNE RINSE
    
;Turn on led7 after everything has finished for 5 sec.
END_EVERYTHING:
    LDI TEMP,0b01111111      
	OUT PORTB,TEMP
    RCALL DELAY_5S
    LDI TEMP,0b11111111       
    OUT PORTB,TEMP
RJMP END_LOOP 

;Branch here if the program has finshed rinsing.
DRAINAGE:
    LDI TEMP,0b11101111                                                         
    OUT PORTB,TEMP
    LDI  R25,8
DRAINAGING:
	LDI TEMP,0b11101111                                                         
    OUT PORTB,TEMP
   	IN R16,PIND				      ;Read switches
	SBRS R16,0               ;Check bit 0 to see if SW0 has been pressed and skip next command if it does not.
    RCALL DOOR_OPENED        
	SBRS R16,7               ;Check bit 7 to see if SW7 has been pressed and skip next command if it does not.
    BREQ  WATER_SORTAGE       
    DEC R25
    BREQ END_EVERYTHING
    RCALL DELAY_250mS
RJMP DRAINAGING

;Branch here if the program has rinse and drainage.
RINSE:
    LDI TEMP,0b11110011
    OUT PORTB,TEMP
    LDI R25,4
RINSING:
	LDI TEMP,0b11110011
    OUT PORTB,TEMP
   	IN R16,PIND				      ;Read switches
	SBRS R16,0               ;Check bit 0 to see if SW0 has been pressed and skip next command if it does not.
    RCALL DOOR_OPENED        
	SBRS R16,7               ;Check bit 7 to see if SW7 has been pressed and skip next command if it does not.
    RCALL WATER_SORTAGE      
    DEC R25
    BREQ DRAINAGE
    RCALL DELAY_250mS
RJMP RINSING

;Prewash loop
PREWASH:
    LDI TEMP,0b11111011                                                         
    OUT PORTB,TEMP
PREWASHING:
   	IN R16,PIND				      ;Read switches
	SBRS R16,0                ;Check bit 0 to see if SW0 has been pressed and skip next command if it does not.
    RCALL DOOR_OPENED
	SBRS R16,7                ;Check bit 7 to see if SW7 has been pressed and skip next command if it does not.
    RCALL WATER_SORTAGE
    DEC PREWASH_TIME
    BREQ WASHING_LED_TURN_ON   ;Branch to continue to the main wash program.
    RCALL DELAY_250mS
RJMP PREWASHING

;End loop.
END_LOOP:
NOP
RJMP  END_LOOP


;=============================================================================================================================

;Function for when the door opens.

DOOR_OPENED:
  	SUB_LOOP_DOOR_OPENED:
		IN R26,PIND			         ;Read switches
		CPI R26,0b11111111		   
		BREQ WAIT_DOOR_TO_CLOSE     
	RJMP SUB_LOOP_DOOR_OPENED

;Loop that waits SW0 to be pressed in order to close the door.
WAIT_DOOR_TO_CLOSE:
	LDI TEMP,0b11111110        
	OUT PORTB,TEMP               ;Turn on and off led to indicate the door is opened. 
	RCALL DELAY_1S
	LDI TEMP,0b11111111
	OUT PORTB,TEMP
	RCALL DELAY_1S
    IN R26,PIND				            	;Read switches
    CPI R26,0b11111110
    BREQ ALMOST_CLOSED          ;Branch if SW0 is pressed again.     
    LDI TEMP,0b11111110
    OUT PORTB,TEMP
    RCALL DELAY_500S
    LDI TEMP,0b11111111
    OUT PORTB,TEMP
RJMP WAIT_DOOR_TO_CLOSE

;Loop that waits SW0 to be freed.
ALMOST_CLOSED:
  	SUB_LOOP_DOOR_ALMOST_CLOSED:
		IN R26,PIND			         ;Read switches
		SBRC R26,0		             ;Check if SW0 is cleared and skip the next command if it is. 
		RET
	RJMP SUB_LOOP_DOOR_ALMOST_CLOSED

;=============================================================================================================================

;Function for when we have water sortage.

WATER_SORTAGE:
  	SUB_LOOP_WATER_STORAGE:
		IN R26,PIND			         ;Read switches
		CPI R26,0b11111111		   
		BREQ WAIT_WATER     
	RJMP SUB_LOOP_WATER_STORAGE

;Loop that waits SW7 to be pressed in order to water to come back.
WAIT_WATER:
	LDI TEMP,0b10111101
	OUT PORTB,TEMP 
	RCALL DELAY_1S
	LDI TEMP,0b10111111
	OUT PORTB,TEMP
	RCALL DELAY_1S
    IN R26,PIND				            	;Read switches
    CPI R26,0b01111111
    BREQ ALMOST_WATER            ;Branch if SW7 is pressed again.   
    LDI TEMP,0b10111101
    OUT PORTB,TEMP
    RCALL DELAY_500S
    LDI TEMP,0b10111111
    OUT PORTB,TEMP
RJMP WAIT_WATER

;Loop that waits SW0 to be freed.
ALMOST_WATER:
    LDI TEMP,0b11111111
    OUT PORTB,TEMP
  	SUB_LOOP_WATER_ALMOST_BACK:
		IN R26,PIND			         ;Read switches
		SBRC R26,7		             ;Check if SW0 is cleared and skip the next command if it is.
		RET
	RJMP SUB_LOOP_WATER_ALMOST_BACK


;=============================================================================================================================

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


DELAY_500S:
    ldi  r18, 11
    ldi  r19, 38
    ldi  r20, 94
L2: dec  r20
    brne L2
    dec  r19
    brne L2
    dec  r18
    brne L2
RET

DELAY_5S:
    ldi  r18, 102
    ldi  r19, 118
    ldi  r20, 194
L4: dec  r20
    brne L4
    dec  r19
    brne L4
    dec  r18
    brne L4
RET

END:
