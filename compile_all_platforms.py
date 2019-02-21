#!/bin/python

import subprocess
import argparse
from multiprocessing import Pool
import re
import os

def fremake(build):
     print "fremake -x "+xml+" -p "+build["p"]+" -t "+build["t"]+" "+build["exp"]
#     fmkout = subprocess.check_output("fremake -x "+xml+" -p "+build["p"]+" -t "+build["t"]+" "+build["exp"])
     result = subprocess.Popen("fremake -s -x "+xml+" -p "+build["p"]+" -t "+build["t"]+" "+build["exp"], shell=True, stdout=subprocess.PIPE)
#     fmkout = result.communicate()
#     getscript = fmkout[0].replace('msub','sbatch').split('sbatch')
#     print getscript[1]
#     sptname = getscript[1].split("exec/")
#     getdir = getscript[1].split("compile")
#     print getdir[0]
#    if ((build["t"] == "debug-openmp-slurm") and 
#        (build["p"] == "ncrc3.intel" or build["p"] == "ncrc3.gnu" or build["p"] == "ncrc3.cce" or build["p"] == "ncrc3.pgi")):
#         os.system("sbatch -M t4 "+getscript[1])
#    elif ((build["t"] == "debug-openmp-slurm") and (build["p"] == "ncrc3.intel17" or build["p"] == "ncrc3.intel18")):
#         os.system("sbatch "+getscript[1])
#    else: 
#         os.system("pushd "+getdir[0]+" && COMPile.csh "+sptname[1]+" && popd")
#     os.system("COMPile.csh "+getscript[1])
#     os.system("pushd "+getdir[0]+" && COMPile.csh "+sptname[1]+" ; popd")
#     print sptname


parser = argparse.ArgumentParser(description="Follows the output of a job running on slurm")
# Argument list 
parser.add_argument("-t" , "--targets", type=str, help="The targets to compile", required=False)
# Parse the arguments
args = parser.parse_args()
targ = args.targets
xml = "awg_xanadu.xml"
exp = "cm4p12_xanadu"
targets=["prod-openmp-slurm","repro-openmp-slurm","debug-openmp-slurm"]
#targets=["debug-slurm"]
# Parse out the platforms from the XML
pgrep = subprocess.Popen("grep 'platform name\s*=' awg_xanadu.xml | grep -v gfdl.", stdout=subprocess.PIPE, shell=True)
result = pgrep.communicate()
lines = result[0].splitlines()
platforms=[]
for line in lines:
     ptmp = line.split('"')
     platforms.append(ptmp[1])
# Prepare the different builds
builds=[]
for p in platforms:
     for t in targets:
          builds.append({"p":p , "t":t , "x":xml , "exp":exp})

num_procs = len(targets)*len(platforms)
print num_procs
if __name__ == '__main__':
    pool = Pool(processes=num_procs)                         # Create a multiprocessing Pool
    pool.map(fremake, builds)  # process data_inputs iterable with pool


#for b in builds:
#     fremake(b)

