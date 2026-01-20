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
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2
    # Variables:
    # s0: file path
    # s1: pointer to row number
    # s2: pointer to col number
    # s3: file descriptor
    # s4: the total num of elements
    # s5: loop index
    # s6: pointer of the result array

    # Get the file descriptor
    mv a1, a0
    li a2, 0

    jal fopen

    bge a0, zero, fopen_success
    # file open error
    li a1, 90
    jal exit2

fopen_success:
    mv s3, a0 # s3 contains the file descriptor

    # read row and col, prepare arguments
    mv a1, s3 # file descriptor
    mv a2, s1 # row
    li a3, 4
    
    jal fread

    li a3, 4
    bne a3, a0, fread_error

    mv a1, s3
    mv a2, s2 # col
    li a3, 4

    jal fread
    
    li a3, 4
    bne a3, a0, fread_error

    lw t1, 0(s1) # get the row number
    lw t2, 0(s2) # get the col number

    mul s4, t1, t2 # total elements
    slli t2, s4, 2 # total size

    # prepare arguments for malloc
    mv a0, t2 # the size parameter

    jal malloc

	li t0, 1
    blt a0, t0, malloc_error # check the result of malloc
    mv s6, a0 # s6 stores the pointer of the result array

    li s5, 0 # set loop index to 0
loop_start:
    bge s5, s4, loop_end

    slli t0, s5, 2 # calc the offset in dest array
    add t0, t0, s6

    #prepare arguments for fread
    mv a1, s3
    mv a2, t0
    li a3, 4

    jal fread

    li a3, 4
    bne a3, a0, fread_error

    addi s5, s5, 1
    j loop_start
loop_end:
	# prepare return value for fclose
    mv a1, s3

    jal fclose

    bne a0, zero, fclose_error

    mv a0, s6 # prepare return value
    
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    addi sp, sp, 32

    ret

fread_error:
    li a1, 91
    jal exit2

fclose_error:
    li a1, 92
    jal exit2

malloc_error:
    li a1, 88
    jal exit2