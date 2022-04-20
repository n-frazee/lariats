# @Author: nfrazee
# @Date:   2022-04-20T10:41:04-04:00
# @Last modified by:   nfrazee
# @Last modified time: 2022-04-20T11:52:29-04:00
# @Comment:



PROJ=`pwd`
COMMON="$PROJ/common"

# Number of centroids for clustering
cluster_num=50
# Percentage of structures attributed to the custers
cluster_perc=.4


for n in $(seq 1 16); do
     for l in $(ls peps/$n); do
          for s in octanol water; do
               if [ -f peps/$n/$l/min.dcd ]; then

#echo "Performing the k-means clustering on the merged trajectory..."
cluster-structures.py step1.2.psf 'segid=="PROT"' $cluster_num step3/cluster step2.dcd > step3/cluster.dat
#echo "Finding the most represented clusters..."
python3 step3.1.py step3/cluster.dat step3/top_clusters.dat $cluster_num $cluster_perc
#echo "Writing the average structures to step3/top_clusters.dcd"
vmd -dispdev text -e step3.2.tcl -args step1.1.psf step3/cluster-centroid- step3/top_clusters.dcd >> step3.log 2>&1
top_clusters="$(awk '{if($1=="#" && $2!="percent:") for (i=2; i<=NF; i++) printf FS$i; print NL}' step3/top_clusters.dat)"
#echo "Done!\n\nNow analyzing each best cluster..."
count=1

for i in $top_clusters; do
     echo "Cluster: $i"
     range=$(python3 step3.2.py step3/cluster.dat $i)
     subsetter -r $range step3/centroid_$i step1.2.psf step2.dcd >> step3.log
     rmsd2ref --align 'name=~"^(C|O|N|CA)$"' --rmsd 'name =~ "^(C|O|N|CA)$"' --target step3/cluster-centroid-${i}.pdb step1.2.psf step3/centroid_$i.dcd > step3/reference_$i.dat 2>> step3.log
     test="f"; score=0; breaks=0
     while [ $test = "f" ]; do
          breaks=$(($breaks+1))
          frame=$(awk -v score=$score 'BEGIN {var=100} {if ($1!="#" && $2<var && $2>score) {var=$2; best=$1}} END {print best}' step3/reference_$i.dat)
          score=$(awk -v score=$score 'BEGIN {var=100} {if ($1!="#" && $2<var && $2>score) var=$2} END {print var}' step3/reference_$i.dat)
          subsetter -r $frame:$frame step3/structure_$i step1.2.psf step3/centroid_$i.dcd >> step3.log 2>&1
          vmd -dispdev text -eofexit < step3.3.tcl -args step3/dihedral_$i.dat step1.2.psf step3/structure_$i.pdb >> step3.log 2>&1
          test="$(awk 'BEGIN {test="t"} {if ($1!="#" && $3<150 && $3>-150) test="f"} END {print test}' step3/dihedral_$i.dat)"
     done
     echo "   Frames checked: $breaks"
     if [ -d step4/$count ]; then rm -r step4/$count; fi; mkdir step4/$count
     cp step3/structure_$i.pdb step4/$count/step3.1.pdb
     count=$(($count+1))
     echo "Done!\n"
done

rm step3/structure_*.dcd
echo "\nWriting the best representative structure of each cluster to step3/structures.dcd..."
vmd -dispdev text -e step3.2.tcl -args step1.2.psf step3/structure_ step3/structures.dcd >> step3.log 2>&1
echo "Done!"

echo "Do you want to visualize your systems after solvating? (y/n)"; read vis

echo "\nSolvating..."
first=1; last=1; while [ -d step4/$last ]; do last=$(($last+1)); done; last=$(($last-1))
for i in $(seq $first $last); do
     cp step4.conf step4/$i
     vmd -dispdev text -eofexit < step3.4.tcl -args step4/$i >> step3.log 2>&1
     cat step4/$i/step4.log >> step3.log; rm step4/$i/step4.log
     dx=$(awk '{ if($1 == "dx") print $3}' temp.dat)
     dy=$(awk '{ if($1 == "dy") print $3}' temp.dat)
     dz=$(awk '{ if($1 == "dz") print $3}' temp.dat)
     sed -i "s/insert_dx_here/$dx/g" step4/$i/step4.conf
     sed -i "s/insert_dy_here/$dy/g" step4/$i/step4.conf
     sed -i "s/insert_dz_here/$dz/g" step4/$i/step4.conf

     cx=$(awk '{ if($1 == "center") print $2}' temp.dat)
     cy=$(awk '{ if($1 == "center") print $3}' temp.dat)
     cz=$(awk '{ if($1 == "center") print $4}' temp.dat)
     sed -i "s/insert_cx_here/$cx/g" step4/$i/step4.conf
     sed -i "s/insert_cy_here/$cy/g" step4/$i/step4.conf
     sed -i "s/insert_cz_here/$cz/g" step4/$i/step4.conf
     rm temp.dat
if [ $vis = "y" ]; then vmd step4/$i/step4.psf step4/$i/step4.pdb; fi
done
