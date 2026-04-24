<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login — Gestão de Fretes</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f0f2f5;
               display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .box { background: white; padding: 40px; border-radius: 8px;
               box-shadow: 0 2px 10px rgba(0,0,0,0.1); width: 320px; }
        h2 { text-align: center; margin-bottom: 24px; color: #333; }
        input { width: 100%; padding: 10px; margin-bottom: 16px;
                border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        button { width: 100%; padding: 10px; background: #0066cc;
                 color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 15px; }
        button:hover { background: #0052a3; }
        .erro { color: red; text-align: center; margin-bottom: 12px; font-size: 14px; }
    </style>
</head>
<body>
    <div class="box">
        <h2>Gestão de Fretes</h2>

        <% if (request.getAttribute("erro") != null) { %>
            <div class="erro">${erro}</div>
        <% } %>

        <form method="post" action="${pageContext.request.contextPath}/login">
            <input type="text"     name="usuario"  placeholder="Usuário"  required />
            <input type="password" name="senha"    placeholder="Senha"    required />
            <button type="submit">Entrar</button>
        </form>
    </div>
</body>
</html>
