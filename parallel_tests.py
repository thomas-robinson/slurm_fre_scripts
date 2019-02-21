#!/bin/python 
import subprocess
import argparse
from multiprocessing import Pool
import re
import os
from run import frerun

xml = "awg_xanadu.xml"
 
targets=["prod-openmp-slurm","repro-openmp-slurm"]
r = "rts"
M = "c3"
#targets=["debug-slurm"]
# Parse out the platforms from the XML
pgrep = subprocess.Popen("grep 'platform name\s*=' "+xml+" | grep -v gfdl.", stdout=subprocess.PIPE, shell=True)
result = pgrep.communicate()
lines = result[0].splitlines()
platforms=[]
for line in lines:
     ptmp = line.split('"')
     platforms.append(ptmp[1])
#parse out the experiments from the frelist output
frelist = subprocess.Popen("frelist -x "+xml, stdout=subprocess.PIPE, shell=True)
result = frelist.communicate()
lines = result[0].splitlines()
exp=[]
for line in lines:
     etmp = line.split(' ')
     if (len(etmp) > 1):
          exp.append(etmp[0])
print exp

# Prepare the different runs
runs=[]
i=0
for p in platforms:
     for t in targets:
          for e in exp:
               runs.append({"p":p , "t":t , "x":xml , "exp":e , "r":r , "opts":"-s --no-transfer --overwrite" , "M":M , "resub":False})
               print i,runs[i]
               i=i+1
print i
num_procs = len(targets)*len(platforms)
print num_procs
if __name__ == '__main__':
    pool = Pool(processes=num_procs)                         # Create a multiprocessing Pool
    pool.map(frerun, runs)  # process data_inputs iterable with pool

