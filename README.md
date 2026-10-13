# FPGA Motor Controller

A Verilog based digital motor controller developed using Intel Quartus and ModelSim, targeting the Terasic SoC Kit.

## Overview

This project explores the design and verification of a digital motor controller implemented in RTL. The controller is intended to provide PWM-based speed control, direction control, predictable reset and enable behaviour.

The project focuses on developing sound synchronous design practices, systematic simulation-based verification and FPGA implementation.

**Project status:** In development.

## Objectives

- Implement PWM generation for motor speed control.
- Implement motor direction control with switching conditions.
- Establish predictable reset and enable behaviour.
- Develop a testbench to verify functional requirements and boundary conditions.
- Investigate design behaviour through ModelSim waveforms.
- Synthesise and evaluate the design using Intel Quartus.
- Validate the implementation on FPGA hardware where practical.

## Technology Stack

| Technology | Purpose |
|---|---|
| Verilog HDL | RTL implementation |
| Intel Quartus | FPGA synthesis and implementation |
| ModelSim | Functional simulation and waveform analysis |
| Terasic SoC Kit | Target FPGA development hardware |

## Repository Structure

```text
FPGA-Motor-Controller/
├── rtl/          # RTL source files
├── sim/          # Testbench and simulation files
├── constraints/  # FPGA pin and timing constraints
├── docs/         # Requirements and design documentation
├── results/      # Verification and implementation evidence
└── README.md
```

## Design and Verification

The controller is being developed incrementally, with simulation used to investigate behaviour before hardware validation.

Planned verification includes:

- Reset and initialisation.
- PWM operation and duty-cycle behaviour.
- Enable and zero speed conditions.
- Direction switching.
- Boundary conditions and invalid command sequences.

## Learning Outcomes

This project aims to deepen my practical experience in FPGA development, focusing on Verilog RTL design, synchronous digital logic, simulation and hardware implementation.
The skills and techniques developed will be applied to my final year autonomous underwater vehicle project, where reliable digital control and hardware/software integration will be important components of the overall system.

## Current Status

Latest: RTL simulation and verification complete.

Completed tasks:
- Implemented a parameter-free Verilog PWM motor controller.
- Added speed command, enable and direction inputs.
- Created a self-checking ModelSim testbench.
- Verified PWM duty-cycle behaviour at 0%, 25%, 50%, 75% and 100%.
- Tested enable and direction behaviour. 
- Completed a Quartus compilation successfully.

## Current Task

Reviewing verification coverage and preparing the design for hardware testing.

## Future Development

- Expand test coverage, including reset behaviour and additional speed commands.
- Review timing constraints and resolve unconstrained timing paths.
- Confirm the target FPGA board and assign physical pin locations.
- Validate the design on the FPGA board.
- Document test results and any hardware observations.

