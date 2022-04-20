# @Author: nfrazee
# @Date:   2022-04-13T11:33:10-04:00
# @Last modified by:   nfrazee
# @Last modified time: 2022-04-13T11:59:19-04:00
# @Comment:



if [ $# -eq 0 ]; then echo run like this:
echo test.sh {name of file} {column number starting with 1}
exit 0
fi


cut -d ' ' -f $2-$2 $1 > bsadkjfaijd.tmp

# Find number of values
numframes=$(awk 'BEGIN{frames=0} {if($1 != "#" && $1 != "" ) frames++} END {print frames} ' bsadkjfaijd.tmp)
# Find the average
mean=$(awk -v numframes=$numframes 'BEGIN{tot=0} {if($1 != "#" && $1 != "" ) tot+=$1 } END {avg = tot / numframes; print avg}' bsadkjfaijd.tmp)
# Find standard error
sterr=$(awk -v numframes=$numframes -v mean=$mean 'BEGIN{vari=0} {if($1 != "#" && $1 != "" ) vari+=(($1 - mean) ^ 2)} END {out =  (vari ^ (1 /2)) / numframes; print out}' bsadkjfaijd.tmp)


echo $numframes $mean $sterr
