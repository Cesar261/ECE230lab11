# Lab 11 - Counters and Dividers

In this lab, we learned how to make clock dividers from two types of counters.

## Rubric

| Item | Description | Value |
| ---- | ----------- | ----- |
| Summary Answers | Your writings about what you learned in this lab. | 25% |
| Question 1 | Your answers to the question | 25% |
| Question 2 | Your answers to the question | 25% |
| Question 3 | Your answers to the question | 25% |

## Names
Cesar Garcia, Rafael Jacobo
## Summary
In this lab, we built and tested two types of clock dividers on the Basys3 board: modulo counters and cascaded T-flip-flop (ring/ripple) counters. We learned how sequential logic and state resets can be used to step down a fast system clock into slower, usable frequencies.
## Lab Questions

### 1 - Why does the Modulo Counter actually divide clocks by 2 * Count?
The output clock only toggles (switches from 0 to 1, or 1 to 0) each time the counter reaches the target Count. Since it takes two toggles to complete one full clock cycle (one rising edge and one falling edge), the total period is 2 * Count input cycles.
### 2 - Why does the ring counter's output go to all 1s on the first clock cycle?
On startup or reset, the flip-flops are initialized to 0. Because the feedback loop inverts the output (~Q) before feeding it back into the first flip-flop's input (D), a 1 is shifted into every stage on the first clock edge, setting all outputs to 1.
### 3 - What width of ring counter would you use to get to an output of ~1KHz?
Assuming the Basys3 board's 100 MHz clock 100,000,000Hz, you would need a 17-bit ring counter (or 17 cascaded flip-flops). Since each stage divides the frequency by 2 100Mhz/2^17 = 763Hz or a 16bit width for 1.53khz which is the closest power of two division to 1khz
