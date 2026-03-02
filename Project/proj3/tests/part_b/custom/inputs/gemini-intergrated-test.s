# --- Register Initialization ---
# Setting a high base address to avoid StoreError (Text Segment Immutable)
# 0x10000000 is typically the start of the Data Segment
lui t0, 0x10000       # t0 = 0x10000000
addi t1, zero, 5      # t1 = 5
addi t2, zero, 3      # t2 = 3

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

# --- Conditional Branching (SB-type) ---

# BEQ (Should NOT skip): 5 == 3 is False
beq t1, t2, beq_not_taken
addi x0, zero, 0      # executed, ignored
beq_not_taken:

# BEQ (Should skip): 5 == 5 is True
beq t1, t1, beq_taken
addi s1, zero, 0xEE   # this line will be ignored
beq_taken:

# BNE (Should skip): 5 != 3 is True
bne t1, t2, bne_taken
addi s1, zero, 0xEE   # this line will be ignored
bne_taken:

# BNE (Should NOT skip): 5 != 5 is False
bne t1, t1, bne_not_taken
addi x0, zero, 0      # executed, ignored
bne_not_taken:

# BLT (Should skip): 3 < 5 is True
blt t2, t1, blt_taken
addi s1, zero, 0xEE   # this line will be ignored
blt_taken:

# BLT (Should NOT skip): 5 < 3 is False
blt t1, t2, blt_not_taken
addi x0, zero, 0      # executed, ignored
blt_not_taken:

# BGE (Should skip): 5 >= 3 is True
bge t1, t2, bge_taken
addi s1, zero, 0xEE   # this line will be ignored
bge_taken:

# BGE (Should NOT skip): 3 >= 5 is False
bge t2, t1, bge_not_taken
addi x0, zero, 0      # executed, ignored
bge_not_taken:

# BLTU (Should skip): 3 < 5 (unsigned) is True
bltu t2, t1, bltu_taken
addi s1, zero, 0xEE   # this line will be ignored
bltu_taken:

# BLTU (Should NOT skip): 5 < 3 (unsigned) is False
bltu t1, t2, bltu_not_taken
addi x0, zero, 0      # executed, ignored
bltu_not_taken:

# BGEU (Should skip): 5 >= 3 (unsigned) is True
bgeu t1, t2, bgeu_taken
addi s1, zero, 0xEE   # this line will be ignored
bgeu_taken:

# BGEU (Should NOT skip): 3 >= 5 (unsigned) is False
bgeu t2, t1, bgeu_not_taken
addi x0, zero, 0      # executed, ignored
bgeu_not_taken:

# --- Unconditional Jumps (UJ/I-type) ---
# JAL: Unconditional jump, ra stores the address of the next line (the ignored one)
jal ra, jal_skip
addi s1, zero, 0xEE   # this line will be ignored
jal_skip:

# JALR (2-stage Pipeline Flush Test)
# Currently, ra points to the ignored addi instruction above.
# ra = address of jal_skip minus 4.
# To skip the next 0xEE instruction and land safely, we jump to ra + 12.
jalr sp, ra, 12
addi s1, zero, 0xEE   # this line will be ignored (Tests your Flush logic)
jalr_skip:

# Successfully reached the end of all tests
addi s1, zero, 0xAA   # Expected final value for s1: 0x000000AA