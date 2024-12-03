		   .text               // executable code follows
           .global _start
_start:
/* code for Part III */
	 	  MOV     R4, #TEST_NUM   // R4 points to the data
          MOV     R5, #0	      // result will be in R5
		  MOV 	  R6, #0
		  MOV	  R7, #0
		  

MAIN:	  LDR     R1, [R4]	      //load the word in R1 					 
		  CMP 	  R1, #0	
		  BEQ     DISPLAY
		
		  MOV     R0, #0          //R0 will hold the result (initialize to 0)
		  BL 	  ONES			  //parameter in R1 and result in R0
		  CMP	  R5, R0		  //check if the word has the largest seq of 1's
		  MOVLT	  R5, R0		  //if so move the new value to R5
		  
		  BL      ZEROS
		  BL      INITIALIZER
		  BL	  ONES		      //same as above for zeros and alternate
		  CMP	  R6, R0		  //R6 holds largest sequence of 0's
		  MOVLT   R6, R0
		  
		  BL      ALTERNATE	 	 //prepare to load 0101...
		  BL	  INITIALIZER
		  BL	  ONES       
		  CMP	  R7, R0          //R7 holds largest sequence of 0-1s
		  MOVLT   R7, R0
		  
		  BL      ALTERNATE 	  //prepare to load 1010...
		  ADD	  R3, #4
		  BL	  INITIALIZER
		  BL	  ONES       
		  CMP	  R7, R0          //R7 holds largest sequence of 0-1s
		  MOVLT   R7, R0
		 
		  ADD	  R4, #4		  //increment R4 to point at the next word	
		  B		  MAIN			  //branch back to MAIN to read the next word


INITIALIZER:
          MOV     R0, #0          //R0 will hold the result 
		  LDR	  R3, [R3]        //R3 gets the data 
		  LDR	  R1, [R4]        //reload R1
		  EOR     R1, R3		  //find R1's 1's complement (1's where 0's exist)
		  MOV	  PC, LR
		  
//Find the longest sequence of 1's in R1 and return in R0
ONES:	  CMP     R1, #0          // loop until the data contains no more 1's
 		  BEQ     END_ONES
       	  LSR     R2, R1, #1      // perform SHIFT, followed by AND
   		  AND     R1, R1, R2 
		  ADD     R0, #1          // count the string length so far
	      B 	  ONES
    
END_ONES:  MOV     PC, LR	      //return from ONES    

//Preparing to convert 0s to 1s using 1s complement of R1
ZEROS:     MOV	   R3, #CONST      //prepare to load 1111...
		   MOV     PC, LR	     	//return from ZEROS   

//Preparing to convert alternating sequences to 1s 
ALTERNATE:
          MOV	  R3, #CONST
		  ADD	  R3, #4	
          MOV     PC, LR	 		 //return from ALTERNATE  

/* Subroutine to convert the digits from 0 to 9 to be shown on a HEX display.
 *    Parameters: R0 = the decimal value of the digit to be displayed
 *    Returns: R0 = bit pattern to be written to the HEX display
 */			
SEG7_CODE:  MOV     R1, #BIT_CODES  
            ADD     R1, R0         // index into the BIT_CODES "array"
            LDRB    R0, [R1]       // load the bit pattern (to be returned)
            MOV     PC, LR  
			
/* Subroutine to perform the integer division R0/10.
 * Returns: quotient in R1, and remainder in R0 */
DIVIDE:     MOV    R2, #0	
CONT:       CMP    R0, #10		  
            BLT    DIV_END		 //brach if R0<R1
            SUB    R0, #10		
            ADD    R2, #1		
            B      CONT
DIV_END:    MOV	   R1, R2   //quotient in R1 (remainder in R0)   
            MOV    PC, LR
			
/* Display R5 on HEX1-0, R6 on HEX3-2 and R7 on HEX5-4 */
DISPLAY:    LDR     R8, =0xFF200020 // base address of HEX3-HEX0
            MOV     R0, R5          // display R5 on HEX1-0
            BL      DIVIDE          // ones digit will be in R0; tens
                                    // digit in R1
            MOV     R9, R1          // save the tens digit
            BL      SEG7_CODE       
            MOV     R4, R0          // save bit code (HEX0)
            MOV     R0, R9          // retrieve the tens digit, get bit
                                    // code
            BL      SEG7_CODE       
            LSL     R0, #8			//left shift 8 bits
            ORR     R4, R0          //HEX1
		   	
			//code for R6
			MOV     R0, R6          // display R6 on HEX3-2
            BL      DIVIDE          // ones digit will be in R0; tens
                                    // digit in R1
			MOV     R9, R1          // save the tens digit
            BL      SEG7_CODE 
			LSL     R0, #16         //left shift 16 bits
			ORR     R4, R0          //HEX2

			MOV     R3, R0          // save bit code
            MOV     R0, R9          // retrieve the tens digit, get bit code
            BL      SEG7_CODE       
            LSL     R0, #24			//left shift 24 bits
            ORR     R4, R0			//HEX3
            
			STR     R4, [R8]        // display the numbers from R6 and R5
            
			//code for R7
			LDR     R8, =0xFF200030 // base address of HEX5-HEX4
			MOV     R0, R7          // display R6 on HEX3-2
            BL      DIVIDE          // ones digit will be in R0; tens
                                    // digit in R1
			MOV     R9, R1          // save the tens digit
            BL      SEG7_CODE 
			MOV     R4, R0          // save bit code (HEX4)
            MOV     R0, R9          // retrieve the tens digit, get bit
                                    // code
            BL      SEG7_CODE       
            LSL     R0, #8          //left shift 8 bits
            ORR     R4, R0          //HEX5
            
			STR     R4, [R8]        // display the numbers from R7
				
         
END:		B 		END
            

BIT_CODES:  .byte   0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110
            .byte   0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01100111
            .skip   2      // pad with 2 bytes to maintain word alignment

CONST:    .word   0xffffffff		//1111...
		  .word   0x55555555 		//0101...
		  .word   0xaaaaaaaa        //1010...

TEST_NUM: .word   0x55555555
		  .word	  0x471aae0d		
		  .word   0xdeadbeef 
		  .word   0xdd3c412d
		  .word   0x905f5b7c
		  .word   0xb3d65c25
		  .word   0x3d4600a1
		  .word   0x103fe00f
		  .word	  0x00bebe00
		  .word   0x172a6f14
		  .word   0x539c03ff
		  .word   0x41ca7fad 
		  .word   0xb4b695db
		  .word   0x00000fff
          .word	  0x7c73f7fb
		  .word   0xb11a01c9
		 
		  .word   0
          .end      
	