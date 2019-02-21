#!/bin/python

import os
import subprocess


def isrunning (jid,M):
   check = True
   nc = 0
   nt = 0
   wait = 30
   while (check == True):
     output = subprocess.check_output("squeue -M "+M+" --job " + jid, shell=True) 
     i=0
     lines = output.splitlines()
     for line in lines:
          i=i+1
     if (i == 2):
          check = False
          print "Job "+jid+" completed on check "+str(nc+1)
     else:
          nc = nc + 1
          print "Job "+str(jid)+" still running for check number "+str(nc)+" ("+str(nt)+"s)"
          nt = nt + wait
          os.system("sleep "+str(wait))


def st2list_commas (st):
     lst = st.split(",")
     return lst
