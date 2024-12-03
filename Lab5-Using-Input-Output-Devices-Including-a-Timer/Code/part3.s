.global _start
_start:
	LDR R4, =0xFF200050 //Load KEYs
	MOV R0, #0 		//initialize counter to 0
	MOV	R5, #15		//R5 is 1111 (for Edgecapture)
	
	LDR R7, =0xFFFEC600 //base address for Timer
	LDR	R3, =50000000  //0.25s (200MHz/4)
	STR	R3, [R7]		//set the timer
	MOV R3, #0x3		//I, A, E (011)
	STR	R3, [R7, #8]	
	
MAIN:	
	CMP R0, #0x63		//check if reached 99
	BGE	RESET	

//Check KEYs to start/stop
START_STOP:	
	LDR R1, [R4, #0xc]  	//check Edgecapture
	STR	R5, [R4, #0xc]		//reset Edgecapture
	CMP R1, #0				//no key pressed
	BLNE	STOP			

INCREMENT:
	ADD R0, #1
	B	DISPLAY
	
//Reset counter
RESET: 
	MOV R0, #0		
	B	START_STOP
	
STOP:
	LDR	R1, [R4, #0xc]	//check Edgecapture
	CMP R1, #0	
	BEQ	STOP
	STR	R5, [R4, #0xc]	//reset Edgecapture
	MOV PC, LR
		

//Display the numbers
DISPLAY:    LDR     R8, =0xFF200020 // base address of HEX3-HEX0
            MOV     R3, R0          // display R3 on HEX1-0
            BL      DIVIDE          // ones digit will be in R3; tens
                                    // digit in R1
            MOV     R9, R1          // save the tens digit
            BL      SEG7_CODE       
            MOV     R6, R3	        // save bit code (HEX0)
            MOV     R3, R9          // retrieve the tens digit, get bit
                                    // code
            BL      SEG7_CODE       
            LSL     R3, #8			//left shift 8 bits
            ORR     R6, R3          //HEX1
            
			STR     R6, [R8]        // display the numbers 
			
			BL		DELAY
			B		MAIN
            
//Delay loop
DELAY: 
	LDR R3, [R7, #0xc] //check F register (interrupt)
	CMP R3, #0x1	   	
	BNE	DELAY
	
	STR R3, [R7, #0xc]
	MOV PC, LR

/* Subroutine to perform the integer division R3/10.
 * Returns: quotient in R1, and remainder in R3 */
DIVIDE:     MOV    R2, #0	
CONT:       CMP    R3, #10		  
            BLT    DIV_END		 //brach if R0<R1
            SUB    R3, #10		
            ADD    R2, #1		
            B      CONT
DIV_END:    MOV	   R1, R2   //quotient in R1 (remainder in R0)   
            MOV    PC, LR
				
	
//Returns in the bit code in R1 
SEG7_CODE:  MOV     R1, #BIT_CODES  
            ADD     R1, R3         // index into the BIT_CODES "array"
            LDRB    R3, [R1]       // load the bit pattern (to be returned)
            MOV     PC, LR	
	
	
//0 to 9 bit codes for HEX display
BIT_CODES:  .byte   0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110
            .byte   0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01100111
            .skip   2   //pad for word alignment

END:		B END