# Project 3 — UVM-Based 8-bit Register Verification

## Overview

This project verifies an 8-bit synchronous register with an active-low asynchronous reset using **SystemVerilog and UVM**.

The project is the third stage of the verification progression:

1. Procedural SystemVerilog DV
2. Class-Based SystemVerilog DV
3. UVM-Based DV

The goal is to demonstrate a reusable, layered UVM verification environment with constrained-random stimulus, functional coverage, assertions, a predictor/reference model, and a scoreboard.

---

## DUT

The DUT is an 8-bit register with:

- Synchronous data capture
- Active-low asynchronous reset
- Reset value: `8'h00`

### Interface

| Signal | Width | Description |
|---|---:|---|
| `clk` | 1 | Clock |
| `rst_n` | 1 | Active-low asynchronous reset |
| `d` | 8 | Data input |
| `q` | 8 | Registered output |

---

## UVM Architecture

```text
                    UVM TEST
                       |
                  UVM SEQUENCE
                       |
                   SEQUENCER
                       |
                    DRIVER
                       |
                Virtual Interface
                       |
                      DUT
                       |
                    MONITOR
                       |
             +---------+---------+
             |                   |
          COVERAGE           PREDICTOR
                                 |
                           EXPECTED DATA
                                 |
                            SCOREBOARD
                                 |
                         PASS / FAIL REPORT
