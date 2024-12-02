.define LED_ADDRESS 0x1000
.define HEX_ADDRESS 0x2000
.define SW_ADDRESS 0x3000
.define STACK 255

//Decimal counter
	mv r5, #STACK  //stack ptr
	mv r6, pc	//return adress from subroutine
MAIN: 	pc, #BLANK	//call subroutine to clear HEX displays
	mv r0, #0	//intialize counter to 0
LOOP:	mvt r1, #HEX_ADRESS //point to HEX port
	
	//loop extract and display
	//read from SW use nested delay loop	


	add r0, #1    //counter increment
	bcc LOOP 	//continue until overflow
	b MAIN


DATA:       .word  0b00111111           // '0'
            .word  0b00000110           // '1'
            .word  0b01011011           // '2'
            .word  0b01001111           // '3'
            .word  0b01100110           // '4'
            .word  0b01101101           // '5'
            .word  0b01111101           // '6'
            .word  0b00000111           // '7'
            .word  0b01111111           // '8'
            .word  0b01100111           // '9'