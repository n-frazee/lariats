# @Author: nfrazee
# @Date:   2021-11-02T16:15:10-04:00
# @Last modified by:   nfrazee
# @Last modified time: 2022-04-13T14:36:51-04:00
# @Comment:

PROJ=`pwd`
COMMON=`pwd`/common
# number of peptides from each library
num=5
for lib in $(seq 1 16); do
     # select x unique random numbers for lines between 1 and the number of lines in the file
     for line_num in $(seq 1 $(wc -l libs/$lib.txt |cut -f 1-1 -d ' ')); do
     #for line_num in $(python common/rand_lines.py $num $(wc -l libs/$lib.txt)); do
          echo "$lib $line_num"
          mkdir -p peps/$lib/$line_num
          echo "package require psfgen" > peps/$lib/$line_num/psfgen.tcl
          echo "resetpsf" >> peps/$lib/$line_num/psfgen.tcl
          echo "topology $COMMON/toppar/top_all36_cgenff.rtf" >> peps/$lib/$line_num/psfgen.tcl
          echo "topology $COMMON/toppar/top_all36_prot.rtf" >> peps/$lib/$line_num/psfgen.tcl
          echo "topology $COMMON/toppar/stream/prot/toppar_all36_prot_c36m_d_aminoacids.str" >> peps/$lib/$line_num/psfgen.tcl
          echo "topology $COMMON/toppar/stream/prot/toppar_all36_prot_modify_res.str" >> peps/$lib/$line_num/psfgen.tcl
          echo "topology $COMMON/toppar/top_all36_lariat_residues.rtf" >> peps/$lib/$line_num/psfgen.tcl
          echo "segment PROA {first ACP" >> peps/$lib/$line_num/psfgen.tcl

          count=1
          for res in $(head -n $line_num libs/$lib.txt | tail -n 1); do
               if [ $count -eq 3 ]; then
                    echo "pdb $COMMON/thr.pdb" >> peps/$lib/$line_num/psfgen.tcl
               else
                    echo "residue $count $res A" >> peps/$lib/$line_num/psfgen.tcl
               fi
               count=$(($count + 1))
          done
          echo "last NONE}" >> peps/$lib/$line_num/psfgen.tcl
          echo "patch LARI PROA:3 PROA:9" >> peps/$lib/$line_num/psfgen.tcl
          echo "coordpdb $COMMON/thr.pdb PROA" >> peps/$lib/$line_num/psfgen.tcl
          echo "regenerate angles dihedrals" >> peps/$lib/$line_num/psfgen.tcl
          echo "guesscoord" >> peps/$lib/$line_num/psfgen.tcl
          echo "writepdb initial.pdb" >> peps/$lib/$line_num/psfgen.tcl
          echo "writepsf initial.psf" >> peps/$lib/$line_num/psfgen.tcl
          echo "exit" >> peps/$lib/$line_num/psfgen.tcl


          cd peps/$lib/$line_num/

          vmd -dispdev text -e psfgen.tcl > /dev/null 2>&1

          cd $PROJ
     done
done
