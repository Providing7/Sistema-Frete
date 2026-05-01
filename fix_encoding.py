import os, glob

base = r'C:\Users\conta\eclipse-workspace\Sis-gestao-fretes\src\main\webapp'
files = glob.glob(base + r'\**\*.jsp', recursive=True)
files += [f for f in glob.glob(base + r'\*.jsp') if f not in files]

def to_html_entity(ch):
    return '&#{};'.format(ord(ch))

fixed_count = 0
for path in files:
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    # Fix mojibake: reverse the double-encoding
    try:
        content = content.encode('latin-1').decode('utf-8')
    except Exception:
        pass  # already correct or can't fix
    # Update charset declarations
    content = content.replace('charset=UTF-8', 'charset=ISO-8859-1')
    content = content.replace('charset="UTF-8"', 'charset="ISO-8859-1"')
    # Encode to ISO-8859-1, replacing unencodable chars (emojis etc) with HTML entities
    result = []
    for ch in content:
        try:
            ch.encode('iso-8859-1')
            result.append(ch)
        except UnicodeEncodeError:
            result.append(to_html_entity(ch))
    content = ''.join(result)
    with open(path, 'w', encoding='iso-8859-1') as f:
        f.write(content)
    print('DONE:', path)
    fixed_count += 1

print(f'\nTotal: {fixed_count} arquivo(s) convertido(s) para ISO-8859-1')
