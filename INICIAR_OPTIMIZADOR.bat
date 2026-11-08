@echo off
:: ===================================================================================
::  LAPTOP-OPTIMIZER-BIM - LANZADOR MAESTRO PARA PORTÁTILES
::  Ejecuta con elevación de Administrador y política de ejecución Bypass.
:: ===================================================================================
title Laptop-Optimizer-BIM - Suite de Rendimiento para Portatiles
cd /d "%~dp0"

echo ===================================================================
echo     INICIANDO LAPTOP-OPTIMIZER-BIM (MODO PORTABLE AUTOMATICO)
echo ===================================================================
echo Comprobando y solicitando privilegios de Administrador...

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Optimizador_Universal_Engine.ps1"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [AVISO] El optimizador se ejecuto o requirio aprobacion de Administrador.
    pause
)
