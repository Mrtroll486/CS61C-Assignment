li ra, 0
li t0, 0
li t1, 10
start:
addi t0, t0, 1
add ra, ra, t0
blt t0, t1, start
mv ra, s0