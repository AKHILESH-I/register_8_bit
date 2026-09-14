# Project 2 — Class-Based SystemVerilog DV

## 8-bit Register Verification

Built a class-based Design Verification environment for an 8-bit register with an asynchronous active-low reset.

## Verification Architecture

The testbench is organized using reusable SystemVerilog classes:

- Transaction
- Generator
- Driver
- Monitor
- Scoreboard
- Reference Model
- Environment

## Verification Features

- Transaction-based stimulus
- Constrained-randomization
- Mailbox-based communication
- Virtual interface
- Clocking blocks
- Generator-driver synchronization
- Monitor-scoreboard communication
- Reference model checking
- Directed and randomized transactions
- Reset verification
- Functional checking

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
