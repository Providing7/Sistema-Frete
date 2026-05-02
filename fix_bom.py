import glob

base = r'C:\Users\conta\eclipse-workspace\Sis-gestao-fretes\src\main\webapp'
files = glob.glob(base + r'\**\*.jsp', recursive=True)
files += [f for f in glob.glob(base + r'\*.jsp') if f not in files]

for path in files:
    with open(path, 'r', encoding='iso-8859-1') as f:
        content = f.read()
    # Remove BOM entity and actual BOM char if present
    cleaned = content.replace('&#65279;', '').replace('\ufeff', '')
    if cleaned != content:
        with open(path, 'w', encoding='iso-8859-1') as f:
            f.write(cleaned)
        print('CLEANED BOM:', path)
    else:
        print('OK:', path)
