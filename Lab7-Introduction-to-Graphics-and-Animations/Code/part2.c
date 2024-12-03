/* This files provides address values that exist in the system */

#define SDRAM_BASE            0xC0000000
#define FPGA_ONCHIP_BASE      0xC8000000
#define FPGA_CHAR_BASE        0xC9000000

/* Cyclone V FPGA devices */
#define LEDR_BASE             0xFF200000
#define HEX3_HEX0_BASE        0xFF200020
#define HEX5_HEX4_BASE        0xFF200030
#define SW_BASE               0xFF200040
#define KEY_BASE              0xFF200050
#define TIMER_BASE            0xFF202000
#define PIXEL_BUF_CTRL_BASE   0xFF203020
#define CHAR_BUF_CTRL_BASE    0xFF203030

/* VGA colors */
#define WHITE 0xFFFF
#define YELLOW 0xFFE0
#define RED 0xF800
#define GREEN 0x07E0
#define BLUE 0x001F
#define CYAN 0x07FF
#define MAGENTA 0xF81F
#define GREY 0xC618
#define PINK 0xFC18
#define ORANGE 0xFC00
#define BLACK 0x0000

#define ABS(x) (((x) > 0) ? (x) : -(x))

/* Screen size. */
#define RESOLUTION_X 320
#define RESOLUTION_Y 240

/* Constants for animation */
#define BOX_LEN 2
#define NUM_BOXES 8

#define FALSE 0
#define TRUE 1

#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>

// Begin part1.s for Lab 7

volatile int pixel_buffer_start; // global variable

int main(void)
{
    volatile int * pixel_ctrl_ptr = (int *)0xFF203020;
    /* Read location of the pixel buffer from the pixel buffer controller */
    pixel_buffer_start = *pixel_ctrl_ptr;
	
	clear_screen();
    vertical_animation(79, 239, 239, 239, WHITE); 
}


//clear_screen()
void clear_screen(){
	short int black = BLACK;
	for(int x = 0; x < RESOLUTION_X; x++){
		for(int y = 0; y < RESOLUTION_Y; y++){
		plot_pixel (x, y, black);	
		}
		
	}
}


void vertical_animation(int x0, int y0, int x1, int y1, short int colour){
	bool hit_top = FALSE;	
	
	while(1){
	if(y0 == 0){
		hit_top = TRUE;
	}else if(y0 == RESOLUTION_Y-1){
		hit_top = FALSE;
	}
		
	if(!hit_top){
		y0 --;
		y1 --;
	}else{
		y0 ++;
		y1 ++;
	}
	
	draw_line(x0, y0, x1, y1, colour);
	wait_for_vsynch();
	draw_line(x0, y0, x1, y1, BLACK);
	}
}

//swap function
void swap(int *xp, int *yp)
{
    int temp = *xp;
    *xp = *yp;
    *yp = temp;
}


wait_for_vsynch(){
	volatile int* pixel_ctrl_ptr = 0xFF203020; //pixel controller
	register int status;
	
	*pixel_ctrl_ptr = 1; //start synchronization process
	
	//wait for S to become 0
	status = *(pixel_ctrl_ptr + 3);
	while ((status & 0x01) != 0){
		status = *(pixel_ctrl_ptr + 3);
	}	
}

//draw_line()
void draw_line(int x0, int y0, int x1, int y1, short int color){
	
	bool steep = abs(y1-y0) > abs(x1-x0);
	
	if(steep){
		swap(&x0, &y0);
		swap(&x1, &y1);
	}	
	
	if(x0 > x1){
		swap(&x0, &x1);
		swap(&y0, &y1);
	}
	
	int deltax = x1-x0;
	int deltay = abs(y1-y0);
	int error = -(deltax/2);
	int y = y0;
	int y_step;
	
	if(y0 < y1){
		y_step = 1;
	}else{
		y_step = -1;
	}
	
	for(int x = x0; x < x1; x++){
		if(steep){
			plot_pixel(y, x, color);
		}else{
			plot_pixel(x, y, color);
		}
		
		error = error + deltay;
		
		if(error >= 0){
			y = y + y_step;
			error = error - deltax;
		}
	}
	
}



//plot_pixel()
void plot_pixel(int x, int y, short int line_color)
{
    *(short int *)(pixel_buffer_start + (y << 10) + (x << 1)) = line_color;
}




