import glob, sys

base = r'C:\Users\conta\eclipse-workspace\Sis-gestao-fretes\src\main\webapp'
files = glob.glob(base + r'\**\*.jsp', recursive=True)
files += [f for f in glob.glob(base + r'\*.jsp') if f not in files]

for path in files:
    with open(path, 'rb') as f:
        raw = f.read()
    text = raw.decode('iso-8859-1')
    has_charset = 'charset=ISO-8859-1' in text
    has_bom = '&#65279;' in text
    sample = ''
    for line in text.splitlines():
        if b'\xe3' in line.encode('iso-8859-1') or b'\xe7' in line.encode('iso-8859-1'):
            sample = line.strip()[:80]
            break
    name = path[len(base):]
    print('OK' if (has_charset and not has_bom) else 'PROBLEM', '|', name)
    if sample:
        sys.stdout.buffer.write(b'  -> ' + sample.encode('iso-8859-1') + b'\n')