import FIR_Creator as FIR
from scipy import signal as sg
import random
import matplotlib.pyplot as plt

C_TestValuesNum=1000

fir=sg.firwin(numtaps=FIR.C_FirOrder,cutoff=FIR.C_CutOff,fs=FIR.C_SampleFrq)
coefs_lsIQ=[]
coefs_ls=[]
for i in range(len(fir)):
  coefs_lsIQ.append(int(fir[i]*(2**FIR.C_COEF_W)))
  coefs_ls.append(fir[i])


#generate random input stream
InputVec=[]
for i in range(C_TestValuesNum):
  InputVec.append(random.randint(0,(2**16)-1))


def CalcFIR_direct(InputVec,Coefs,Order): #direct form of FIR filter
  activeSamples=[0]*Order
  output=0
  output_ls=[]
  for x in range(C_TestValuesNum):
    output=0
    for j in range(len(activeSamples)): # sum 
      output=output+((activeSamples[j]*Coefs[j])>>16)
    for p in reversed(range(len(activeSamples))): 
      if  p >= 1: #move
        activeSamples[p]=activeSamples[p-1]
    activeSamples[0]=InputVec[x]
    output_ls.append(output)
  return output_ls

def CalcFIR_transposed(InputVec,Coefs,Order): #transposed form of fir filter
  multSample=[0]*Order
  registers=[0]*Order
  Coefs.reverse() #coefs are reversed in transposed form
  output_ls = []
  currentInput = 0
  for x in range(C_TestValuesNum):
    for j in reversed(range(len(multSample))): # 9 8 7 6...
      #calculate based on values before rising edge
      if j >= 1:
        registers[j]=registers[j-1]+multSample[j]
    registers[0]=multSample[0]
    # prepare data for next iteration
    currentInput=InputVec[x]
    for p in range(len(multSample)):
      multSample[p]=(currentInput*Coefs[p])>>16
    output_ls.append(registers[-1])
  return output_ls

OutVec=CalcFIR_transposed(InputVec,coefs_lsIQ,FIR.C_FirOrder)
RefVec=sg.lfilter(coefs_ls,[1.0],InputVec)


#save data to .txt for vhdl testbench purposes
file=open('../sim/DataVec.txt','w')
# for i in range(C_TestValuesNum):
  # file.write('{} {}'.format(str(InputVec[i]),str(OutVec[i]))+ '\n')

plt.plot(RefVec)
plt.plot(OutVec)
plt.show()

