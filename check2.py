import sys

files = [
    r'src\main\webapp\WEB-INF\views\clientes\lista.jsp',
    r'src\main\webapp\WEB-INF\views\motoristas\lista.jsp',
    r'src\main\webapp\WEB-INF\views\veiculos\lista.jsp',
    r'src\main\webapp\WEB-INF\views\dashboard.jsp',
    r'src\main\webapp\WEB-INF\views\_nav.jsp',
]

KEYWORDS = ('icon', 'alert', 'btn-sm', 'breadcrumb', 'stat-icon', 'logo-icon', 'h1>', 'h3>')

for path in files:
    with open(path, 'rb') as f:
        data = f.read()
    text = data.decode('iso-8859-1')
    print('=== ' + path + ' ===')
    for line in text.splitlines():
        s = line.strip()
        if s and any(k in s for k in KEYWORDS):
            sys.stdout.buffer.write(b'  ' + s[:110].encode('iso-8859-1', errors='replace') + b'\n')
    print()
