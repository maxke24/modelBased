def read_lp_file(file_path):
    lns = []
    with open(file_path, 'r') as f:
        lines = f.readlines()
    
    for line in lines:
        line = line.strip()

        parts = line.split()
        lns.append(parts)
        # print(parts)
    return lns

lines = []
file_path = 'schedule.lp'
data = read_lp_file(file_path)
for line in data:
    if line not in lines:
        lines.append(line)
print(lines)