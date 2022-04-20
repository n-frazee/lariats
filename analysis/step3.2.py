# @Author: nfrazee
# @Date:   2019-05-16T10:20:15-04:00
# @Last modified by:   nfrazee
# @Last modified time: 2019-05-22T14:17:37-04:00
# @Comment: This takes in the cluster of interest and outputs all frames that
# are associated with the cluster into a format that can be used by subsetter in
# LOOS


import sys
from statistics import *

file_loc=sys.argv[1]
cluster_id=int(sys.argv[2])
data_list=[]
out_list=[]


def open_file(filename,listGiven):
    """"""

    try:
        filein=open(filename,'r')
    except IOError:
        print("file not found")

    for x in filein:
        if x[0] != "#":
            listGiven.append(x.split())
    filein.close()

    return None


def main():

    open_file(file_loc,data_list)
    for x in data_list:
        if int(x[3])==cluster_id:
            out_list.append(x[2])
    out=""
    for y in out_list:
        out+=y+":"+y+","
    print(out[:len(out)-1])
    return None

if __name__ == "__main__":
    main()
