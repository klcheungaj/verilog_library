
import sys
from pathlib import Path

def to_int(value: float):
    value = max(0, min(value, 1))
    return int(round(value * 255))
    
if __name__ == '__main__':
    cube = Path(sys.argv[1]).stem
    out = open(f'{cube}.csv', "w")
    with open(f'{cube}.cube') as f: 
        size = 0
        low = [0,0,0]
        high = [1,1,1]
        for line in f:
            s = line.split()
            if len(s) == 0:
                continue

            # print(str)
            if s[0] == 'DOMAIN_MIN':
                low = [float(s[1]), float(s[2]), float(s[3])] 
            elif  s[0] == 'DOMAIN_MAX':
                high = [float(s[1]), float(s[2]), float(s[3])] 
            elif  s[0] == 'LUT_3D_SIZE':
                size = int(s[1])
            elif len(s) == 3 and size != 0:
                b = float(s[0])
                g = float(s[1])
                r = float(s[2])
                out.write(str(to_int(b)) + ",")
                out.write(str(to_int(g)) + ",")
                out.write(str(to_int(r)) + "\n")
    out.close()