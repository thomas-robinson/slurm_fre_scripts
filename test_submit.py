#!/bin/python

import os
import subprocess
import argparse
from isrunning import isrunning, st2list_commas
from multiprocessing import Pool

def frerun (runs):
 while True:
  lines=[]
  for p in runs["p"]:
   for t in runs["t"]:
    for e in runs["exp"]:
# for p,t,e in runs["p"],runs["t"],runs["exp"]: 
#    print "frerun -s -x "+runs["x"]+" -p "+runs["p"]+" -t "+runs["t"]+" --cluster "+ \
#          runs["M"]+" -r "+runs["r"]+" "+runs["opts"]+" "+runs["exp"]
#    freout = subprocess.Popen("frerun -s -x "+runs["x"]+" -p "+runs["p"]+" -t "+runs["t"]+" --cluster "+
#                              runs["M"]+" -r "+runs["r"]+" "+runs["opts"]+" "+runs["exp"], stdout=subprocess.PIPE, shell=True)
     print "frerun -s -x "+runs["x"]+" -p "+p+" -t "+t+" --cluster "+ \
           runs["M"]+" -r "+runs["r"]+" "+runs["opts"]+" "+e
     freout = subprocess.Popen("frerun -s -x "+runs["x"]+" -p "+p+" -t "+t+" --cluster "+
                               runs["M"]+" -r "+runs["r"]+" "+runs["opts"]+" "+e, stdout=subprocess.PIPE, shell=True)
     result = freout.communicate()
     lines.append(result[0].splitlines())
  for ln in lines:
     for line in ln:
          tmp = line.split("on")
          tmp2 = tmp[0].split("job")
          jid = tmp2[1]
          isrunning (jid,M)

parser = argparse.ArgumentParser(description="Follows the output of a job running on slurm")
# Argument list 
parser.add_argument("-t" , "--targets", type=str, help="Comma separated list of targets to run", required=False)
parser.add_argument("-p" , "--platforms", type=str, help="Comma separated list of platforms to run", required=False)
parser.add_argument("-e" , "--exp", type=str, help="Comma separated list of experiments to run", required=False)
parser.add_argument("-x" , "--xml", type=str, help="The XML to use", required=False)
parser.add_argument("-M" , "--cluster", type=str, help="The slurm cluster to run on", required=False)
parser.add_argument("-r" , "--regression", type=str, help="The regression test to run", required=False)
parser.add_argument("--freopts", type=str, help="Additional frerun options", required=False)


# Parse the arguments
args = parser.parse_args()
if args.targets:
     targ = args.targets
else:
     targ = "prod-openmp-slurm"
if args.platforms:
     plat = args.platforms
else:
     plat = "ncrc3.intel"
if args.exp:
     exp = args.exp
else:
     exp = "c96L33_am4p0_1850climo"
if args.xml:
     xml = args.xml
else:
     xml = "awg_xanadu.xml"
if args.cluster:
     M = args.cluster
else:
     M = "t4"
if args.regression:
     r = args.regression
else:
     r = "rts"
if args.freopts:
     opts = args.freopts
else:
     opts = "--no-transfer --overwrite"

t=st2list_commas(targ)
p=st2list_commas(plat)
e=st2list_commas(exp)
print t,p,e
# Call the run function
runs ={"p":p , "t":t , "x":xml , "exp":e , "r":r , "M":M, "opts":opts} 
print runs["t"],runs["p"],runs["exp"]
frerun(runs)

