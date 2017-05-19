#!/bin/csh

 set explist = `cat exp.lst`
 set platform = "ncrc3.intel ncrc4.intel"
 set target = " prod-openmp repro-openmp"
 set debug = "debug-openmp"
 set xml = "awg_warsaw.xml"
 set r_reg = "rts,restart,basic,timing"
 set r_debug = "debugrts"
 foreach p (${platform})
# Loop through the targets (NOT DEBUG)
  foreach t (${target})
# Set the regressions here
   set r = ${r_reg}
   foreach exp (${explist})
    echo frecheck -x ${xml} -p ${p} -t ${t} ${exp} -r ${r}
         frecheck -x ${xml} -p ${p} -t ${t} ${exp} -r ${r}
   end
  end
  foreach t (${debug})
   set r = ${r_debug}
   foreach exp (${explist})
    echo frecheck -x ${xml} -p ${p} -t ${t} ${exp} -r ${r} 
         frecheck -x ${xml} -p ${p} -t ${t} ${exp} -r ${r} 
   end
  end
 end
