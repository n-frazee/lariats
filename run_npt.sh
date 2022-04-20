# @Author: nfrazee
# @Date:   2021-12-16T15:21:03-05:00
# @Last modified by:   nfrazee
# @Last modified time: 2022-04-19T13:16:17-04:00
# @Comment:

PROJ=`pwd`
COMMON="$PROJ/common"

for n in $(seq 1 16); do
     for l in $(ls peps/$n); do
          for s in octanol water; do
               if [ -f peps/$n/$l/min.dcd ]; then
		          if ! [ -f peps/$n/$l/$s/npt.dcd ]; then
                       cd peps/$n/$l/$s
                       cp $COMMON/npt.conf .
                       cp $COMMON/npt.pbs .
                       qsub npt.pbs
                       cd $PROJ
		          fi
               fi
          done
     done
done
