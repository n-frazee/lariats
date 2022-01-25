# @Author: nfrazee
# @Date:   2021-11-02T16:15:10-04:00
# @Last modified by:   nfrazee
# @Last modified time: 2021-12-16T15:38:01-05:00
# @Comment:

PROJ=`pwd`
COMMON=`pwd`/common
# number of peptides from each library
num=1
for lib in $(seq 1 16); do
     # select x unique random numbers for lines between 1 and the number of lines in the file
     for line_num in $(python common/rand_lines.py $num $(wc -l libs/$lib.txt)); do
          mkdir -p peps/$lib/$line_num
          echo "package require psfgen" > peps/$lib/$line_num/psfgen.tcl
          echo "resetpsf" >> peps/$lib/$line_num/psfgen.tcl
          echo "topology $COMMON/toppar/top_all36_cgenff.rtf" >> peps/$lib/$line_num/psfgen.tcl
          echo "topology $COMMON/toppar/top_all36_prot.rtf" >> peps/$lib/$line_num/psfgen.tcl
          echo "topology $COMMON/toppar/stream/prot/toppar_all36_prot_c36m_d_aminoacids.str" >> peps/$lib/$line_num/psfgen.tcl
          echo "topology $COMMON/toppar/stream/prot/toppar_all36_prot_modify_res.str" >> peps/$lib/$line_num/psfgen.tcl
          echo "topology $COMMON/toppar/top_all36_lariat_residues.rtf" >> peps/$lib/$line_num/psfgen.tcl
          echo "segment PROA {first NTER" >> peps/$lib/$lirunne_num/psfgen.tcl

          count=1
          for res in $(head -n $line_num libs/$lib.txt | tail -n 1); do
               if [ $count -eq 3 ]; then
                    echo "pdb $COMMON/thr.pdb" >> peps/$lib/$line_num/psfgen.tcl
               else
                    echo "residue $count $res A" >> peps/$lib/$line_num/psfgen.tcl
               fi
               count=$(($count + 1))
          done
          echo "last CTER}" >> peps/$lib/$line_num/psfgen.tcl
          echo "coordpdb $COMMON/thr.pdb PROA" >> peps/$lib/$line_num/psfgen.tcl
          echo "regenerate angles dihedrals" >> peps/$lib/$line_num/psfgen.tcl
          echo "guesscoord" >> peps/$lib/$line_num/psfgen.tcl
          echo "writepdb peps/$lib/$line_num/initial.pdb" >> peps/$lib/$line_num/psfgen.tcl
          echo "writepsf peps/$lib/$line_num/initial.psf" >> peps/$lib/$line_num/psfgen.tcl
          echo "" >> peps/$lib/$line_num/psfgen.tcl
          echo "package require solvate" >> peps/$lib/$line_num/psfgen.tcl
          # Change from padding to box size after measurng an actual lariat
          echo "solvate peps/$lib/$line_num/initial.psf peps/$lib/$line_num/initial.pdb -o peps/$lib/$line_num/wt -rotate -t 10" >> peps/$lib/$line_num/psfgen.tcl
          echo "" >> peps/$lib/$line_num/psfgen.tcl
          echo "solvate peps/$lib/$line_num/initial.psf peps/$lib/$line_num/initial.pdb -o peps/$lib/$line_num/oct -rotate -t 10 -spsf $COMMON/oct_box.psf -spdb $COMMON/oct_box.pdb -stop $COMMON/toppar/top_all36_cgenff.rtf" >> peps/$lib/$line_num/psfgen.tcl
          echo "" >> peps/$lib/$line_num/psfgen.tcl
          echo "package require autoionize" >> peps/$lib/$line_num/psfgen.tcl
          echo "autoionize -psf peps/$lib/$line_num/wt.psf -pdb peps/$lib/$line_num/wt.pdb - neutralize -o peps/$lib/$line_num/wt" >> peps/$lib/$line_num/psfgen.tcl
          echo "" >> peps/$lib/$line_num/psfgen.tcl
          echo "autoionize -psf peps/$lib/$line_num/oct.psf -pdb peps/$lib/$line_num/oct.pdb - neutralize -o peps/$lib/$line_num/oct" >> peps/$lib/$line_num/psfgen.tcl


     done
done
