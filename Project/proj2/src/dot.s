.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    # Prologue

    addi t1, zero, 1

    # checking exception conditions
    bge zero, a3, stride_non_positive
    bge zero, a4, stride_non_positive
    bge a2, t1, normal_procedure

    # length <= 0
    addi a1, zero, 75
    j exit2

stride_non_positive:
    # stride <= 0
    addi a1, zero, 76
    j exit2

normal_procedure:
    add t0, zero, zero # cur length
    add t1, zero, zero # sum

    slli a3, a3, 2 # calc the offset
    slli a4, a4, 2

loop_start:
    bge t0, a2, loop_end
    lw t2, 0(a0)
    lw t3, 0(a1)
    # prepare values for next loop
    addi t0, t0, 1
    add a0, a0, a3
    add a1, a1, a4

    # do math
    mul t2, t2, t3
    add t1, t1, t2

    j loop_start

loop_end:
    mv a0, t1

    # Epilogue
    
    ret
