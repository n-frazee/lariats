# @Author: nfrazee
# @Date:   2021-12-16T15:21:03-05:00
# @Last modified by:   nfrazee
# @Last modified time: 2022-01-20T15:42:51-05:00
# @Comment:



steps=500000
nodes=2
walltime=4
#queue="jbmertz"
#queue="comm_small_week"
queue="standby"
prod=min

PROJ=`pwd`
COMMON="$PROJ/common"

for n in $(seq 1 16); do
     for l in $(ls peps/$n); do
          sed "s/insert_common_here/$(echo $COMMON |sed 's_/_\\/_g')/g" $COMMON/min_eq_template.conf |sed "s|insert_prod_here|$prod|g" |sed "s|insert_steps_here|${steps}|g" > $n/$prod.conf

          sed "s/insert_nodes_here/$nodes/g" $COMMON/pbs.sh |sed "s/insert_name_here/prod${prod}_trial${n}/g" |sed "s/insert_time_here/${walltime}/g" |sed "s/insert_prod_here/${prod}/g" |sed "s/insert_queue_here/${queue}/g" > peps/$n/$l/pbs${prod}.sh

          cd peps/$n/$l
          qsub pbs${prod}.sh
          cd ..
     done
done
