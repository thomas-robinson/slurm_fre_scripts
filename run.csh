#!/bin/csh
## Set the list of experiments
 set explist = `cat exp.lst`
## Select the platform(s) to run
 set platform = "ncrc3.intel ncrc4.intel"
## Choose the target(s) to run rts
#set target = "repro-openmp prod-openmp prod repro"
 set target = "repro-openmp prod-openmp"
#set target = "prod-openmp"
## Choose the target(s) to run debugrts
 set debug = "debug-openmp "
#set debug = "debug-openmp debug"
## This is the name of the XML:
 set xml = "awg_warsaw.xml" 
## Set the submitting options
 set s = " -s -A gfdl_f --unique --no-transfer"
## Choose the regressions to run
 set r_reg = "rts"
 set r_debug = "debugrts"
## Loop through the platforms
#foreach p (${platform})
 foreach p (ncrc3.intel ncrc4.intel)
## Loop through the targets (NOT DEBUG)
  foreach t (${target})
## Set the regressions here
   set r = ${r_reg}
   foreach exp (${explist})
    echo frerun -x ${xml[1]} -p ${p} -t ${t} ${exp} -r ${r} ${s}
         frerun -x ${xml[1]} -p ${p} -t ${t} ${exp} -r ${r} ${s}
   end 
  end
## Debug runs
  foreach t (${debug})
   set r = ${r_debug}
   foreach exp (${explist})
    echo frerun -x ${xml[1]} -p ${p} -t ${t} ${exp} -r ${r} ${s}
          frerun -x ${xml[1]} -p ${p} -t ${t} ${exp} -r ${r} ${s}
   end
  end
 end
