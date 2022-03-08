;****************** ODDPARITY.s ***************
; Author:  Ashwin Ram                 
; Date Created: 1/15/2018 
; Last Modified: 1/30/2022  <-- put the date here

; The objective of this system is to implement a parity system
; Hardware connections:
; WE ARE DOING ODD PARITY
;  Output is positive logic, 1 turns on the LED, 0 turns off the LED
;  Inputs are positive logic, meaning switch not pressed is 0, pressed is 1
;    PE0 is an input   <-- change this to match your assignment
;    PE1 is an input   <-- change this to match your assignment
;    PE2 is an input   <-- change this to match your assignment
;    PE5 is the output <-- change this to match your assignment

GPIO_PORTD_DATA_R  EQU 0x400073FC
GPIO_PORTD_DIR_R   EQU 0x40007400
GPIO_PORTD_DEN_R   EQU 0x4000751C
GPIO_PORTE_DATA_R  EQU 0x400243FC
GPIO_PORTE_DIR_R   EQU 0x40024400
GPIO_PORTE_DEN_R   EQU 0x4002451C
SYSCTL_RCGCGPIO_R  EQU 0x400FE608
       PRESERVE8 
       AREA   Data, ALIGN=4
; No global variables needed

       ALIGN 4
       AREA    |.text|, CODE, READONLY, ALIGN=2
       THUMB
       EXPORT EID
EID    DCB "ar67262",0  ;replace abc123 with your EID
       EXPORT RunGrader
	   ALIGN 4
RunGrader DCD 1 ; change to nonzero when ready for grading
           
      EXPORT  Lab1
Lab1 
; Initializations
; Turn on the clock for port E
	LDR R0,=SYSCTL_RCGCGPIO_R
	LDR R1,[R0] 
	ORR R1,R1,#16; set bit 4 (Port E)
	STR R1, [R0]
	NOP; CLOCK SIGNAL
	NOP; CLOCK SIGNAL
	NOP;
	NOP;


	;INITIALIZE INPUTS AND OUTPUTS
	LDR R0, =GPIO_PORTE_DIR_R
	LDR R1, [R0]
	LDR R8, [R0]
	ORR R8, R1, #32; set bit 5 to a 1 so that it can be an ouput (PE5)
	BIC R1, R1, #7; clear bits 0, 1, 2 to 0 (makes them (PE0, PE1, PE2) an input)
	ORR R8, R8, R1
	STR R8, [R0]

	; DIGITAL ENABLE ALL OF THE PINS WE ARE USING
	LDR R0, =GPIO_PORTE_DEN_R
	LDR R1,[R0]
	ORR R1, R1, #39; digital enable all the pins (0, 1, 2, and 5) by setting them to a 1. 
	STR R1, [R0]

loop
;input, calculate, output    
; Ashwin's algorithm: Pin2 xOR with Pin 1 xor with Pin0. Then not the resultant, and you have odd parity. 

;load from the data register
	LDR R0,= GPIO_PORTE_DATA_R
	LDR R1, [R0]; NOW WE HAVE THE MEMORY CONTENTS OF THE DATA REGISTER
	AND R2, R1, #0x04; GET PIN 2
	LSR R2, #2
	AND R3, R1,#0x02; GET PIN 1
	LSR R3, #1
	AND R4, R1, #0x01; GET PIN 0
	; NOW R2 HAS PIN 2; R3 HAS PIN 1; R4 HAS PIN 0
	EOR R5, R2, R3; R5 HAS PIN2 XORED WITH PIN1
	EOR R6, R5, R4; R6 HAS THE PRODUCT OF THE XOR FROM PIN2 AND PIN1 XORED WITH PIN0
	EOR R9, R6, #1; R6 HAS THE NOT OF ITSELF
	LSL R9, R9, #5; MOVE TO BIT 5
	STR R9,[R0]
    B    loop


    
    ALIGN        ; make sure the end of this section is aligned
    END          ; end of file
               
