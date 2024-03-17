# **TRANSPOSED FIR FILTER**
The repository contains implementation of transposed FIR filter in VHDL on FPGA device. The filter can be found in [FIR_FILTER.vhd](https://github.com/KrzysztofPr/FIR_FILTER/blob/main/src/FIR_FILTER.vhd) file.
## Operation principle 📝
The schematic which explains the operation principle of the filter is shown below.
//scheme
## Filter model 💡
The filter assumptions and desing can be found in [FIR_Creator.py](https://github.com/KrzysztofPr/FIR_FILTER/blob/main/python_files/FIR_Creator.py) file.
The filter model which is implemented in python in [FIR_model.py](https://github.com/KrzysztofPr/FIR_FILTER/blob/main/python_files/FIR_model.py) was created as a golden data source for vhdl implementation verification. It outputs two data vectors in DataVec.txt file. Input and output vector, respectively in column 1 and 2.
The input vector is then sent as input for vhdl implemented FIR filter and output vector is compared with vhdl implementation.
## VUnit Tests 📊


