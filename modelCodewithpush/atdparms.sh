#!/bin/bash
# tested for linux only

# read each line (remove blanks with sed) and read into 4 parm vars
loop=0
cat lhsdesign.dat | sed '/^$/d' $i | while read p1 p2 p3 p4; do
    loop=$((loop + 1))
    echo "Parameters set #$loop: $p1 , $p2 , $p3, $p4 "
    echo "#define __ATD_PARM_1__ $p1" > atdparms.hpp
    echo "#define __ATD_PARM_2__ $p2" >> atdparms.hpp
    echo "#define __ATD_PARM_3__ $p3" >> atdparms.hpp
    echo "#define __ATD_PARM_4__ $p4" >> atdparms.hpp

    # calc outfile
    outfile=`printf "%04d" $loop`

    # now build & run
    make  2>&1 > make.out 
    if [ $? != 0 ]; then
        echo "ERROR: Compilation failed.  Check make.out for details."
        exit 1
    fi

    echo "Executing command: \"./mtKineticModel 10 lhsrun$outfile temp\""
    ./mtKineticModel 10 lhsrun$outfile temp
done

