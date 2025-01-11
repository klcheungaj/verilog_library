
import sys
from pathlib import Path
import argparse
from os import listdir
from os.path import isfile, join
import io
from shutil import copyfileobj

def to_int(value: float, lo: float, hi: float, color_depth: int):
    value = max(lo, min(value, hi))
    return int(round(value * ((1 << color_depth) - 1)))

def convert(infile, outdir, outname, color_depth):
    # out = open(f'outfile', "w")
    out = io.StringIO("some initial text data")
    with open(infile) as f: 
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
                try:
                    b = float(s[0])
                    g = float(s[1])
                    r = float(s[2])
                except:
                    continue
                out.write(str(to_int(b, low[0], high[0], color_depth)) + ",")
                out.write(str(to_int(g, low[1], high[1], color_depth)) + ",")
                out.write(str(to_int(r, low[2], high[2], color_depth)) + "\n")
    
    subdir = join(outdir, str(size))
    Path(subdir).mkdir(parents=True, exist_ok=True)
    with open(join(subdir, outname), 'w') as fd:
        fd.write(out.getvalue())
        # copyfileobj(out, fd)

def main(args):
    parser = argparse.ArgumentParser()
    parser.add_argument("--indir", help="input directory of .cube files", default="cubes")
    parser.add_argument("--outdir", help="output directory of converted .cube files. Files of different size will be put into different subdirectory", default="cubes")
    parser.add_argument("-d", "--color_depth", type=int, default=8, help="color depth of converted color")
    args = parser.parse_args()
    Path(args.outdir).mkdir(parents=True, exist_ok=True)

    files = listdir(args.indir)
    for f in files:
        relpath = join(args.indir, f)
        if (not isfile(relpath)) or (Path(f).suffix not in ['.cube', '.CUBE']):
            continue
        print(join(args.indir, f))
        convert(relpath, args.outdir, Path(f).stem + ".csv", args.color_depth)

if __name__ == '__main__':
    main(sys.argv)
    