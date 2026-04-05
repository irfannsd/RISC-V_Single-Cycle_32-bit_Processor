# RISC-V Single Cycle 32-bit Processor

## Overview

This project implements a **32-bit Single-Cycle RISC-V Processor** using **Verilog HDL**.
The processor executes instructions in **one clock cycle per instruction**, meaning all stages of instruction execution (fetch, decode, execute, memory access, and write-back) occur within a single clock period.

The design follows the **RV32I base instruction set** and demonstrates the fundamental architecture of a RISC-V processor including instruction memory, register file, ALU, control unit, and data memory.

The processor is verified using a **Verilog testbench** and simulated using tools such as **Icarus Verilog** and **GTKWave**.

---

# Processor Architecture

The processor follows the classic **single-cycle datapath** consisting of the following stages:

1. **Instruction Fetch (IF)**
2. **Instruction Decode (ID)**
3. **Execute (EX)**
4. **Memory Access (MEM)**
5. **Write Back (WB)**

All stages execute in **one clock cycle**, which simplifies the control logic but increases the clock period.

---

# Supported Instructions

The processor currently supports basic **RV32I instructions**, including:

| Instruction Type | Examples       |
| ---------------- | -------------- |
| Immediate        | `addi`         |
| Arithmetic       | `add`, `sub`   |
| Memory           | `lw`, `sw`     |
| Branch           | `beq`, `blt`   |
| NOP              | `addi x0,x0,0` |

---

# Project File Structure

Below is the structure of the repository and the purpose of each module.

| File                      | Description                                                        |
| ------------------------- | ------------------------------------------------------------------ |
| `01.PC.v`                 | Program Counter module that stores the current instruction address |
| `02.PC_adder.v`           | Computes the next sequential PC (`PC + 4`)                         |
| `03.inst_mem.v`           | Instruction memory module that fetches instructions                |
| `04.instr_mem.hex`        | Instruction memory initialization file                             |
| `05.Register.v`           | Register file containing 32 registers                              |
| `06.Immediate_Generate.v` | Generates immediate values from instruction fields                 |
| `07.Control_Unit.v`       | Main control unit that generates control signals                   |
| `08.ALU_Control.v`        | Generates ALU operation control signals                            |
| `09.ALU.v`                | Arithmetic Logic Unit performing arithmetic and logic operations   |
| `10.Data_Memory.v`        | Data memory module used for load/store instructions                |
| `11.Multiplexer.v`        | Multiplexer used for datapath selection                            |
| `12.PC_Branch_target.v`   | Computes branch target address                                     |
| `13.Top_Module.v`         | Top-level processor module connecting all components               |
| `14.Testbench.v`          | Testbench used to verify processor functionality                   |
| `14.Tb_README.md`         | Documentation for the testbench                                    |

---

# Processor Datapath Components

## Program Counter (PC)

The **PC module** holds the address of the current instruction and updates every clock cycle.

```
PC_next = PC + 4
```

or

```
PC_next = Branch_Target
```

depending on branch conditions.

---

## Instruction Memory

Instruction memory stores the machine code instructions used by the processor.

The memory is initialized using:

```
instr_mem.hex
```

Example instructions:


| Machine Code |  Assembly Instruction    |              Description                                |
|  ----------  | ------------------------ | ------------------------------------------------------- |
|  `00000093`  | `addi x1, x0, 0`         | Initialize register **x1 = 0**                          |
|  `00500113`  | `addi x2, x0, 5`         | Load constant **5 into x2**                             |
|  `002081b3`  | `add x3, x1, x2`         | Add **x1 + x2** and store result in **x3**              |
|  `00310023`  | `sw x3, 0(x2)`           | Store value of **x3 into memory address (x2 + 0)**      |
|  `00010183`  | `lw x3, 0(x2)`           | Load value from **memory address (x2 + 0)** into **x3** |
|  `00118213`  | `addi x4, x3, 1`         | Add **1 to x3** and store result in **x4**              |
|  `0041a063`  | `beq x3, x4, label`      | Branch to **label** if **x3 == x4**                     |
|  `00200293`  | `addi x5, x0, 2`         | Load constant **2 into x5**                             |
|  `00000013`  | `nop` (`addi x0, x0, 0`) | No operation — used to **terminate program**            |

  

---

## Register File

The register file contains **32 registers (x0 – x31)**.

Features:

* Two read ports
* One write port
* Register `x0` is always **zero**

---

## Immediate Generator

Extracts and sign-extends immediate values from instruction fields depending on instruction type:

* I-type
* S-type
* B-type

---

## Control Unit

The control unit decodes the **opcode field** of the instruction and generates control signals such as:

* `RegWrite`
* `MemRead`
* `MemWrite`
* `Branch`
* `ALUSrc`
* `MemtoReg`

These signals control the datapath behavior.

---

## ALU Control

The **ALU Control module** determines the operation performed by the ALU using:

* `ALUOp`
* `funct3`
* `funct7`

---

## ALU (Arithmetic Logic Unit)

The ALU performs operations such as:

* Addition
* Subtraction
* Logical operations
* Comparison operations

The ALU also generates a **zero flag** used for branch decisions.

---

## Data Memory

Data memory is used for **load and store instructions**.

Example:

```
sw x3,0(x2)
lw x3,0(x2)
```

---

## Branch Target Calculation

The **PC_Branch_target module** calculates the branch destination:

```
Branch_Target = PC + Immediate
```

---

## Top Module

The **Top_Module.v** integrates all processor components and implements the full datapath of the RISC-V processor.

---

# Testbench

The processor is verified using **14.Testbench.v**, which performs the following tasks:

* Generates clock signal
* Applies reset
* Monitors instruction execution
* Prints register values
* Dumps waveform for debugging

Simulation stops when the processor executes:

```
NOP (00000013)
```

which indicates the end of the program.

Detailed documentation of the testbench can be found in:

```
14.Tb_README.md
```

---

# Learning Objectives

This project demonstrates the implementation of:

* RISC-V processor architecture
* Single-cycle datapath design
* Control signal generation
* Register file design
* ALU operations
* Memory operations
* Branch handling
* Verilog-based processor simulation

---

# Tools Used

* **Verilog HDL**
* **Icarus Verilog**
* **GTKWave**

---

# Author

IRFAN KHAN

Implementation of a **32-bit Single-Cycle RISC-V Processor** for educational and learning purposes.
