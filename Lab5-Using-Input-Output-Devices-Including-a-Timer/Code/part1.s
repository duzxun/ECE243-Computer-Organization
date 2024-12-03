.global _start
_start:	
	LDR R5, =0xFF200050 //Load KEY3-0
	LDR R4, =0xFF200020 //Load HEX3-0
	MOV R0, #0 //initialize the counter to 0
	
MAIN:
	LDR R3, [R5] //load R4 with the data from KEYs
	CMP R3, #0
	BNE WAIT
	
	CMP R1, #0
	BEQ MAIN		//Nothing pressed
	
	CMP R1, #1
	BEQ ZERO 		//KEY0 
	
	CMP R1, #2
	BEQ INCREMENT	//KEY 1
	
	CMP R1, #4
	BEQ DECREMENT	//KEY2
	
	CMP R1, #8
	BEQ BLANK		//KEY3

//Wait for KEY release
WAIT:	
	MOV R1, R3		//R1 holds the value of R4 (which KEY)
	LDR R3, [R5]	//check KEY value until 0 (released)
	CMP R3, #0
	BNE WAIT
	B MAIN

//Sets the display to 0
ZERO:
	MOV R0, #0 		//Reset counter to 0
	BL DISPLAY		//Display 0
	
//Increment the display if less than 9
INCREMENT:
	CMP R2, #1
	BEQ	INCREMENT_FROM_BLANK
	CMP R0, #9		//Can increment up to 9	
	BLT	ADD_ONE		//If less than 9 increment
	BEQ	DISPLAY
	BGT MAIN		//Else return to MAIN

INCREMENT_FROM_BLANK:
	MOV R2, #0 		//Set "flag" back to 0
	BL SEG7_CODE
	STR R1, [R4] 	//Display R1 in HEX0
	B	KEEP

	
//Advance the counter if less than 9
ADD_ONE:
	ADD R0, #1
	BL	DISPLAY 	

//Decrement the display if grater than 0
DECREMENT:
	CMP R0, #0		//Can decrement up to 0
	BGT	SUB_ONE		//If grater than 0 decrement
	BEQ DISPLAY
	BLT MAIN		//Else return to MAIN

//Decrement the counter 
SUB_ONE:
	SUB R0, #1
	BL DISPLAY

//Turn off the display
BLANK: 
	MOV R0, #0 		//reset counter
	MOV	R1, #0
	MOV R2, #1		//use as a flag for INCREMENT
	STR R1, [R4] 	//display nothing
	B 	KEEP
	
	
//Display the number using SEG7_CODE
DISPLAY:
	BL SEG7_CODE
	STR R1, [R4] 	//Display R1 in HEX0
	B	KEEP

//Returns in the bit code in R1 
SEG7_CODE:  MOV     R1, #BIT_CODES  
            ADD     R1, R0         // index into the BIT_CODES "array"
            LDRB    R1, [R1]       // load the bit pattern (to be returned)
            MOV     PC, LR  

//Responds to KEY changes			
KEEP:
	LDR	R1, [R5]
	CMP R1, R3
	BEQ KEEP
	B MAIN


//0 to 9 bit codes for HEX display
BIT_CODES:  .byte   0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110
            .byte   0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01100111
            .skip   2   //pad for word alignment
			
	