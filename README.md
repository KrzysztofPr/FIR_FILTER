# **TRANSPOSED FIR FILTER**
The repository contains implementation of transposed FIR filter in VHDL on FPGA device. The filter can be found in [FIR_FILTER.vhd](https://github.com/KrzysztofPr/FIR_FILTER/blob/main/src/FIR_FILTER.vhd) file.
## Operation principle 📝
The schematic which explains the operation principle of the filter is shown below.
![image](https://github.com/KrzysztofPr/FIR_FILTER/assets/70481097/8056c7a0-dca9-4a22-8209-ab139dc4a44b)
## Filter model 💡
The filter assumptions and desing can be found in [FIR_Creator.py](https://github.com/KrzysztofPr/FIR_FILTER/blob/main/python_files/FIR_Creator.py) file.
The filter model which is implemented in python in [FIR_model.py](https://github.com/KrzysztofPr/FIR_FILTER/blob/main/python_files/FIR_model.py) was created as a golden data source for vhdl implementation verification. It outputs two data vectors in DataVec.txt file. Input and output vector, respectively in column 1 and 2.
The input vector is then sent as input for vhdl implemented FIR filter and output vector is compared with vhdl implementation.
## VUnit Tests 📊
In file [FIR_FILTER_tb.vhd](https://github.com/KrzysztofPr/FIR_FILTER/blob/main/sim/FIR_FILTER_tb.vhd) VUnit tests can be found. Implemented test cases:
- Init_values_test - checks if the filter initialization is done correctly
- Reset_test - checks reset conditions
- Valid_propagation - the filter has valid signal which indicates when the filter output is ready to be read, the propagation of the valid signal is checked in this test case
- Test_transposed_FIR_model - the test case reads the input and output of the python model, then it applies the input vector to the DUT - FIR filter entity and compares the output vectors (model to DUT)
