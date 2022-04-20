# @Author: nfrazee
# @Date:   2022-03-15T11:31:17-04:00
# @Last modified by:   nfrazee
# @Last modified time: 2022-04-14T10:41:51-04:00
# @Comment:


package require solvate

solvate initial.psf opt.pdb -o water/solvate -minmax {{-20 -20 -20} {20 20 20}}

solvate initial.psf opt.pdb -o octanol/solvate -minmax {{-20 -20 -20} {20 20 20}} -spsf /media/bak12/nfrazee/teamwork/lariats/common/small_octanol.psf -spdb /media/bak12/nfrazee/teamwork/lariats/common/small_octanol.pdb -ws 81 -ks "name O1"

exit
