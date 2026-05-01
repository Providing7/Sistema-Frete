with open(r'src\main\webapp\WEB-INF\views\login.jsp', 'rb') as f:
    data = f.read()

idx = data.find(b'Gest')
if idx >= 0:
    chunk = data[idx:idx+20]
    print('Bytes:', [hex(b) for b in chunk])
    print('ISO-8859-1:', chunk.decode('iso-8859-1'))
    try:
        print('UTF-8:', chunk.decode('utf-8'))
    except Exception as e:
        print('UTF-8 fail:', e)

# Also check the page directive
line1 = data[:200].decode('iso-8859-1')
print('\nFirst 200 chars:\n', line1)
