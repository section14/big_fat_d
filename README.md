Big Fat D Sequencer
=========

The Big Fat D is an Arduino based CV / Trigger sequencer designed to interface with analog synthesizers (specifically eurorack modular). I created this project to interface with my eurorack modular synthesizer. At the core, this is a 32/dual 16/ quad 8 step analog sequencer. It is designed with a 3-position rotary switch to switch between the different modes. Each mode is able to receive a different clock. Two octave ranges, a pendulum (back and forth) option and a reset for each independent sequencer.

This project was created with the Arduino Mega 2560, but the code could be refactored to run on a regular arduino. Please note, this WILL NOT work with the Arduino Due. This is designed to run on 5 volts and will fry the Due.

I am not an electrical engineer and am providing this code with the assumption that the end user will do their homework on building basic electrical circuits. Bypass capacitors and input protection via zener diode protection are good places to start. Also, 220 ohm resistors on your LED's. That said, the Arduino handles most of the workload.

Below is a list of the IC's I used building this project, that are referenced in the code. Similar chips should work:

- DAC (Digital Analog Converter) - Microchip Technology MCP4921-E/P
- Multiplexers - NXP Semiconductors 568-1689-5-ND
- Shift Registers - ON Semiconductor MC74HC595ANGOS-ND 

Keep in mind, the code as featured, will use almost every pin on the Arduino Mega. If this is a beginner project, you may want to comb the code and create a 16 step version instead of a 32. After reviewing the code, you will notice a lot is repeated to create the single, dual and quad sequencers. Hope you find this useful.
