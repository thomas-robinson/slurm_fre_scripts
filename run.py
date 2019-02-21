#!/bin/python

import os
import subprocess
from isrunning import isrunning
from multiprocessing import Pool

def frerun (runs):
  while True:
     print "frerun -x "+runs["x"]+" -p "+runs["p"]+" -t "+runs["t"]+" --cluster "+ \
           runs["M"]+" -r "+runs["r"]+" "+runs["opts"]+" "+runs["exp"]
     freout = subprocess.Popen("frerun -x "+runs["x"]+" -p "+runs["p"]+" -t "+runs["t"]+" --cluster "+
                               runs["M"]+" -r "+runs["r"]+" "+runs["opts"]+" "+runs["exp"], stdout=subprocess.PIPE, shell=True)
     if (not runs["resub"]):
          break
     result = freout.communicate()
     lines = result[0].splitlines()
     for line in lines:
          tmp = line.split("on")
          tmp2 = tmp[0].split("job")
          jid = tmp2[1]
          isrunning (jid,M)
