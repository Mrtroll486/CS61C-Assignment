addi t1, zero, 1
not_skip:
beq t1, zero, not_skip
addi t0, zero, 114
sub t1, t1, t1
beq t1, zero, skip
addi t0, zero, 514
skip:
addi t0, zero, 1919
