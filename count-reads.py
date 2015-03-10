import fileinput
from collections import defaultdict

counts = defaultdict(int)

for line in fileinput.input():
    fields = line.split(":")
    if len(fields) > 2 and fields[2].startswith("FBtr"):
        counts[fields[2]] += 1

pairs = [(v, k) for k, v in counts.iteritems()]

for v, k in sorted(pairs):
    print k, v
    
