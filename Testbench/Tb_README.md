# RISC-V Single-Cycle Processor – Testbench

## Overview

This testbench verifies the functionality of the **32-bit RV32I Single-Cycle RISC-V Processor** implemented in this project. It provides clock and reset generation, executes a verification program stored in `program.hex`, monitors the processor's execution, generates waveform files, and performs self-checking to validate the correctness of the processor.

The objective of this testbench is to ensure that every implemented instruction executes correctly before moving to the pipelined processor.

---

# Features

The testbench provides the following functionality:

* Automatic clock generation
* Processor reset sequence
* Instruction execution monitoring
* Program Counter (PC) tracking
* Current instruction display
* Self-checking verification
* Register verification
* Memory verification
* Branch and jump verification
* Waveform generation for debugging
* Automatic simulation termination

---

# Directory Structure

```text
Testbench/
│
├── tb_riscv_core.v      // Top-level verification testbench
├── program.hex          // Program loaded into instruction memory
└── README.md            // Testbench documentation
```

---

# Testbench Operation

The verification process consists of the following stages:

1. Generate the system clock.
2. Apply processor reset.
3. Release reset after initialization.
4. Execute instructions stored in `program.hex`.
5. Display the processor state every clock cycle.
6. Verify register values.
7. Verify memory contents.
8. Generate the VCD waveform.
9. Print the verification report.
10. End the simulation.

---

# Clock Generation

The processor operates using a **10 ns clock period**.

```verilog
always #5 clk = ~clk;
```

Clock Frequency:

```
100 MHz
```

---

# Reset Sequence

At the beginning of simulation, reset is asserted to initialize the processor.

```
Time = 0 ns

clk = 0
rst = 1
```

After initialization,

```
rst = 0
```

and normal program execution begins.

---

# Waveform Generation

The testbench generates a waveform file for debugging.

```verilog
$dumpfile("Waveforms/tb_riscv_core.vcd");
$dumpvars(0, tb_riscv_core);
```

The waveform can be viewed using:

* GTKWave
* VaporView (VS Code)

---

# Program Under Test

The verification program stored in `program.hex` exercises all implemented instructions of the processor.

The program verifies:

* Arithmetic Instructions
* Logical Instructions
* Shift Instructions
* Comparison Instructions
* Memory Instructions
* Branch Instructions
* Jump Instructions
* Upper Immediate Instructions

---

# Instruction Sequence

| Address    | Machine Code | Assembly         | Purpose        |
| ---------- | ------------ | ---------------- | -------------- |
| 0x00000000 | 00A00093     | addi x1,x0,10    | Load immediate |
| 0x00000004 | 01400113     | addi x2,x0,20    | Load immediate |
| 0x00000008 | 002081B3     | add x3,x1,x2     | ADD            |
| 0x0000000C | 40110233     | sub x4,x2,x1     | SUB            |
| 0x00000010 | 0020F2B3     | and x5,x1,x2     | AND            |
| 0x00000014 | 0020E333     | or x6,x1,x2      | OR             |
| 0x00000018 | 0020C3B3     | xor x7,x1,x2     | XOR            |
| 0x0000001C | 0020A433     | slt x8,x1,x2     | SLT            |
| 0x00000020 | 00100493     | addi x9,x0,1     | Shift amount   |
| 0x00000024 | 00149533     | sll x10,x9,x1    | SLL            |
| 0x00000028 | 009555B3     | srl x11,x10,x9   | SRL            |
| 0x0000002C | 00302023     | sw x3,0(x0)      | Store          |
| 0x00000030 | 00402223     | sw x4,4(x0)      | Store          |
| 0x00000034 | 00002603     | lw x12,0(x0)     | Load           |
| 0x00000038 | 00402683     | lw x13,4(x0)     | Load           |
| 0x0000003C | 00360463     | beq x12,x3,label | Branch         |
| 0x00000044 | 008007EF     | jal x15,label    | Jump           |
| 0x0000004C | 123458B7     | lui x17,0x12345  | LUI            |
| 0x00000050 | 00000917     | auipc x18,0      | AUIPC          |
| 0x00000054 | 0000006F     | jal x0,0         | Infinite Loop  |

---

# Simulation Monitor

During simulation, the testbench displays:

* Simulation Time
* Program Counter (PC)
* Current Instruction

Example:

```text
----------------------------------------------------
Time = 125000
PC   = 00000028
INST = 009555B3
----------------------------------------------------
```

This allows the execution flow to be monitored cycle-by-cycle.

---

# Self-Checking Verification

At the end of simulation, the testbench automatically verifies the processor state.

The following checks are performed:

* ADDI
* ADD
* SUB
* AND
* OR
* XOR
* SLT
* SLL
* SRL
* SW
* LW
* BEQ
* JAL
* LUI
* AUIPC

Example output:

```text
PASS : ADDI x1
PASS : ADDI x2
PASS : ADD
PASS : SUB
PASS : AND
PASS : OR
PASS : XOR
PASS : SLT
PASS : SLL
PASS : SRL
PASS : LW 0
PASS : LW 4
PASS : BEQ
PASS : JAL
PASS : JAL Skip
PASS : LUI
PASS : AUIPC
PASS : SW MEM[0]
PASS : SW MEM[4]
```

---

# Memory Verification

The following memory locations are checked:

| Address   | Expected Value |
| --------- | -------------: |
| Memory[0] |             30 |
| Memory[4] |             10 |

---

# Register Verification

The testbench verifies that destination registers contain the expected values after execution.

Examples include:

| Register | Expected Value |
| -------- | -------------: |
| x1       |             10 |
| x2       |             20 |
| x3       |             30 |
| x4       |             10 |
| x5       |              0 |
| x6       |             30 |
| x7       |             30 |
| x8       |              1 |

---

# Simulation Commands

Compile:

```bash
iverilog -g2012 -o sim.out -s tb_riscv_core -f Build/filelist.f
```

Run:

```bash
vvp sim.out
```

Open Waveform:

```bash
gtkwave Waveforms/tb_riscv_core.vcd
```

or

```bash
code Waveforms/tb_riscv_core.vcd
```

---

# Expected Simulation Result

If every instruction executes correctly, the simulation ends with:

```text
===============================================
        RV32I Verification Report
===============================================

PASS : ADDI x1
PASS : ADDI x2
PASS : ADD
PASS : SUB
PASS : AND
PASS : OR
PASS : XOR
PASS : SLT
PASS : SLL
PASS : SRL
PASS : LW 0
PASS : LW 4
PASS : BEQ
PASS : JAL
PASS : JAL Skip
PASS : LUI
PASS : AUIPC
PASS : SW MEM[0]
PASS : SW MEM[4]

===============================================
 Verification Finished
===============================================
```

---

# Purpose

This testbench serves as a functional verification environment for the RV32I Single-Cycle Processor. It validates the correct execution of implemented instructions, confirms register and memory updates, verifies control-flow instructions, and provides waveform support for debugging. The testbench acts as the primary verification framework before migrating the design to a pipelined architecture.
