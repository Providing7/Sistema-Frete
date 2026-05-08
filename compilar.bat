@echo off
setlocal

set LIB=C:\Users\conta\eclipse-workspace\Sis-gestao-fretes\src\main\webapp\WEB-INF\lib
set SRC=C:\Users\conta\eclipse-workspace\Sis-gestao-fretes\src\main\java
set OUT=C:\Users\conta\eclipse-workspace\Sis-gestao-fretes\build\classes
set TOMCAT=C:\Users\conta\Downloads\apache-tomcat-9.0.117-windows-x64\apache-tomcat-9.0.117\lib\servlet-api.jar
set JAVAC="C:\Program Files\Amazon Corretto\jdk1.8.0_482\bin\javac.exe"

set CP=%LIB%\postgresql-42.7.10.jar;%LIB%\commons-beanutils-1.9.4.jar;%LIB%\commons-collections-3.2.2.jar;%LIB%\commons-collections4-4.4.jar;%LIB%\commons-digester-2.1.jar;%LIB%\commons-logging-1.2.jar;%LIB%\openpdf-1.3.32.jar;%LIB%\openpdf-fonts-extra-1.3.32.jar;%LIB%\jasperreports-6.21.5.jar;%LIB%\jasperreports-fonts-6.21.5.jar;%LIB%\slf4j-api-1.7.36.jar;%LIB%\slf4j-simple-1.7.36.jar;%TOMCAT%

dir /s /b "%SRC%\*.java" > "%TEMP%\fontes.txt"

%JAVAC% -encoding UTF-8 -source 8 -target 8 -cp "%CP%" -d "%OUT%" @"%TEMP%\fontes.txt"

if %ERRORLEVEL% == 0 (
    echo.
    echo ===== COMPILACAO OK =====
    dir /s /b "%OUT%\*.class" | find /c ".class"
    echo classes geradas.
) else (
    echo.
    echo ===== ERRO NA COMPILACAO =====
)

endlocal
pause
