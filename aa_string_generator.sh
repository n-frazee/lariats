# @Author: nfrazee
# @Date:   2021-11-02T16:14:20-04:00
# @Last modified by:   nfrazee
# @Last modified time: 2021-12-14T15:59:35-05:00
# @Comment:

mkdir -p libs
lib=1
for leu8 in LEU DLEU; do
     for x2 in MLU DMLU; do
          for pro1 in PRO DPRO; do
               for pro9 in PRO DPRO; do
                    for x4 in LEU DLEU MLU DMLU; do
                         for x5 in LEU DLEU MLU DMLU; do
                              for x6 in LEU DLEU MLU DMLU; do
                                   for x7 in ALA DALA MAA DMAA; do
                                        echo "$pro1 $x2 THR $x4 $x5 $x6 $x7 $leu8 $pro9" >> libs/$lib.txt
                                   done
                              done
                         done
                    done
                    lib=$(($lib + 1))
               done
          done
     done
done
