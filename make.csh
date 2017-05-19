#!/bin/csh
module load fre/bronx-12
 set exp = "cm4p12_warsaw"
 set platform = "ncrc3.intel ncrc4.intel"
 set target = "debug-openmp repro-openmp prod-openmp debug repro prod"
 set xml = "awg_warsaw.xml"
 set s = " -s --force-compile"
 set ic = 1
 foreach t (${target})
 foreach p (${platform})
 if (${ic} == 1) then
  set s = " -s --force-compile --force-checkout"
 else
  set s = " -s --force-compile"
  set s = " -s "
 endif
    echo fremake -x ${xml[1]} -p ${p} -t ${t} ${exp} ${s}
         fremake -x ${xml[1]} -p ${p} -t ${t} ${exp} ${s}
 @ ic = ${ic} + 1
 end
 end
