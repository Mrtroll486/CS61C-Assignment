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
    addi a0, zero, 72
    jr exit2

check_m1_shape:
    blt a4, t0, nonsense_m1_shape
    bge a5, t0, check_shape_align

nonsense_m1_shape:
    addi a0, zero, 73
    jr exit2

check_shape_align:
    beq a2, a4, normal_procedure

    # m0's col dose not match with m1's row, matmul cannot be applied
    addi a0, zero, 74
    jr exit2

normal_procedure:
    # Prologue
    addi sp, sp, -24
    sw ra, 0(sp) # store the return address

    mv t0, zero # use t0 as sum
    mv t1, zero # use t1 as i index
    mv t2, zero # use t2 as j index
    # i bound is a1, j bound is a5

outer_loop_start:
	mv t2, zero
    bge t1, a1, outer_loop_end

inner_loop_start:
    bge t2, a5, inner_loop_end

    # calc m0's row vec base addr
    mv t3, t1
    slli t3, t3, 2
    add t3, t3, a0 # m0 row vec base in t3

    # calc m1's col vec base addr
    mv t4, t2
    slli t4, t4, 2
    add t4, t4, a3 # m1 col vec base in t4

    # prepare arg for dot
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    sw a3, 16(sp)
    sw a4, 20(sp)
    mv a0, t3
    mv a1, t4
    # a2 stays same
    addi a3, zero, 1
    mv a4, a5
    # call dot
    jr dot

    addi t2, t2, 1
    j inner_loop_start

inner_loop_end:
    addi t1, t1, 1


    j outer_loop_start
outer_loop_end:


    # Epilogue
    lw ra, 0(sp)
    # todo: remember to restore sp
    
    ret
