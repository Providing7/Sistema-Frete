import glob, re

base = r'C:\Users\conta\eclipse-workspace\Sis-gestao-fretes\src\main\webapp'
files = glob.glob(base + r'\**\*.jsp', recursive=True)

# Look for raw UTF-8 multibyte sequences that shouldn't be in ISO-8859-1 files
# Specifically: F0 (4-byte UTF-8 start) and E2 followed by high bytes (3-byte emoji starts)
# Portuguese chars like E3(a~) E7(c,) ED(i') etc are expected and OK

EMOJI_STARTS = {0xF0, 0xE2}  # common emoji UTF-8 start bytes
# Allow list: Portuguese characters that legitimately appear in ISO-8859-1
ALLOWED = {0xC3, 0xC9, 0xC0, 0xC1, 0xC2, 0xC4, 0xC7, 0xCA, 0xCB,
           0xCC, 0xCD, 0xCE, 0xCF, 0xD3, 0xD4, 0xD5, 0xD9, 0xDA, 0xDB,
           0xE0, 0xE1, 0xE2, 0xE3, 0xE4, 0xE7, 0xE8, 0xE9, 0xEA,
           0xEC, 0xED, 0xEE, 0xEF, 0xF3, 0xF4, 0xF5, 0xF9, 0xFA, 0xFB,
           0xFC, 0xBF, 0xA0, 0xA9, 0xB3, 0xBA, 0xAA}

problems = 0
for path in files:
    with open(path, 'rb') as f:
        data = f.read()
    # Find sequences that look like UTF-8 emoji bytes (F0 9x xx xx)
    bad_positions = []
    for i, b in enumerate(data):
        if b == 0xF0 and i+3 < len(data):
            # Check if next bytes look like UTF-8 continuation (0x80-0xBF)
            if all(0x80 <= data[i+j] <= 0xBF for j in range(1, 4)):
                ctx = data[max(0,i-10):i+20]
                bad_positions.append((i, ctx))
    if bad_positions:
        problems += 1
        print(f'BROKEN BYTES in {path[len(base):]}:')
        for pos, ctx in bad_positions[:3]:
            print(f'  pos {pos}: {ctx}')
    else:
        print(f'OK: {path[len(base):]}')

print(f'\n{"Tudo OK!" if problems == 0 else str(problems) + " arquivo(s) com bytes brutos de emoji"}')
