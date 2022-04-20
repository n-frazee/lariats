# @Author: nfrazee
# @Date:   2021-12-16T15:21:03-05:00
# @Last modified by:   nfrazee
# @Last modified time: 2022-04-14T10:49:01-04:00
# @Comment:

PROJ=`pwd`
COMMON="$PROJ/common"

num=5
for n in $(seq 1 16); do
     for l in $(python $COMMON/rand_lines.py $num $(wc -l libs/$n.txt)); do
     #for l in $(ls peps/$n); do
          cd peps/$n/$l
          cp $COMMON/min.conf .
          echo -n Running $n $l"... "
          namd2.13 +p4 min.conf > min.log
          #if [ $? -ne 0 ]; then cd $PROJ; exit; fi
          echo Done.
          cd $PROJ

     done
done
