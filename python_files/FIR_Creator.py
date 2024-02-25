from scipy import signal as sg
import matplotlib.pyplot as plt
import numpy as np

C_FirOrder = 10
C_CutOff = 10e3
C_SampleFrq = 50e6
C_COEF_W = 16
####
def CreateMifFile(FirOrder,Coef_W):
  file=open('../mif_files/FIR_coefs.mif','w')
  file.write('DEPTH = ' + str(FirOrder) +';\n')
  file.write('WIDTH = ' + str(Coef_W) +';\n')
  file.write('ADDRESS_RADIX = DEC;\n')
  file.write('DATA_RADIX = DEC;\n')
  file.write('CONTENT\n')
  file.write('BEGIN\n\n\n')
  for x in range(len(fir)):
    file.write(str(x) + ' : ' + str(int(fir[x]*(2**Coef_W)))+';\n')
  file.write('\n')
  file.write('END;')
####

fir=sg.firwin(numtaps=C_FirOrder,cutoff=C_CutOff,fs=C_SampleFrq)
for i in range(len(fir)):
  print(int(fir[i]*(2**C_COEF_W)))
w,h=sg.freqz(fir)
# plt.plot(w*C_SampleFrq/(np.pi),20*np.log10(abs(h)))
# plt.show()
CreateMifFile(C_FirOrder,C_COEF_W)

#save to .mif -> populate ROM in FPGA
