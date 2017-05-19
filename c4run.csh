#!/bin/csh

 set platform = "ncrc4.intel "
 set explist = `cat exp.lst`
#set explist = "c96L32_am4g12r17"
#set explist = `cat timing.lst`
 set target = "repro-openmp prod-openmp repro prod"
#set debug = "debug-openmp "
#set target = "prod-openmp repro-openmp repro prod"
#set debug = "debug-openmp debug"
#set target = "prod-openmp "
#set target = "debug-openmp-codecov"
#repro-openmp"
 set debug = "debug-openmp"
 set xml = "awg_warsaw.xml"
#`ls awg_*.xml`
 set s = " -s -A gfdl_f --unique --no-transfer"
#set s = "-s -A gfdl_f"
#set r_reg = "rts,timing,year"
#set r_debug = "debugSuite"
 set r_reg = "rts"
 set r_reg = "basic"
 set r_debug = "debugrts"


 foreach p (${platform})
# Loop through the targets (NOT DEBUG)
  foreach t (${target})
# Set the regressions here
   set r = ${r_reg}
   foreach exp (${explist})
    echo frerun -x ${xml[1]} -p ${p} -t ${t} ${exp} -r ${r} ${s}
         frerun -x ${xml[1]} -p ${p} -t ${t} ${exp} -r ${r} ${s}
   end
  end
  foreach t (${debug})
   set r = ${r_debug}
   foreach exp (${explist})
     echo frerun -x ${xml[1]} -p ${p} -t ${t} ${exp} -r ${r} ${s}
          frerun -x ${xml[1]} -p ${p} -t ${t} ${exp} -r ${r} ${s}
   end
  end
 end
