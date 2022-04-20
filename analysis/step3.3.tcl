# @Author: nfrazee
# @Date:   2019-04-08T12:30:23-04:00
# @Last modified by:   nfrazee
# @Last modified time: 2019-05-23T14:37:28-04:00
# @Comment:



# Retrieve 4 Sets of Cartesian Coordinates Then
# Call Above Calculation Procedure to Calculate Dihedral Angles (trajectory)
proc calc {atom1 atom2 atom3 atom4} {
    set 12 [vecsub $atom2 $atom1]
    set 21 [vecsub $atom1 $atom2]
    set 23 [vecsub $atom3 $atom2]
    set 32 [vecsub $atom2 $atom3]
    set 34 [vecsub $atom4 $atom3]
    set n1 [veccross $12 $23]
    set n2 [veccross $23 $34]
    set cosangle [expr [vecdot $n1 $n2] / ([veclength $n1] * [veclength $n2])]
    set angle [expr {180 * acos($cosangle) / 3.14159265358}]
    set sign [vecdot [veccross $n1 $n2] $23]
    if { $sign < 0 } {
	set angle [expr {0-$angle}]
    } elseif { $sign == 0 } {
	set angle 180.0
    }
    return $angle
}
set outputname [lindex $argv 0]
set structure [lindex $argv 1]
set coords [lindex $argv 2]
set pep [mol new $structure waitfor all]
mol addfile $coords mol $pep waitfor all
set outputFile [open $outputname w]
set nr [llength [lsort -integer -unique [[atomselect $pep "protein"] get residue]]]
puts $outputFile "# resid       psi     omega     phi"
for { set rnum 1 } { $rnum < $nr } { incr rnum } {
     set xyz1 [lindex [[atomselect $pep "protein and resid $rnum and name N"] get {x y z}] 0 ]
     set xyz2 [lindex [[atomselect $pep "protein and resid $rnum and name CA"] get {x y z}] 0 ]
     set xyz3 [lindex [[atomselect $pep "protein and resid $rnum and name C"] get {x y z}] 0 ]
     set xyz4 [lindex [[atomselect $pep "protein and resid [expr {$rnum + 1}] and name N"] get {x y z}] 0 ]
     set xyz5 [lindex [[atomselect $pep "protein and resid [expr {$rnum + 1}] and name CA"] get {x y z}] 0 ]
     set xyz6 [lindex [[atomselect $pep "protein and resid [expr {$rnum + 1}] and name C"] get {x y z}] 0 ]
     set psi [calc $xyz1 $xyz2 $xyz3 $xyz4]
     set omega [calc $xyz2 $xyz3 $xyz4 $xyz5]
     set phi [calc $xyz3 $xyz4 $xyz5 $xyz6]
     puts $outputFile [format "%6s %10.1f %7.1f %7.1f" $rnum $psi $omega $phi]
}
close $outputFile
