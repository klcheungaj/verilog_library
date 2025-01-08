
import inspect

fr=0xFF/255
fg=0xBA/255
fb=0xF2/255
c000=0xFB
c001=0x7C
c010=0xF8
c011=0xE7
c100=0x5A
c101=0x33
c110=0x9A
c111=0x0D
## ecpect 0x69
print(f"fractional part of red is: {fr}")
print(f"fractional part of green is: {fg}")
print(f"fractional part of blue is: {fb}")

c00 = (c000 * (1 - fr) +  c001 * fr)
c01 = (c010 * (1 - fr) +  c011 * fr)
c10 = (c100 * (1 - fr) +  c101 * fr)
c11 = (c110 * (1 - fr) +  c111 * fr)
c0 = c00 * (1-fg) + c01 * fg
c1 = c100 * (1-fg) + c11 * fg
c = c0 * (1-fb) + c1 * (fb)

def retrieve_name(var):
    callers_local_vars = inspect.currentframe().f_back.f_locals.items()
    return [var_name for var_name, var_val in callers_local_vars if var_val is var]

pt = [c00, c01, c10, c11, c0, c1, c]
for p in pt:
    print(f"value at point {retrieve_name(p)[0]} is: {p}. Hex: {hex(int(p))}")
