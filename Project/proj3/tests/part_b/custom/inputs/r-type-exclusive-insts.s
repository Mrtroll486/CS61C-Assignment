addi t3, zero, 3
addi t1, zero, 5

sub t0, t1, t3
mul t0, t1, t3

li t1, 0x87654321
li t3, 0x12345678

mulh t0, t1, t3
mulhu t0, t1, t3