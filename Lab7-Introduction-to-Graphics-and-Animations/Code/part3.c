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

// Begin part3.c code for Lab 7


volatile int pixel_buffer_start; // global variable

int main(void)
{
    volatile int * pixel_ctrl_ptr = (int *)0xFF203020;
    // declare other variables
	int i;
	int N = NUM_BOXES;
	int prev_x_box[N], prev_y_box[N], x_box[N], y_box[N], dx_box[N], dy_box[N];
	short int color[10] = {WHITE, YELLOW, RED, GREEN, BLUE, CYAN, MAGENTA, GREY, PINK, ORANGE};
	short int color_box[N];
	
	// initialize location and direction of rectangles
	for(i = 0; i < NUM_BOXES; i++){
		x_box[i] = (rand() % (RESOLUTION_Y - 2 * BOX_LEN)) + BOX_LEN; //random x position
		y_box[i] = (rand() % (RESOLUTION_Y - 2 * BOX_LEN)) + BOX_LEN; //random y position
		dx_box[i] = ((rand() % 2) * 2) - 1; //random 1 or -1
		dy_box[i] = ((rand() % 2) * 2) - 1; //random 1 or -1
		color_box[i] = color[rand() % 10]; //random out of 10 colours
		//initialize previous values to 0
		prev_x_box[i] = 0; 
		prev_y_box[i] = 0;
	}
	
    /* set front pixel buffer to start of FPGA On-chip memory */
    *(pixel_ctrl_ptr + 1) = 0xC8000000; // first store the address in the 
                                        // back buffer
    /* now, swap the front/back buffers, to set the front buffer location */
    wait_for_vsync();
    /* initialize a pointer to the pixel buffer, used by drawing functions */
    pixel_buffer_start = *pixel_ctrl_ptr;
    clear_screen(); // pixel_buffer_start points to the pixel buffer
    /* set back pixel buffer to start of SDRAM memory */
    *(pixel_ctrl_ptr + 1) = 0xC0000000;
    pixel_buffer_start = *(pixel_ctrl_ptr + 1); // we draw on the back buffer
	
    while (1)
    {
        /* Erase any boxes and lines that were drawn in the last iteration */
		*(pixel_ctrl_ptr + 1) = 0xC8000000;
		for(i = 0; i < NUM_BOXES; i++){
			draw_box(prev_x_box[i], prev_y_box[i], prev_x_box[i] + BOX_LEN, prev_y_box[i] + BOX_LEN, BLACK);
			draw_line(prev_x_box[i], prev_y_box[i], prev_x_box[(i + 1) % NUM_BOXES], prev_y_box[(i + 1) % NUM_BOXES], BLACK);
		}
		
        // code for drawing the boxes and lines (not shown)
		for(i = 0; i < NUM_BOXES; i++){
			//Draw new box and line
			draw_box(x_box[i], y_box[i], x_box[i] + BOX_LEN, y_box[i] + BOX_LEN, color_box[i]);
			draw_line(x_box[i], y_box[i], x_box[(i + 1) % NUM_BOXES], y_box[(i + 1) % NUM_BOXES], color_box[i]);
		}
		
		//store previous values of x and y
		for(int i = 0; i < NUM_BOXES; i++){
			prev_x_box[i] = x_box[i];
			prev_y_box[i] = y_box[i];
		}
		
        // code for updating the locations of boxes 
		for(i = 0; i < NUM_BOXES; i++){
			if(x_box[i]+dx_box[i] == 0 || x_box[i]+dx_box[i] == RESOLUTION_X){
				dx_box[i] = -dx_box[i];
			}
			if(y_box[i]+dy_box[i] == 0 || y_box[i]+dy_box[i] == RESOLUTION_Y){
				dy_box[i] = -dy_box[i];
			}
			x_box[i] = x_box[i] + dx_box[i];
			y_box[i] = y_box[i] + dy_box[i];
		}
		
        wait_for_vsync(); // swap front and back buffers on VGA vertical sync
        pixel_buffer_start = *(pixel_ctrl_ptr + 1); // new back buffer
    }
}

// code for subroutines 
wait_for_vsync(){
	volatile int* pixel_ctrl_ptr = 0xFF203020; //pixel controller
	register int status;
	
	*pixel_ctrl_ptr = 1; //start synchronization process
	
	//wait for S to become 0
	status = *(pixel_ctrl_ptr + 3);
	while ((status & 0x01) != 0){
		status = *(pixel_ctrl_ptr + 3);
	}	
}

//clear_screen()
void clear_screen(){
	short int colour = BLACK;
	for(int x = 0; x < RESOLUTION_X; x++){
		for(int y = 0; y < RESOLUTION_Y; y++){
		plot_pixel (x, y, colour);	
		}	
	}
}

//plot_pixel()
void plot_pixel(int x, int y, short int line_color)
{
    *(short int *)(pixel_buffer_start + (y << 10) + (x << 1)) = line_color;
}

//swap function
void swap(int *xp, int *yp)
{
    int temp = *xp;
    *xp = *yp;
    *yp = temp;
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

//draw_box()
void draw_box(int x0, int y0, int x1, int y1, short int color){
	for(int x = x0; x < x1; x++){
		for(int y = y0; y < y1; y++){
		plot_pixel(x, y, color);
		}
	}
}

