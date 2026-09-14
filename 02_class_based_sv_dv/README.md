# Project 2 — Class-Based SystemVerilog DV

## 8-bit Register Verification

Built a class-based Design Verification environment for an 8-bit register with an asynchronous active-low reset.

## DUT

The DUT is an 8-bit register with:

- Positive-edge triggered clock
- Asynchronous active-low reset
- 8-bit data input
- 8-bit registered output

## Verification Architecture

The testbench is organized using reusable SystemVerilog classes:

- Transaction
- Generator
- Driver
- Monitor
- Scoreboard
- Reference Model
- Environment

## Testbench Architecture

```text
                 Generator
                     |
                  Mailbox
                     |
                     v
                   Driver
                     |
              Virtual Interface
                     |
                     v
                    DUT
                     |
                     v
                  Monitor
                     |
                  Mailbox
                     |
                     v
                Scoreboard
                     |
              Reference Model
