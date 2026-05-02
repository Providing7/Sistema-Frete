"""
Second pass: fix broken HTML entities that resulted from cp1252 emoji mojibake.
Files are already ISO-8859-1 with correct Portuguese text, but emojis were
encoded as wrong &#NNN; sequences. This script:
  1. Reads each file as ISO-8859-1
  2. Unescapes all &#NNN; entities -> gets the cp1252 mojibake unicode string
  3. Re-encodes as cp1252 bytes then decodes as utf-8 to recover original emoji chars
  4. Converts non-ISO-8859-1 chars to proper &#NNN; HTML entities
  5. Saves back as ISO-8859-1
"""
import os, glob, re, html

base = r'C:\Users\conta\eclipse-workspace\Sis-gestao-fretes\src\main\webapp'
files = glob.glob(base + r'\**\*.jsp', recursive=True)
files += [f for f in glob.glob(base + r'\*.jsp') if f not in files]

def fix_content(content):
    # Unescape &#NNN; entities so we have a plain unicode string
    # html.unescape handles &amp; &#...; etc.
    content = html.unescape(content)

    # Now try to fix the cp1252 mojibake for high codepoints
    # Strategy: iterate chars, if a char is >= 0x80 and can be encoded as cp1252,
    # collect a run and try to decode as utf-8
    result = []
    i = 0
    chars = list(content)
    while i < len(chars):
        ch = chars[i]
        cp = ord(ch)
        # Try to build a run of cp1252-encodable high chars
        if cp >= 0x80:
            run = []
            j = i
            while j < len(chars) and ord(chars[j]) >= 0x80:
                try:
                    b = chars[j].encode('cp1252')
                    run.append(b[0])
                    j += 1
                except (UnicodeEncodeError, IndexError):
                    break
            if run:
                raw = bytes(run)
                # Try to decode run as utf-8
                try:
                    decoded = raw.decode('utf-8')
                    # success - add decoded chars
                    for dc in decoded:
                        try:
                            dc.encode('iso-8859-1')
                            result.append(dc)
                        except UnicodeEncodeError:
                            result.append('&#{};'.format(ord(dc)))
                    i = j
                    continue
                except UnicodeDecodeError:
                    pass
                # Could not decode full run - try partial from start
                # Just encode each char individually
                for b in raw:
                    c = chr(b)
                    try:
                        c.encode('iso-8859-1')
                        result.append(c)
                    except UnicodeEncodeError:
                        result.append('&#{};'.format(b))
                i = j
                continue
        # Normal char
        try:
            ch.encode('iso-8859-1')
            result.append(ch)
        except UnicodeEncodeError:
            result.append('&#{};'.format(cp))
        i += 1
    return ''.join(result)

fixed_count = 0
for path in files:
    with open(path, 'r', encoding='iso-8859-1') as f:
        content = f.read()
    fixed = fix_content(content)
    with open(path, 'w', encoding='iso-8859-1') as f:
        f.write(fixed)
    print('DONE:', path)
    fixed_count += 1

print(f'\nTotal: {fixed_count} arquivo(s) corrigidos')
