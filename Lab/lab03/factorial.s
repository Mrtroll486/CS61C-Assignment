.globl factorial

.data
n: .word 8

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    # a0 stores the value n
    addi t0, zero, 1 # t0 stores the final answer
    addi t1, zero, 1 # t1 stores the index

    outer_loop:
        bge t1, a0, outer_end
        addi t1, t1, 1
        addi t2, zero, 1 # set t2 to 1
        addi t3, t0, 0 # record the initial value of t0
        inner_loop:
            bge t2, t1, inner_end
            addi t2, t2, 1
            add t0, t0, t3
            j inner_loop
        inner_end:
        j outer_loop
    outer_end:
    addi a0, t0, 0 # prepare the return value
    jr ra # return
