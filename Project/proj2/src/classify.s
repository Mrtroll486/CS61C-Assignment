.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    # check the number of arguments
    li t0, 5
    bne t0, a0, invalid_arg_num

	# =====================================
    # LOAD MATRICES
    # =====================================
    
    # Prologue
    addi sp, sp, -48
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)

    # Local Variables:
    # s0: argc
    # s1: argv
    # s2: flag of printing reuslt
    # s3: pointer of m0
    # s4: pointer of m1
    # s5: pointer of input matrix
    # s6: pointer of row array
    # s7: pointer of col array
    # s8: the pointer of temp array
    # s9: the row of temp array
    # s10: the col of temp array
    # the arrangement in array is: (m0, m1, input)
    
    mv s0, a0
    mv s1, a1
    mv s2, a2

    # malloc space for 2 arrays
    li a0, 12
    jal malloc

    li t0, 1
    blt a0, t0, malloc_error
    mv s6, a0

    li a0, 12
    jal malloc 

    li t0, 1
    blt a0, t0, malloc_error
    mv s7, a0

    # Load pretrained m0
    lw a0, 4(s1)  # the index of M0_PATH is 1
    addi a1, s6, 0
    addi a2, s7, 0

    jal read_matrix

    mv s3, a0

    # Load pretrained m1
    lw a0, 8(s1)  # the index of M1_PATH is 2
    addi a1, s6, 4
    addi a2, s7, 4

    jal read_matrix

    mv s4, a0

    # Load input matrix
    lw a0, 12(s1)  # the index of INPUT_PATH is 3
    addi a1, s6, 8
    addi a2, s7, 8

    jal read_matrix

    mv s5, a0

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    lw s9, 0(s6)   # row of m0, also row of temp mat
    lw s10, 8(s7)    # col of input, also col of temp mat

	# malloc space for temp mat
    mul a0, s9, s10
    slli a0, a0, 2

    jal malloc

    li t0, 1
    blt a0, t0, malloc_error

    mv s8, a0

    # prepare argments for matmul
    mv a0, s3
    lw a1, 0(s6)
    lw a2, 0(s7)
    mv a3, s5
    lw a4, 8(s6)
    lw a5, 8(s7)
    mv a6, s8

    jal matmul

    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    mv a0, s8
    mul a1, s9, s10

    jal relu

    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    # first free m0's space
    mv a0, s3
    jal free

    # malloc new space for the final result
    lw t0, 4(s6)    # the row of m1
    mul a0, t0, s10
    slli a0, a0, 2  # dont forget to multiply the size of one element

    jal malloc 

    li t0, 1
    blt a0, t0, malloc_error
    mv s3, a0

    # prepare args for matmul
    mv a0, s4
    lw a1, 4(s6)
    lw a2, 4(s7)
    mv a3, s8
    mv a4, s9
    mv a5, s10
    mv a6, s3

    jal matmul
    # now s3 holds the pointer to the final array
    lw s9, 4(s6)    # update the row number of final array
    # s10, the col number of final array stays unchanged

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix, prepare arguments for write_matrix
    lw a0, 16(s1)
    mv a1, s3
    mv a2, s9
    mv a3, s10

    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s3
    mul a1, s9, s10

    jal argmax

    mv s10, a0  # use s10 to hold the final classification result

    # Print classification
    bne s2, zero, epilogue

    # prepare arguments for print_int
    mv a1, s10

    jal print_int

    # Print newline afterwards for clarity
    li a1, '\n'
    jal print_char

epilogue:
    # free all malloced spaces
    mv a0, s3
    jal free

    mv a0, s4
    jal free

    mv a0, s5
    jal free

    mv a0, s6
    jal free

    mv a0, s7
    jal free

    mv a0, s8
    jal free

    # restore sp and all s-registers
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    addi sp, sp, 48

    ret

invalid_arg_num:
    li a1, 89
    jal exit2

malloc_error:
    li a1, 88
    jal exit2
