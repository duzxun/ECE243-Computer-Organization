           	   .equ      EDGE_TRIGGERED,    0x1
               .equ      LEVEL_SENSITIVE,   0x0
               .equ      CPU0,              0x01    // bit-mask; bit 0 represents cpu0
               .equ      ENABLE,            0x1

               .equ      KEY0,              0b0001
               .equ      KEY1,              0b0010
               .equ      KEY2,              0b0100
               .equ      KEY3,              0b1000

               .equ      IRQ_MODE,          0b10010
               .equ      SVC_MODE,          0b10011

               .equ      INT_ENABLE,        0b01000000
               .equ      INT_DISABLE,       0b11000000
/*********************************************************************************
 * Initialize the exception vector table
 ********************************************************************************/
                .section .vectors, "ax"

                B        _start             // reset vector
                .word    0                  // undefined instruction vector
                .word    0                  // software interrrupt vector
                .word    0                  // aborted prefetch vector
                .word    0                  // aborted data vector
                .word    0                  // unused vector
                B        IRQ_HANDLER        // IRQ interrupt vector
                .word    0                  // FIQ interrupt vector


/*********************************************************************************
 * Main program
 ********************************************************************************/
                .text
                .global  _start
_start:        
                /* Set up stack pointers for IRQ and SVC processor modes */
   				MOV R0, #IRQ_MODE	//IRQ mode bits
				MSR CPSR, R0		//change to IRQ mode (move status register)
				LDR	SP, =0x200000	//set SP for IRQ mode
				
				MOV	R0, #SVC_MODE	//SVC mode bits
				MSR CPSR, R0		//change (back) to SVC mode
				LDR SP, =0x400000	//set SP for SVC mode

                BL       CONFIG_GIC              // configure the ARM generic interrupt controller

                // Configure the KEY pushbutton port to generate interrupts
				LDR		R0, =0xFF200050		// pushbutton KEY base address
				MOV		R1, #0xF			// set interrupt mask bits
				STR		R1, [R0, #0x8]		// interrupt mask register is (base + 8)
			
                // enable IRQ interrupts in the processor
				MSR CPSR, #0b01010011		// IRQ unmasked (enabled), MODE = SVC
				
				LDR R0, =0xFF200020		//HEX base
				MOV R1, #0				//initialize to blank
							
IDLE:
                B        IDLE                    // main program simply idles

HEX_0:				.word		0
HEX_1:				.word		0
HEX_2:				.word		0
HEX_3:				.word		0 

IRQ_HANDLER:
                PUSH     {R0-R7, LR}
    
                /* Read the ICCIAR in the CPU interface */
                LDR      R4, =0xFFFEC100
                LDR      R5, [R4, #0x0C]         // read the interrupt ID

CHECK_KEYS:
                CMP      R5, #73
UNEXPECTED:     BNE      UNEXPECTED              // if not recognized, stop here
    
                BL       KEY_ISR
EXIT_IRQ:
                /* Write to the End of Interrupt Register (ICCEOIR) */
                STR      R5, [R4, #0x10]
    
                POP      {R0-R7, LR}
                SUBS     PC, LR, #4

/*****************************************************0xFF200050***********************************
 * Pushbutton - Interrupt Service Routine                                
 *                                                                          
 * This routine checks which KEY(s) have been pressed. It writes to HEX3-0
 ***************************************************************************************/
              .global  KEY_ISR
KEY_ISR:
			  LDR R0, =0xFF200050	//pushbutton KEY port base address
			  LDR R1, [R0, #0xC]	//Edgecapture
			  MOV R2, #0xF
			  STR R2, [R0, #0xC]	//clear the interrupt
			 
			  LDR	R0, =0xFF200020	//load HEX ports
KEY_0:
			  CMP	R1, #1
			  BNE	KEY_1
			  LDR	R1, HEX_0		//get HEX0 value
			  EOR	R1, #0b00111111	//invert the HEX value
			  STR	R1, [R0]		//display
			  STR	R1, HEX_0		//store the value in HEX0
			  B 	DONE
			  
KEY_1:
			  CMP	R1, #2
			  BNE	KEY_2
			  LDR	R1, HEX_1	
			  EOR	R1, #0b00000110		
		   	  LSL	R2, R1, #8		
		      STR   R2, [R0]
			  STR	R1, HEX_1	// store the value
		      B		DONE	
			  
KEY_2:	
			  CMP	R1, #4
			  BNE	KEY_3
			  LDR	R1, HEX_2	
			  EOR	R1, #0b01011011		
		   	  LSL	R2, R1, #16		
		      STR   R2, [R0]
			  STR	R1, HEX_2	// store the value
		      B		DONE
			  

KEY_3:	
			  CMP	R1, #8
			  BNE	DONE
			  LDR	R1, HEX_3	
			  EOR	R1, #0b01001111		
		   	  LSL	R2, R1, #24		
		      STR   R2, [R0]
			  STR	R1, HEX_3	// store the value
		      B		DONE

				
DONE:
			  MOV	R3, #15
			  STR 	R3, [R0, #0xC] //clear Edgecapture
              MOV   PC, LR


/* 
 * Configure the Generic Interrupt Controller (GIC)
*/
                .global  CONFIG_GIC
CONFIG_GIC:
                PUSH     {LR}
                /* Enable the KEYs interrupts */
                MOV      R0, #73
                MOV      R1, #CPU0
                /* CONFIG_INTERRUPT (int_ID (R0), CPU_target (R1)); */
                BL       CONFIG_INTERRUPT

                /* configure the GIC CPU interface */
                LDR      R0, =0xFFFEC100        // base address of CPU interface
                /* Set Interrupt Priority Mask Register (ICCPMR) */
                LDR      R1, =0xFFFF            // enable interrupts of all priorities levels
                STR      R1, [R0, #0x04]
                /* Set the enable bit in the CPU Interface Control Register (ICCICR). This bit
                 * allows interrupts to be forwarded to the CPU(s) */
                MOV      R1, #1
                STR      R1, [R0]
    
                /* Set the enable bit in the Distributor Control Register (ICDDCR). This bit
                 * allows the distributor to forward interrupts to the CPU interface(s) */
                LDR      R0, =0xFFFED000
                STR      R1, [R0]    
    
                POP      {PC}
/* 
 * Configure registers in the GIC for an individual interrupt ID
 * We configure only the Interrupt Set Enable Registers (ICDISERn) and Interrupt 
 * Processor Target Registers (ICDIPTRn). The default (reset) values are used for 
 * other registers in the GIC
 * Arguments: R0 = interrupt ID, N
 *            R1 = CPU target
*/
CONFIG_INTERRUPT:
                PUSH     {R4-R5, LR}
    
                /* Configure Interrupt Set-Enable Registers (ICDISERn). 
                 * reg_offset = (integer_div(N / 32) * 4
                 * value = 1 << (N mod 32) */
                LSR      R4, R0, #3               // calculate reg_offset
                BIC      R4, R4, #3               // R4 = reg_offset
                LDR      R2, =0xFFFED100
                ADD      R4, R2, R4               // R4 = address of ICDISER
    
                AND      R2, R0, #0x1F            // N mod 32
                MOV      R5, #1                   // enable
                LSL      R2, R5, R2               // R2 = value

                /* now that we have the register address (R4) and value (R2), we need to set the
                 * correct bit in the GIC register */
                LDR      R3, [R4]                 // read current register value
                ORR      R3, R3, R2               // set the enable bit
                STR      R3, [R4]                 // store the new register value

                /* Configure Interrupt Processor Targets Register (ICDIPTRn)
                  * reg_offset = integer_div(N / 4) * 4
                  * index = N mod 4 */
                BIC      R4, R0, #3               // R4 = reg_offset
                LDR      R2, =0xFFFED800
                ADD      R4, R2, R4               // R4 = word address of ICDIPTR
                AND      R2, R0, #0x3             // N mod 4
                ADD      R4, R2, R4               // R4 = byte address in ICDIPTR

                /* now that we have the register address (R4) and value (R2), write to (only)
                 * the appropriate byte */
                STRB     R1, [R4]
    
                POP      {R4-R5, PC}
				

    

.end   

	