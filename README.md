# ITI Bank Queue System (ITI_BQS) 🏦

## Overview
ITI_BQS is an embedded digital system modeled in Verilog to monitor and manage a client queue at an ITI bank branch. The system tracks the number of people waiting (`Pcount`) and dynamically calculates the expected wait time (`Wtime`) based on the queue size and the number of active tellers. [cite_start]The real-time data is displayed using 7-segment displays[cite: 1, 7]. 

This project emphasizes modular design, component reusability, and hardware optimization techniques such as Look-Up Tables (ROM) and edge detection.

## System Features
* [cite_start]**Accurate Queue Counting:** Utilizes edge detectors to ensure only a single entry/exit pulse is recorded, preventing false multiple counts if a client stands in front of the photocell sensor[cite: 5, 6].
* [cite_start]**Dynamic Wait Time Calculation:** Real-time calculation using a synthesized ROM lookup table for optimized hardware performance instead of combinational arithmetic logic[cite: 7, 30].
* **Boundary Safeguards:** Features a parameterized Up/Down Counter that will not wrap around. [cite_start]It prevents decrementing below 0 or incrementing beyond the maximum limit[cite: 26, 28, 29].
* [cite_start]**Flag & Alarm System:** Continuously checks state bounds to output empty/full flags (`Eflag`, `Fflag`) and triggers dynamic alarms (`Ealarm`, `Falarm`) if unauthorized entry/exit occurs during boundary conditions[cite: 10, 11, 12, 13].
* [cite_start]**Parameterized Design:** The default queue width is $n=3$ (max capacity of 7), but the counter is highly modular and easily adjustable[cite: 1, 26].

## Architecture & Modules
The architecture decomposes the main `bqs` module into specialized sub-modules for clean hierarchy:

| Module | Description | Source |
| :--- | :--- | :--- |
| `bqs.v` | The top-level module instantiating all sub-components. [cite_start]| [cite: 1] |
| `edge_detector.v` | Triggers a single pulse on photocell beam interruption, utilizing an asynchronous D-Flip Flop (`d_ff.v`). [cite_start]| [cite: 14, 24, 25] |
| `Tcounter.v` | Calculates the number of active tellers in service (1 to 3). [cite_start]| [cite: 42, 43] |
| `Pcounter.v` | An $n$-bit parameterized up-down counter tracking the total number of queued clients. [cite_start]| [cite: 26, 28] |
| `rom.v` | A 32-location Read-Only Memory module serving as a Look-Up Table to retrieve the expected waiting time (`Wtime`). [cite_start]| [cite: 30, 31, 35] |
| `seperator.v` | Splits the binary wait time into tens and ones digits for 7-segment routing. [cite_start]| [cite: 38, 39, 40] |
| `decoder_7seg.v` | Combinational logic mapping binary inputs to standard 7-segment display outputs. [cite_start]| [cite: 18, 20] |

## Wait Time Mathematical Model
Instead of real-time logic synthesis, the wait time is pre-calculated in the ROM using the following formula:

$$Wtime = \frac{3 \times (Pcount + Tcount - 1)}{Tcount}$$

[cite_start]*(Note: Wait time is natively 0 if the queue is empty, and fractions are truncated to fit the 5-bit output bus)*[cite: 30, 35].

## Inputs & Outputs
### Inputs
* [cite_start]`t1, t2, t3`: Active tellers status (1 = active, 0 = inactive)[cite: 1].
* [cite_start]`Bs` (Back Sensor): Photocell tracking clients entering the queue[cite: 1, 6].
* [cite_start]`Fs` (Front Sensor): Photocell tracking clients leaving the queue[cite: 1, 5].
* [cite_start]`reset`: Asynchronous reset for clearing data[cite: 1].
* [cite_start]`clk`: System clock[cite: 1].

### Outputs
* [cite_start]`Pcount`: Binary representation of people currently queued[cite: 1].
* [cite_start]`Wtime`: Binary expected wait time in seconds[cite: 1].
* [cite_start]`Pcount_7seg`, `Wtime_7seg_ten`, `Wtime_7seg_sec`: Outputs routed to the physical 7-segment displays[cite: 1].
* [cite_start]`Fflag`, `Eflag`: Active HIGH signals representing Full and Empty states[cite: 10, 11].
* [cite_start]`Falarm`, `Ealarm`: Active HIGH alarms triggered upon boundary violations[cite: 12, 13].
