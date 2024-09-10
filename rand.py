import os
num = os.urandom(64)

# print(''.join('{:x}'.format(x) for x in num))
print(num.hex())