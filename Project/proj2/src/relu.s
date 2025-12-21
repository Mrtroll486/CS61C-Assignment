.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue

    addi t1, zero, 1
    bge a1, t1, normal_procedure
    # Exception handling
    addi a1, zero, 78
    j exit2

normal_procedure:
    addi t0, zero, 0

loop_start:
    bge t0, a1, loop_end
    slli t1, t0, 2 # calc the offset
    add t1, a0, t1 # get the address of cur element
    lw t2, 0(t1)

    bge t2, zero, loop_continue # if element >= 0, jump
    # element < 0
    addi t2, zero, 0
    # here we loop through
loop_continue:

    sw t2, 0(t1)
    addi t0, t0, 1
    j loop_start

loop_end:


    # Epilogue

	ret
