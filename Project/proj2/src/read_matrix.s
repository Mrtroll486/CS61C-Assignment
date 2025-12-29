.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:
    # Prologue
    addi sp, sp, -32
    sw ra, 0(sp)

    # Get the file descriptor
	sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)

    li a2, 0

    jal fopen

    bge a0, zero, fopen_success
    # file open error
    li a1, 90
    jal exit2

fopen_success:
    mv t0, a0 # t0 contains the file descriptor
	lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)

    # read row and col
	sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    sw t0, 16(sp)
    
    mv a1, t0 # file descriptor
    lw a2, 8(sp) # row
    li a3, 4
    
    jal fread

    li a3, 4
    bne a3, a0, fread_error

    mv a1, t0
    lw a2, 12(sp) # col
    li a3, 4

    jal fread
    
    li a3, 4
    bne a3, a0, fread_error
    
	lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    lw t0, 16(sp)

    lw t1, 0(a1) # get the row number
    lw t2, 0(a2) # get the col number

    mul t1, t1, t2 # total elements
    slli t2, t1, 2 # total size

    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    sw t0, 16(sp)
    sw t1, 20(sp)
    sw t2, 24(sp)

    mv a0, t2 # the size parameter

    jal malloc

    mv t3, a0 # t3 stores the pointer of the result array

    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    lw t0, 16(sp)
    lw t1, 20(sp)
    lw t2, 24(sp)

    # local vars:
    # t0: file descriptor
    # t1: the total num of elements
    # t2: loop index
    # t3: pointer of the result array

    li t2, 0

loop_start:
    bge t2, t1, loop_end



    addi t2, t2, 1
    j loop_start
loop_end:

    # Epilogue
    lw ra, 0(sp)
    addi sp, sp, 32

    ret

fread_error:
    li a1, 91
    jal exit2

fclose_error:
    li a1, 92
    jal exit2