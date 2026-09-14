# Project 1 — Procedural SystemVerilog DV

## 8-bit Register Verification

Verification of an 8-bit register with an asynchronous active-low reset using procedural SystemVerilog.

## DUT

The Design Under Test is an 8-bit register with:

- Positive-edge triggered clock
- Asynchronous active-low reset
- 8-bit data input
- 8-bit registered output

## Verification Features

- Directed testing
- Randomized testing
- Reference model
- SystemVerilog Assertions (SVA)
- Functional coverage
- Asynchronous reset verification
- Reset dominance verification
- Hold behavior verification
- X/Z checking
- Data transition coverage
- Data × reset cross coverage

## Simulator

QuestaSim

## Results

- Functional Coverage: 100%
- Reset Coverage: 100%
- Errors: 0
- Warnings: 0

## Verification Flow

```text
Stimulus
   ↓
DUT
   ↓
Reference Model
   ↓
Assertions + Functional Coverage
   ↓
Verification Results
