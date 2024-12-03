/* Program that counts consecutive 1's */

          .text                   // executable code follows
          .global _start                  
_start:

		  MOV     R4, #TEST_NUM   // R4 points to the data
          MOV     R5, #0	      // result will be in R5

MAIN:	  LDR     R1, [R4], #4    //load the word in R1 
								  //increment R4 to point at the next word	
		  CMP 	  R1, #0	
		  BEQ     END
		  MOV     R0, #0          // R0 will hold the result (initialize to 0)
		  BL 	  ONES			  //parameter in R1 and result in R0
		  CMP	  R5, R0		  //check if the word has the largest seq of 1's
		  MOVLT	  R5, R0		  //if so move the new value to R5
		  B		  MAIN			  //branch back to MAIN to read the next word
END: 	  B		  END

//Find the longest sequence of 1's in R1 and return in R0
ONES:	  CMP     R1, #0          // loop until the data contains no more 1's
 		  BEQ     ENDONES
       	  LSR     R2, R1, #1      // perform SHIFT, followed by AND
   		  AND     R1, R1, R2 
		  ADD     R0, #1          // count the string length so far
	      B 	  ONES
    
ENDONES:  MOV     PC, LR	      //return from ONES    


TEST_NUM: .word	  0x471aae0d
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
