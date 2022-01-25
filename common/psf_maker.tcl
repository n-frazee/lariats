# @Author: nfrazee
# @Date:   2021-10-26T10:06:07-04:00
# @Last modified by:   nfrazee
# @Last modified time: 2021-10-26T11:00:04-04:00
# @Comment:


set pdb [lindex $argv 0]
set name [string range $pdb 0 [expr [string length $pdb] - 5]]

package require psfgen
topology common/toppar/top_all36_prot.rtf
topology common/toppar/top_all36_cgenff.rtf
segment PROT {pdb $pdb}
#coordpdb $pdb PROT
#guesscoord
#writepdb gen${name}.pdb
#writepsf gen${name}.psf
