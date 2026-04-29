@echo off
REM Script de build manual para quando o Eclipse não compilar automaticamente

echo.
echo ========================================
echo   Compilando projeto Sis-gestao-fretes
echo ========================================
echo.

REM Verificar se a pasta build/classes existe
if not exist "build\classes" mkdir "build\classes"

REM Limpar classes antigas
echo [1/4] Limpando classes antigas...
del /s /q build\classes\*.class 2>nul

REM Gerar lista de arquivos .java
echo [2/4] Localizando arquivos fonte...
dir /s /b /a-d "src\main\java\br\com\gestaofretes\*.java" > "%TEMP%\sources.txt"

REM Compilar
echo [3/4] Compilando...
"C:\Program Files\Amazon Corretto\jdk1.8.0_482\bin\javac.exe" ^
  -encoding UTF-8 ^
  -source 1.8 ^
  -target 1.8 ^
  -cp "C:\Users\conta\Downloads\apache-tomcat-9.0.117-windows-x64\apache-tomcat-9.0.117\lib\servlet-api.jar;src\main\webapp\WEB-INF\lib\postgresql-42.7.10.jar" ^
  -d "build\classes" ^
  @"%TEMP%\sources.txt"

if errorlevel 1 (
    echo.
    echo [ERRO] Compilacao falhou!
    pause
    exit /b 1
)

REM Copiar recursos
echo [4/4] Copiando recursos...
copy /Y "src\main\java\db.properties" "build\classes\db.properties" >nul 2>&1

echo.
echo ========================================
echo   Build concluido com sucesso!
echo ========================================
echo.
echo Arquivos .class gerados em: build\classes
echo.

pause
