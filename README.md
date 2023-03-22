# BiCS-SWIM-system
# Description
We at Bio-insprired Ciruit and Systems Lab at ArizonaStateUniversity have developed an open-source Standalone Wireless Impedance Matching (SWIM) system for RF coils in MRI. We used a modular design approach to make it easy to scale the system to multiple channels or change the operating frequency according to field strength.

**1ch_SWIM MATLAB** file outputs capacitor values after tuning and matching any RF coil at any given field strength from 1.5T to 9.4T. The inputs for the program are radius of coil (R), diameter of the wire (d), frequency (based on field strength), number of breaks in coil (b) to add distribution capacitors. The outputs of the program are input impedance pre-impedance matching (ZL), tuning and matching capacitor values (Ct and Cm), and capacitor value at each break (Cbreak).

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons Licence" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.
