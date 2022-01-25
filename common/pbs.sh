# @Author: nfrazee
# @Date:   2021-06-11T13:29:42-04:00
# @Last modified by:   nfrazee
# @Last modified time: 2021-06-16T10:28:04-04:00
# @Comment:

#!/bin/bash

#PBS -q insert_queue_here
#PBS -m ae
#PBS -M ncf0003@mix.wvu.edu
#PBS -N insert_name_here
#PBS -l nodes=insert_nodes_here:ppn=40
#PBS -l walltime=insert_time_here:00:00

##module load atomistic/namd/NAMD_Git-2020-01-02-ofi
module load namd/2.13_single_node
cd $PBS_O_WORKDIR

	charmrun +p$((insert_nodes_here*40)) $NAMD insert_prod_here.conf > insert_prod_here.log

exit 0

     nodetot=insert_nodes_here
     coresock=40
     ppn=$(((${coresock}/2)-1))
     N=$((2*${nodetot}*${ppn}))

     module purge

     module load lang/intel/2018
     module load libs/fftw/3.3.9_intel18
     ### load modified openmpi from NGD 4/1/21
     module load parallel/openmpi/3.1.4_intel18_tm

     ### set directory for job execution -- make this specific to your run
     cd $PBS_O_WORKDIR

     ### set charmrun and namd executables
     MD_NAMD=/scratch/jbmertz/binaries/NAMD_2.14_Source/Linux-x86_64-icc-smp/

     ### generate the nodelist for running across multiple nodes
     NODES=`pwd`/.nodelist
     cat $PBS_NODEFILE | perl -e 'while(<>) { chomp; $node{$_}++; } $num = keys %node; print "group main\n"; for (keys %node) { print "host $_ ++cpus $node{$_}\n"; }' > $NODES

     ### run your executable program
     procs=`echo "$N/$ppn" | bc`
     procspernode=`echo $procs/2 | bc`
     echo "procs: $procs with $procspernode on each node"
     mpirun --map-by ppr:$procspernode:node ${MD_NAMD}namd2 +setcpuaffinity +ppn${ppn} insert_prod_here.conf > insert_prod_here.log

     rm $NODES

     exit 0
