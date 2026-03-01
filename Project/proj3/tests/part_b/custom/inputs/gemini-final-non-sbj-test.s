# --- Register Initialization ---
# Setting a high base address to avoid Venus StoreError (Text Segment Immutable)
# 0x10000000 is typically the start of the Data Segment
lui t0, 0x10000       # t0 = 0x10000000
addi t1, x0, 5        # t1 = 5
addi t2, x0, 3        # t2 = 3

# --- Arithmetic & Logical Operations (R-type) ---
add ra, t1, t2        # ra = 5 + 3 = 8
sub sp, t1, t2        # sp = 5 - 3 = 2
mul s0, t1, t2        # s0 = 15
mulh s1, t1, t2       # s1 = 0
sll a0, t1, t2        # a0 = 40
slt ra, t1, t2        # ra = 0
xor sp, t1, t2        # sp = 6
srl s0, t1, t2        # s0 = 0
sra s1, t1, t2        # s1 = 0
or  a0, t1, t2        # a0 = 7
and ra, t1, t2        # ra = 1

# --- Immediate Operations (I-type) ---
addi sp, t1, 10       # sp = 15
slli s0, t1, 2        # s0 = 20
slti s1, t1, 4        # s1 = 0
xori a0, t1, 1        # a0 = 4
srli ra, t1, 1        # ra = 2
srai sp, t1, 1        # sp = 2
ori  s0, t1, 8        # s0 = 13
andi s1, t1, 4        # s1 = 4

# --- Memory Access (Store & Load) ---
# Testing data flow at Data Segment address 0x10000000
sw   t1, 0(t0)        # Mem[0x10000000] = 5
lw   ra, 0(t0)        # ra = 5
sh   t2, 4(t0)        # Mem[0x10000004] = 3
lh   sp, 4(t0)        # sp = 3
sb   t1, 8(t0)        # Mem[0x10000008] = 5
lb   s0, 8(t0)        # s0 = 5

# --- Upper Immediate Instructions ---
lui  s1, 1            # s1 = 0x00001000
auipc a0, 2           # a0 = PC + 0x00002000
