@echo off
title Subir a GitHub - Optimum_WWindows
cd /d "%~dp0"

echo ===================================================================
echo    SUBIENDO PROYECTO A GITHUB (https://github.com/xycnww/Optimum_WWindows)
echo ===================================================================
echo.
echo Si te aparece una ventana emergente de GitHub en el navegador,
echo pulsa 'Sign in with your browser' para autorizar la subida.
echo.

"C:\Program Files\Git\cmd\git.exe" push -u origin main

echo.
echo ===================================================================
pause
