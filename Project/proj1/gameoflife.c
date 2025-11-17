/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**              Mr_troll863
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

// These are used to manage offsets when checking boundaries.
int offset_row[] = {-1,  1,  0,  0, -1, -1,  1,  1};
int offset_col[] = { 0,  0, -1,  1, -1,  1, -1,  1};

// Determines the color channel by the iteration count
uint8_t colorSelector(Color pixel, int iter) {
	int color = iter / 8;
	uint8_t color_val;
	switch (color) {
		case 0: {
			color_val = pixel.R;
			break;
		}
		case 1: {
			color_val = pixel.G;
			break;
		}
		case 2: {
			color_val = pixel.B;
			break;
		}
	}
	return color_val;
}

//Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
//Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
//and the left column as adjacent to the right column.
Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule)
{
	//YOUR CODE HERE
	Color *new_pixel = (Color*)malloc(sizeof(Color));
	uint32_t img_row = image->rows, img_col = image->cols;

	uint8_t new_channel_val = 0;
	for (int i = 0; i < 24; i++) {
		// there are 24 channels, 3 colors, so each color uses 8 channels
		int bit = i % 8;
		uint8_t target_bit = colorSelector(image->image[row][col], i) >> bit & 1;
		uint32_t target_rule = rule >> (target_bit ? 9 : 0);
		int adj_live_count = 0;
		for (int j = 0; j < 8; j++) {
			uint8_t adj_bit = colorSelector(image->image[(row + img_row + offset_row[j]) % img_row][(col + img_col + offset_col[j]) % img_col], i) >> bit & 1;
			if (adj_bit) {
				adj_live_count++;
			}
		}
		new_channel_val = (new_channel_val << 1) | (target_rule >> adj_live_count & 1);
		if (i == 7) {
			new_pixel->R = new_channel_val;
			new_channel_val = 0;
		} else if (i == 15) {
			new_pixel->G = new_channel_val;
			new_channel_val = 0;
		} else if (i ==23) {
			new_pixel->B = new_channel_val;
			new_channel_val = 0;
		}
	}

	return new_pixel;
}

//The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
//You should be able to copy most of this from steganography.c
Image *life(Image *image, uint32_t rule)
{
	//YOUR CODE HERE
	Image *result_img = (Image*)malloc(sizeof(Image));
	result_img->cols = image->cols, result_img->rows = image->rows;

	Color **img = (Color**)malloc(sizeof(Color*) * result_img->rows);
	for(int i = 0; i < result_img->rows; i++) {
		img[i] = (Color*)malloc(sizeof(Color) * result_img->cols);
	}

	int row = image->rows, col = image->cols;
	for(int i = 0; i < row; i++) {
		for(int j = 0; j < col; j++) {
			Color *result = evaluateOneCell(image, i,  j, rule);
			img[i][j] = *result;
			free(result);
		}
	}

	result_img->image = img;

	return result_img;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
int main(int argc, char **argv)
{
	//YOUR CODE HERE
	if (argc != 3) {
		printf("	usage: ./gameOfLife filename rule\n");
		printf("	filename is an ASCII PPM file (type P3) with maximum value 255\n");
		printf("	rule is a hex number beginning with 0x; Life is 0x1808\n");
		return -1;
	}

	uint32_t rule = strtol(argv[2], NULL, 0);
	// The rule of Game of Life is a 18bit number.
	Image *raw_img = readData(argv[1]);

	if (!raw_img) {
		return -1;
	}

	Image *result_img = life(raw_img, rule);

	writeData(result_img);

	freeImage(result_img);
	freeImage(raw_img);

	return 0;
}
