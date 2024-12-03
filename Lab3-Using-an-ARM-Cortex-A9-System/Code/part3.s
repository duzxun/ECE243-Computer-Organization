/* Program that finds the largest number in a list of integers	*/
            
            .text                   // executable code follows
            .global _start                  
_start:                             
            MOV     R4, #RESULT     // R4 points to result location
            LDR     R0, [R4, #4]    // R0 holds the number of elements in the list
            MOV     R1, #NUMBERS    // R1 points to the start of the list
	    LDR     R3, [R1]        //R3 holds the contents of the first element of the list
            BL      LARGE           //brach to LARGE label
            STR     R0, [R4]        // R0 holds the subroutine return value

END:        B       END             

/* Subroutine to find the largest integer in a list
 * Parameters: R0 has the number of elements in the list
 *             R1 has the address of the start of the list 
 * Returns: R0 returns the largest item in the list */
LARGE:     		SUBS R0, #1			//decrement the loop counter by 1
			BEQ DONE			//if R0=0 branch to done
			ADD R1, #4			//increment R1
			LDR R2, [R1]    		//load R2 with contents of R1
			CMP R3, R2			//compare the biggest so far(initially first element)
							//with each element on by one
			BGE LARGE			//if R3 is larger or equal, branch 
			MOV R3, R2 			//else larger number get updated
			B LARGE				//branch
			
DONE:			MOV R0, R3			//R0 gets the contents of R3 which holds the largest
			MOV PC, LR			//return R0  
			
RESULT:     .word   0           
N:          .word   7           // number of entries in the list
NUMBERS:    .word   4, 5, 3, 6  // the data
            .word   1, 8, 2                 

            .end                            
