# @Author: nfrazee
# @Date:   2021-11-04T10:44:31-04:00
# @Last modified by:   nfrazee
# @Last modified time: 2021-11-04T11:24:00-04:00
# @Comment:


import sys
import random

num = int(sys.argv[1])
max = int(sys.argv[2]) + 1

rand_list = []

for x in range(num):
    rnum = random.randrange(1, max)
    while str(rnum) in rand_list:
        rnum = random.randrange(1, max)
    rand_list.append(str(rnum))

print(' '.join(rand_list))
