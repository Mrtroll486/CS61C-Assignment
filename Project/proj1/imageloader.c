/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include <sys/types.h>
#include "imageloader.h"

//Opens a .ppm P3 image file, and constructs an Image object. 
//You may find the function fscanf useful.
//Make sure that you close the file with fclose before returning.
Image *readData(char *filename) 
{
	//YOUR CODE HERE
	FILE *fp = fopen(filename, "r");
	Image* img = (Image*) malloc(sizeof(Image));
	char buf[20];
	fscanf(fp, "%s", buf);
	if(strcmp(buf, "P3")) {
		// if the format of file is not P3 return null;
		return NULL;
	}
	// read in the size of the pic
	fscanf(fp, "%" SCNu32 " %" SCNu32, &img->cols, &img->rows);
	uint32_t max_depth;
	fscanf(fp, "%" SCNu32, &max_depth);

	img->image = (Color**) malloc(sizeof(Color*) * img->rows);
	for (int i = 0; i < img->rows; i++) {
		img->image[i] = (Color*) malloc(sizeof(Color) * img->cols);
	}

	// todo: if something went wrong, check here first
	for (int i = 0; i < img->rows; i++) {
		for (int j = 0; j < img->cols; j++) {
			fscanf(fp, "%" SCNu8, &img->image[i][j].R);
			fscanf(fp, "%" SCNu8, &img->image[i][j].G);
			fscanf(fp, "%" SCNu8, &img->image[i][j].B);
		}
	}

	fclose(fp);
	return img;
}

//Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{
	//YOUR CODE HERE
	printf("P3\n");
	printf("%" SCNu32 " %" SCNu32 "\n", image->cols, image->rows);
	printf("255\n");

	for(int i = 0; i < image->rows; i++) {
		for (int j = 0; j < image->cols; j++) {
			printf("%3" PRIu8 " %3" PRIu8 " %3" PRIu8, image->image[i][j].R, image->image[i][j].G, image->image[i][j].B);

			if (j != image->cols - 1) {
				printf("   ");
			} else {
				printf("\n");
			}
		}
	}

	return;
}

//Frees an image
void freeImage(Image *image)
{
	for(int i = 0; i < image->rows; i++) {
		free(image->image[i]);
	}
	free(image->image);
	free(image);

	return;
}
