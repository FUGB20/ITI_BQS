# ITI Bank Queue System (ITI_BQS) 🏦

## Overview
ITI_BQS is an embedded digital system modeled in Verilog to monitor and manage a client queue at an ITI bank branch. The system tracks the number of people waiting (`Pcount`) and dynamically calculates the expected wait time (`Wtime`) based on the queue size and the number of active tellers. The real-time data is displayed using 7-segment displays. 

This project emphasizes modular design, component reusability, and hardware optimization techniques such as Look-Up Tables (ROM) and edge detection.

## System Features
* **Accurate Queue Counting:** Utilizes edge detectors to ensure only a single entry/exit pulse is recorded, preventing false multiple counts if a client stands in front of the photocell sensor.
* **Dynamic Wait Time Calculation:** Real-time calculation using a synthesized ROM lookup table for optimized hardware performance instead of combinational arithmetic logic.
* **Boundary Safeguards:** Features a parameterized Up/Down Counter that will not wrap around. It prevents decrementing below 0 or incrementing beyond the maximum limit.
* **Flag & Alarm System:** Continuously checks state bounds to output empty/full flags (`Eflag`, `Fflag`) and triggers dynamic alarms (`Ealarm`, `Falarm`) if unauthorized entry/exit occurs during boundary conditions.
* **Parameterized Design:** The default queue width is $n=3$ (max capacity of 7), but the counter is highly modular and easily adjustable.

## Architecture & Modules
The architecture decomposes the main `bqs` module into specialized sub-modules for clean hierarchy:

| Module | Description |
| :--- | :--- |
| `bqs.v` | The top-level module instantiating all sub-components. |
| `edge_detector.v` | Triggers a single pulse on photocell beam interruption, utilizing an asynchronous D-Flip Flop (`d_ff.v`). |
| `Tcounter.v` | Calculates the number of active tellers in service (1 to 3). |
| `Pcounter.v` | An $n$-bit parameterized up-down counter tracking the total number of queued clients. |
| `rom.v` | A 32-location Read-Only Memory module serving as a Look-Up Table to retrieve the expected waiting time (`Wtime`). |
| `seperator.v` | Splits the binary wait time into tens and ones digits for 7-segment routing. |
| `decoder_7seg.v` | Combinational logic mapping binary inputs to standard 7-segment display outputs. |

## Wait Time Mathematical Model
Instead of real-time logic synthesis, the wait time is pre-calculated in the ROM using the following formula:

$$Wtime = \frac{3 \times (Pcount + Tcount - 1)}{Tcount}$$

*(Note: Wait time is natively 0 if the queue is empty, and fractions are truncated to fit the 5-bit output bus)*.

## Inputs & Outputs
### Inputs
* `t1, t2, t3`: Active tellers status (1 = active, 0 = inactive).
* `Bs` (Back Sensor): Photocell tracking clients entering the queue.
* `Fs` (Front Sensor): Photocell tracking clients leaving the queue.
* `reset`: Asynchronous reset for clearing data.
* `clk`: System clock.

### Outputs
* `Pcount`: Binary representation of people currently queued.
* `Wtime`: Binary expected wait time in seconds.
* `Pcount_7seg`, `Wtime_7seg_ten`, `Wtime_7seg_sec`: Outputs routed to the physical 7-segment displays.
* `Fflag`, `Eflag`: Active HIGH signals representing Full and Empty states.
* `Falarm`, `Ealarm`: Active HIGH alarms triggered upon boundary violations.
