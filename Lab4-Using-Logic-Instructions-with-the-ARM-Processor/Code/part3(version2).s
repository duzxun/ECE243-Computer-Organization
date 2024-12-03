/* Program that counts consecutive 1's */

          .text                   // executable code follows
          .global _start                  
_start:

		  MOV     R4, #TEST_NUM   // R4 points to the data
          MOV     R5, #0	      // result will be in R5
		  MOV 	  R6, #0
		  MOV	  R7, #0
		  

MAIN:	  LDR     R1, [R4]	      //load the word in R1 					 
		  CMP 	  R1, #0	
		  BEQ     END
		
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
END: 	  B		  END

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