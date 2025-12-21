.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:
    # Prologue

    addi t1, zero, 1
    bge a1, t1, normal_procedure
    # Exception handling
    addi a1, zero, 77
    j exit2

normal_procedure:
    addi t0, zero, 1 # index - t0 (start from 1, avoid redudent computatuion)
    addi t1, zero, 0 # max_val_idx - t1
    lw t2, 0(a0) # max_val - t2 (init value use the 1st element in array)

loop_start:
    bge t0, a1, loop_end

    slli t3, t0, 2 # get the offset
    addi t0, t0, 1 # increase the idx
    add t3, t3, a0 # get the address

    lw t3, 0(t3)
    blt t2, t3, loop_continue # the FIRST index of the largest element
    j loop_start

loop_continue:
    # update max value and index
    mv t2, t3
    addi t1, t0, -1 # -1 because of the forwarded addi
    j loop_start

loop_end:
    mv a0, t1

    # Epilogue

    ret
