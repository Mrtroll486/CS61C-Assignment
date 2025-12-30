.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:
    # Error checks
    addi t0, zero, 1
    # check m0's shape
    blt a1, t0, nonsense_m0_shape
    bge a2, t0, check_m1_shape

nonsense_m0_shape:
    addi a1, zero, 72
    j exit2

check_m1_shape:
    blt a4, t0, nonsense_m1_shape
    bge a5, t0, check_shape_align

nonsense_m1_shape:
    addi a1, zero, 73
    j exit2

check_shape_align:
    beq a2, a4, normal_procedure

    # m0's col dose not match with m1's row, matmul cannot be applied
    addi a1, zero, 74
    j exit2

normal_procedure:
    # Prologue
    addi sp, sp, -48
    sw ra, 0(sp) # store the return address
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6

    mv t0, zero # use t0 as sum
    mv s7, zero # use s7 as i index, row
    mv s8, zero # use s8 as j index, col
    # i bound is a1, j bound is a5

outer_loop_start:
	mv s8, zero
    bge s7, s1, outer_loop_end

inner_loop_start:
    bge s8, s5, inner_loop_end

    # for m0, we need get the address of the i-th row, 1st element
    # calc m0's row vec base addr
    mv t3, s7
    slli t3, t3, 2
    mul t3, t3, s2 # offset amount is one or more WHOLE row
    add t3, t3, s0 # m0 row vec base in t3

    # calc m1's col vec base addr
    mv t4, s8
    slli t4, t4, 2
    add t4, t4, s3 # m1 col vec base in t4

    # prepare arg for dot
    mv a0, t3
    mv a1, t4
    mv a2, s2
    li a3, 1
    mv a4, s5
    # call dot
    jal dot

    # store the result in t0
    mv t0, a0

    # note that d is a (a1) * (a5) 2d matrix
    slli t3, s7, 2
    mul t3, t3, s5

    slli t4, s8, 2
    add t3, t3, t4 # get offset in array
    add t3, t3, s6 # get offset in memory layout
    
    sw t0, 0(t3) # store

    addi s8, s8, 1
    j inner_loop_start

inner_loop_end:
    addi s7, s7, 1

    j outer_loop_start
outer_loop_end:

    # Epilogue
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
    addi sp, sp, 48
    ret
