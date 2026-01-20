.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:
    # Prologue
    addi sp, sp, -32
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)

    # Variables:
    # s0: filename / file descriptor
    # s1: pointer to the start of matrix in memory
    # s2: row number
    # s3: col number
    # s4: total element number
    # s5: loop index
    mv s0, a0   # s0 initialy stores the file name string
    mv s1, a1
    mv s2, a2
    mv s3, a3
    li s4, 0
    li s5, 0

    # try to open file
    mv a1, s0
    li a2, 1    # 1 means write the file

    jal fopen

    blt a0, zero, fopen_error
    mv s0, a0   # s0 stores the file descriptor from now on

    # write col and row info
    # create a temp buffer for fwrite to write
    addi sp, sp, -8
    sw s2, 0(sp)
    sw s3, 4(sp)
    
    mv a1, s0
    mv a2, sp
    li a3, 2
    li a4, 4

    jal fwrite

    li t0, 2
    bne t0, a0, fwrite_error

    addi sp, sp, 8

    mul s4, s3, s2  # total num of elements

    # write all elements into file
    mv a1, s0
    mv a2, s1
    mv a3, s4
    mv a4, 4

    jal fwrite

    mv t0, s4
    bne t0, a0, fwrite_error

    # file operation done, close the file
    mv a1, s0

    jal fclose

    blt a0, zero, fclose_error


    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)

    ret

fopen_error:
    li a1, 93
    jal exit2

fwrite_error:
    li a1, 94
    jal exit2

fclose_error:
    li a1, 95
    jal exit2
