# @Author: nfrazee
# @Date:   2018-11-02T10:29:42-04:00
# @Last modified by:   nfrazee
# @Last modified time: 2019-05-23T08:50:59-04:00
# @Comment:


# VMD manual
# https://www.ks.uiuc.edu/Research/vmd/vmd-1.9.1/ug.pdf

# set the pH to the system argument
set structure [lindex $argv 0]
set input [lindex $argv 1]
set output [lindex $argv 2]

# Open to read the clusters
set file_name "step3/top_clusters.dat"
set input_file [open $file_name r]
set file_data [read $input_file]
# Close the file
close $input_file

set data [split $file_data "\n"]
set cluster_list [lindex $data 1]

set cluster_list [lreplace $cluster_list 0 0]

# Load the trajectory.
set current [mol new $structure waitfor all]
foreach n $cluster_list {
     mol addfile "$input${n}.pdb" $current waitfor all
}

set n [molinfo $current get numframes]

animate write dcd $output beg 0 end [expr $n-1] waitfor all

exit
