# --- Register Initialization ---
addi t1, zero, 5
addi t2, zero, 3

# --- BEQ (Should NOT skip) ---
# 5 == 3 is False, will not jump, executes sequentially
beq t1, t2, beq_skip
addi x0, zero, 0 # executed, ignored
beq_skip:

# --- BNE (Should skip) ---
# 5 != 3 is True, skips the next line
bne t1, t2, bne_skip
addi s1, zero, 0xEE # this line will be ignored.
bne_skip:

# --- BLT (Should skip) ---
# 3 < 5 is True, skips the next line
blt t2, t1, blt_skip
addi s1, zero, 0xEE # this line will be ignored.
blt_skip:

# --- BGE (Should skip) ---
# 5 >= 3 is True, skips the next line
bge t1, t2, bge_skip
addi s1, zero, 0xEE # this line will be ignored.
bge_skip:

# --- BLTU (Should skip) ---
# 3 < 5 (unsigned) is True, skips the next line
bltu t2, t1, bltu_skip
addi s1, zero, 0xEE # this line will be ignored.
bltu_skip:

# --- BGEU (Should skip) ---
# 5 >= 3 (unsigned) is True, skips the next line
bgeu t1, t2, bgeu_skip
addi s1, zero, 0xEE # this line will be ignored.
bgeu_skip:

# --- JAL ---
# Unconditional jump, ra stores the address of the next line (the ignored one)
jal ra, jal_skip
addi s1, zero, 0xEE # this line will be ignored.
jal_skip:

# --- JALR (2-stage Pipeline Flush Test) ---
# Currently, ra points to the ignored addi instruction above.
# ra = address of jal_skip minus 4.
# To skip the next 0xEE instruction and land safely, we jump to ra + 12.
jalr sp, ra, 12
addi s1, zero, 0xEE # this line will be ignored. (Tests your Flush logic)
jalr_skip:

# Successfully reached the end
addi s1, zero, 0xAA