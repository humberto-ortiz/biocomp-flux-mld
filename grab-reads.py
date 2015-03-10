import fileinput

pos = 999

transcripts = []
for line in open("sample.txt"):
    transcripts.append(line.split()[0])

#print transcripts

for line in fileinput.input():
    fields = line.split(":")
    if len(fields) > 2 and fields[2] in transcripts:
        pos = 0

    if pos < 4:
        print line,
        pos += 1

    
