li ra, 0
li t0, 0
li t1, 11
start:
bge t0, t1, end
addi t0, t0, 1
add ra, ra, t0
j start
end:
mv ra, s0