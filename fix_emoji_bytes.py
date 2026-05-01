"""
Fix remaining broken emoji byte sequences in ISO-8859-1 JSP files.
These are UTF-8 emoji bytes that were stored raw in an ISO-8859-1 file.
We replace each UTF-8 byte sequence with the correct HTML numeric entity.
"""
import glob

base = r'C:\Users\conta\eclipse-workspace\Sis-gestao-fretes\src\main\webapp'
files = glob.glob(base + r'\**\*.jsp', recursive=True)
files += [f for f in glob.glob(base + r'\*.jsp') if f not in files]

# Map: UTF-8 bytes of emoji -> HTML entity replacement (as bytes)
REPLACEMENTS = [
    # Emojis with variation selector FE0F (EF B8 8F) - order matters: longest first
    (b'\xf0\x9f\x97\x91\xef\xb8\x8f', b'&#128465;'),   # 🗑️
    (b'\xe2\x9c\x8f\xef\xb8\x8f',     b'&#9999;'),      # ✏️
    (b'\xe2\x9a\xa0\xef\xb8\x8f',     b'&#9888;'),      # ⚠️
    (b'\xe2\x9c\x85\xef\xb8\x8f',     b'&#9989;'),      # ✅ (with selector)
    # Emojis without variation selector
    (b'\xf0\x9f\x8f\xa2',             b'&#127970;'),    # 🏢
    (b'\xf0\x9f\x94\x8d',             b'&#128269;'),    # 🔍
    (b'\xf0\x9f\x9a\x9b',             b'&#128667;'),    # 🚛
    (b'\xf0\x9f\x9a\x9a',             b'&#128666;'),    # 🚚
    (b'\xf0\x9f\x91\xa4',             b'&#128100;'),    # 👤
    (b'\xf0\x9f\x93\x8a',             b'&#128202;'),    # 📊
    (b'\xf0\x9f\x93\x85',             b'&#128197;'),    # 📅
    (b'\xf0\x9f\x93\xa6',             b'&#128230;'),    # 📦
    (b'\xf0\x9f\x9a\x80',             b'&#128640;'),    # 🚀
    (b'\xf0\x9f\x9a\xaa',             b'&#128682;'),    # 🚪
    (b'\xf0\x9f\x92\xbe',             b'&#128190;'),    # 💾
    (b'\xe2\x9c\x85',                 b'&#9989;'),      # ✅
    (b'\xef\xb8\x8f',                 b''),             # FE0F variation selector - remove leftover
]

fixed = 0
for path in files:
    with open(path, 'rb') as f:
        data = f.read()
    original = data
    for old, new in REPLACEMENTS:
        data = data.replace(old, new)
    if data != original:
        with open(path, 'wb') as f:
            f.write(data)
        print('FIXED:', path)
        fixed += 1
    else:
        print('OK   :', path)

print(f'\nTotal corrigidos: {fixed}')
