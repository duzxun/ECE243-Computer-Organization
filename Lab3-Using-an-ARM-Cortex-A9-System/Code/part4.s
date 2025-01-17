/* Program that converts a binary number to decimal */
           
           .text               // executable code follows
           .global _start
_start:
            MOV    R4, #N
            MOV    R5, #Digits  // R5 points to the decimal digits storage location
            LDR    R4, [R4]     // R4 holds N
            MOV    R0, R4       // parameter for DIVIDE goes in R0
	    MOV	   R1, #1000 	
            BL     DIVIDE
	    STRB   R3, [R5, #3] // Thousands digit is in R3
	    MOV    R1, #100
	    BL 	   DIVIDE
	    STRB   R3, [R5, #2] //Hundreds
	    MOV	   R1, #10
            BL	   DIVIDE
	    STRB   R3, [R5, #1] //Tens
	    STRB   R0, [R5] 	//no need to divide for the last digit (remainder)
END:        B      END

			
/* Subroutine to perform the integer division R0 / R1.
 * Returns: quotient in R3, and remainder in R0 */
DIVIDE:     MOV    R2, #0	
CONT:       CMP    R0, R1		  
            BLT    DIV_END		 //brach if R0<R1
            SUB    R0, R1		
            ADD    R2, #1		
            B      CONT
DIV_END:    MOV	   R3, R2   //quotient in R3 (remainder in R0)   
            MOV    PC, LR

N:          .word  9876       // the decimal number to be converted
Digits:     .space 4          // storage space for the decimal digits

            .end
