#!/bin/csh
 set exp = "cm4p12_warsaw"
 set platform = "ncrc4.intel"
 set target = "debug-openmp repro-openmp prod-openmp debug repro prod"
 set xml = `ls *.xml`
 set xml = "awg_warsaw.xml"
 set s = " -s --force-compile"
 set s = " -s "
 foreach t (${target})
 foreach p (${platform})
    echo fremake -x ${xml[1]} -p ${p} -t ${t} ${exp} ${s}
         fremake -x ${xml[1]} -p ${p} -t ${t} ${exp} ${s}

 end
 end
