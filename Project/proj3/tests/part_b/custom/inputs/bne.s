addi t1, zero, 0
not_skip:			# there should be no loops
bne t1, zero, not_skip
addi t0, zero, 114
li t1, 1
bne t1, zero, skip
addi t0, zero, 514	# this line will be ignored.
skip:
addi t0, zero, 1919
