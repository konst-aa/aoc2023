# 1439 p2, close but no cigar

import functools

inp = open("06/input.txt").readlines()
time1 = map(int, inp[0].split(":")[1].split())
distance1 = map(int, inp[1].split(":")[1].split())


time2 = int("".join(inp[0].split(":")[1].split()))
distance2 = int("".join(inp[1].split(":")[1].split()))

def td(time,distance):
    counts = []
    for t, d in zip(time, distance):
        count = 0
        for i in range(t+1):
            res = i * (t - i)
            if res > d:
                count += 1
        counts.append(count)
    return counts

print(functools.reduce(lambda a, b: a * b, td(time1, distance1)))
print(functools.reduce(lambda a, b: a * b, td([time2], [distance2])))
