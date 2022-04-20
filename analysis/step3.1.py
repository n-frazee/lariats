# @Author: nfrazee
# @Date:   2019-05-16T10:20:15-04:00
# @Last modified by:   nfrazee
# @Last modified time: 2019-05-17T11:17:53-04:00
# @Comment:


import sys
from statistics import *

file_loc=sys.argv[1]
outfilename=sys.argv[2]
cluster_num=int(sys.argv[3])
cluster_perc=float(sys.argv[4])
data_list=[]
cluster_list=[]
out_list=[]
cluster_per=float(0)
cluster_data=[]
for n in range(0,cluster_num):
    cluster_list.append([n,int(0)])

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
        cluster_list[int(x[3])][1]+=1/(len(data_list))
    # Sorts the list by probability; lowest to highest
    s_cluster_list=sorted(cluster_list, key=lambda cluster: cluster[1])
    # Reverses the list
    rs_cluster_list=list(reversed(s_cluster_list))
    cluster_data=rs_cluster_list
    cluster_per=float(0)
    # Adding structure numbers to the list of outputs until the percentage
    # is > 40
    for x in rs_cluster_list:
        out_list.append(x[0])
        cluster_per+=x[1]
        if cluster_per > cluster_perc:
            break



    outfile=open(outfilename,'w')
    outfile.write("# percent: "+str(cluster_perc)+"     Number of clusters: "+str(len(out_list))+"\n")
    outfile.write("# ")
    for x in out_list:
        outfile.write(str(x)+" ")
    outfile.write("\n")
    count=0
    for y in cluster_data:
        if count==0:
            cluster_data[count].append(y[1])
        else:
            cluster_data[count].append(y[1]+cluster_data[count-1][2])
        outfile.write(str(count)+"  "+str(y[0])+"  "+str(y[1])+"  "+str(y[2])+"\n")
        count+=1

    outfile.close

    return None

if __name__ == "__main__":
    main()
