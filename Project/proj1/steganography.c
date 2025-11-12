/************************************************************************
**
** NAME:        steganography.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**				Justin Yokota - Starter Code
**				YOUR NAME HERE
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This should not affect Image, and should allocate space for a new Color.
Color *evaluateOnePixel(Image *image, int row, int col)
{
	//YOUR CODE HERE
	uint8_t blue_channel_lsb;
	blue_channel_lsb = image->image[row][col].B & 1;
	Color *decoded_pixel = (Color*)malloc(sizeof(Color));
	if (blue_channel_lsb) { // the lsb of Blue channel is 1, then we return a white pixel
		if (decoded_pixel) {
			decoded_pixel->R = 255;
			decoded_pixel->G = 255;
			decoded_pixel->B = 255;
		}
	} else {
		if (decoded_pixel) {
			decoded_pixel->R = 0;
			decoded_pixel->G = 0;
			decoded_pixel->B = 0;
		}
	}

	return decoded_pixel;
}

//Given an image, creates a new image extracting the LSB of the B channel.
Image *steganography(Image *image)
{
	//YOUR CODE HERE
	Image *decoded_img = (Image*) malloc(sizeof(Image));
	if (decoded_img) {
		// constructing a new image obj
		decoded_img->cols = image->cols;
		decoded_img->rows = image->rows;
		decoded_img->image = (Color**) malloc(sizeof(Color*) * decoded_img->rows);
		if(decoded_img->image) {
			for(int i = 0; i < decoded_img->rows; i++) {
				decoded_img->image[i] = (Color*) malloc(sizeof(Color) * decoded_img->cols);
				if (!decoded_img->image[i]) {		// catch malloc failing cases.
					return NULL;
				}
			}
		} else {
			return NULL;
		}

		for(int i = 0; i < decoded_img->rows; i++) {
			for(int j = 0; j < decoded_img->cols; j++) {
				Color *decoded_pixel = evaluateOnePixel(image, i,  j);
				decoded_img->image[i][j] = *decoded_pixel;
				free(decoded_pixel);
			}
		}
	}

	return decoded_img;
}

/*
Loads a file of ppm P3 format from a file, and prints to stdout (e.g. with printf) a new image, 
where each pixel is black if the LSB of the B channel is 0, 
and white if the LSB of the B channel is 1.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a file of ppm P3 format (not necessarily with .ppm file extension).
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!
*/
int main(int argc, char **argv)
{
	//YOUR CODE HERE
	if (argc != 2) {
		return -1;
	}
	Image *raw_img = readData(argv[1]);
	if (!raw_img) {
		return -1;
	}
	Image *decoded_img = steganography(raw_img);
	if (!decoded_img) {
		return -1;
	}
	writeData(decoded_img);

	freeImage(raw_img);
	freeImage(decoded_img);

	return 0;
}
