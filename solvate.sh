# @Author: nfrazee
# @Date:   2021-11-02T16:15:10-04:00
# @Last modified by:   nfrazee
# @Last modified time: 2022-04-14T12:08:08-04:00
# @Comment:

PROJ=`pwd`
COMMON=`pwd`/common


for n in $(seq 1 16); do
     for l in $(ls -v peps/$n); do
          if [ -f peps/$n/$l/min.dcd ]; then
               echo "$n $l"

               #make directories for each solvent
               mkdir -p peps/$n/$l/water peps/$n/$l/octanol

               cd peps/$n/$l/
               # writes pdb of last frame from min to opt.pdb
               vmd -dispdev text -e $COMMON/last_frame.tcl > /dev/null 2>&1
               rm min.co* min.restart* *.BAK min.x* min.vel FF* 2>/dev/null
               # solvate the last frame in both octanol and water
               vmd -dispdev text -e $COMMON/solvate.tcl > /dev/null 2>&1

               cd $PROJ
          fi

     done
done
