@echo off
title Subir a GitHub - Optimum_WWindows
cd /d "%~dp0"

echo ===================================================================
echo    SUBIENDO PROYECTO A GITHUB: https://github.com/xycnww/Optimum_WWindows
echo ===================================================================
echo.
echo [1/2] Sincronizando repositorio con tu cuenta de GitHub...
echo Si aparece una ventana emergente en tu navegador, pulsa 'Authorize'
echo para permitir que Git suba el codigo a tu cuenta.
echo.

"C:\Program Files\Git\cmd\git.exe" push -u origin main

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo -------------------------------------------------------------------
    echo [AVISO] Si recibiste un error 404 (Repository not found):
    echo 1. Asegurate de que el repositorio este creado en: https://github.com/new
    echo 2. Si lo creaste como 'optium_wwindows' o 'Optimum_WWindows',
    echo    puedes cambiar la URL escribiendo:
    echo    git remote set-url origin https://github.com/xycnww/TU_NOMBRE_EXACTO
    echo -------------------------------------------------------------------
)

echo.
echo ===================================================================
pause
