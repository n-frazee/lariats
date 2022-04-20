# @Author: nfrazee
# @Date:   2022-03-15T11:33:47-04:00
# @Last modified by:   nfrazee
# @Last modified time: 2022-04-13T14:21:37-04:00
# @Comment:


mol load psf initial.psf dcd min.dcd
[atomselect top all] writepdb opt.pdb

exit
