# Correções Realizadas - Branch master-01

## Problema Identificado
O projeto não estava sendo deployado no Tomcat porque a pasta `build/classes` estava vazia - os arquivos `.class` não existiam.

## Causa Raiz
1. O `.gitignore` ignorava `/build/` inteiro, então os `.class` nunca eram versionados
2. Ao trocar de branch, a pasta ficava vazia
3. Alguns arquivos importantes estavam comentados:
   - `TipoCliente.java` - enum estava completamente comentado
   - `Cliente.java` - campo `tipo` e métodos `getTipo()/setTipo()` comentados
   - `StatusVeiculo.java` - tinha typo `EM_VIAJEM` em vez de `EM_VIAGEM`

## Soluções Aplicadas

### 1. Restaurados os arquivos comentados
- ✅ `TipoCliente.java` - enum descomentado
- ✅ `Cliente.java` - campo tipo e métodos restaurados
- ✅ `StatusVeiculo.java` - corrigido typo EM_VIAJEM → EM_VIAGEM

### 2. Compilação manual forçada
Compilados todos os 32 arquivos `.class` usando `javac` diretamente

### 3. Ajustado `.gitignore`
- Antes: ignorava `/build/` inteiro
- Depois: ignora apenas `*.class` mas mantém a estrutura de pastas

### 4. Criado script de build
Arquivo `build.bat` para recompilar manualmente quando necessário

## Como usar

### No Eclipse
1. **Project → Clean...** → selecione `Sis-gestao-fretes` → OK
2. O Eclipse deve recompilar automaticamente

### Manualmente (se o Eclipse falhar)
Execute o arquivo `build.bat` na raiz do projeto

### Após trocar de branch
Se a pasta `build/classes` ficar vazia novamente:
```bash
# Execute o build.bat ou:
git checkout <sua-branch>
# No Eclipse: Project → Clean...
```

## Verificação
Para confirmar que os `.class` existem:
```cmd
dir build\classes\br\com\gestaofretes /s /b | find /c ".class"
```
Deve retornar 32 arquivos.

## Status Final
✅ Projeto compilado com sucesso
✅ Front-end preservado (nenhum arquivo JSP foi alterado)
✅ 32 classes compiladas
✅ Pronto para deploy no Tomcat
