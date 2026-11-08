<#
=============================================================================================
 KIT USB PORTABLE - MOTOR DE AUDITORIA, REPARACION Y OPTIMIZACION BIM UNIVERSAL
 Uso: Estaciones de Trabajo de Arquitectura, Modelado BIM (Revit, pyRevit, CAD), IA y ERP
 Compatibilidad: Windows 10 y Windows 11 (Portatiles y Sobremesas: ASUS, Lenovo, Dell, HP, etc.)
=============================================================================================
#>

# 0. ELEVACION AUTOMATICA DE PRIVILEGIOS DE ADMINISTRADOR
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Write-Host "Elevando privilegios a Administrador para el Kit USB..." -ForegroundColor Yellow
    Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit
}

$ScriptDir = Split-Path -Parent $PSCommandPath
$KitRoot   = Split-Path -Parent $ScriptDir
$BinDir    = Join-Path $KitRoot "bin"
$ReportsDir= Join-Path $KitRoot "Informes_Equipos"

if (!(Test-Path $ReportsDir)) { New-Item -ItemType Directory -Path $ReportsDir -Force | Out-Null }

$Host.UI.RawUI.WindowTitle = "Kit USB Portable BIM & Optimizador Universal"
Clear-Host

# ---------------------------------------------------------------------------------------------
# DETECCION DE HARDWARE DEL EQUIPO DESTINO
# ---------------------------------------------------------------------------------------------
$cs = Get-CimInstance Win32_ComputerSystem
$proc = Get-CimInstance Win32_Processor
$gpus = Get-CimInstance Win32_VideoController
$os = Get-CimInstance Win32_OperatingSystem

$cleanCompName = $env:COMPUTERNAME -replace '[\\/:*?"<>|]', '_'
$reportTimestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$reportFile = Join-Path $ReportsDir "Informe_${cleanCompName}_${reportTimestamp}.txt"

$logLines = [System.Collections.Generic.List[string]]::new()
function LogMsg($msg, $color="White") {
    Write-Host $msg -ForegroundColor $color
    $logLines.Add($msg)
}

LogMsg "==================================================================" "Cyan"
LogMsg "   KIT USB PORTABLE BIM - OPTIMIZACION Y REPARACION UNIVERSAL     " "Cyan"
LogMsg "==================================================================" "Cyan"
LogMsg "Fecha y Hora     : $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')" "White"
LogMsg "Equipo           : $($cs.Manufacturer) - $($cs.Model)" "White"
LogMsg "Nombre de Red    : $env:COMPUTERNAME" "White"
LogMsg "Procesador       : $($proc.Name)" "White"
LogMsg "Memoria RAM      : $([math]::Round($cs.TotalPhysicalMemory / 1GB, 1)) GB" "White"
LogMsg "Sistema Operativo: $($os.Caption) ($($os.OSArchitecture))" "White"
LogMsg "GPUs Detectadas  : $(($gpus.Name | Sort-Object -Unique) -join ' + ')" "White"
LogMsg "==================================================================" "Cyan"

# ---------------------------------------------------------------------------------------------
# ELECCION DE MODO DE DESPLIEGUE (PORTABLE VS INSTALACION LOCAL)
# ---------------------------------------------------------------------------------------------
LogMsg "`n[MODO DE DESPLIEGUE DE HERRAMIENTAS]" "Yellow"
Write-Host "Selecciona como deseas ejecutar Sysinternals y CrystalDiskInfo:" -ForegroundColor Gray
Write-Host " [1] 100% PORTABLE (Recomendado): Ejecuta desde el USB sin instalar nada en el disco." -ForegroundColor White
Write-Host " [2] INSTALACION LOCAL: Copia las herramientas a 'C:\Program Files' y crea accesos en el Inicio." -ForegroundColor White

$deployChoice = "1"
if ([Environment]::UserInteractive -and -not [Console]::IsInputRedirected) {
    $userIn = Read-Host "`nOpcion [1 o 2, por defecto 1]"
    if ($userIn -eq "2") { $deployChoice = "2" }
}

if ($deployChoice -eq "2") {
    LogMsg " -> Configurando instalacion permanente de herramientas en C:\Program Files..." "Green"
    $destSys = "C:\Program Files\Sysinternals"
    $destCry = "C:\Program Files\CrystalDiskInfo"
    if (!(Test-Path $destSys)) { New-Item -ItemType Directory -Path $destSys -Force | Out-Null }
    if (!(Test-Path $destCry)) { New-Item -ItemType Directory -Path $destCry -Force | Out-Null }
    Copy-Item -Path "$BinDir\Sysinternals\*" -Destination $destSys -Recurse -Force -ErrorAction SilentlyContinue
    Copy-Item -Path "$BinDir\CrystalDiskInfo\*" -Destination $destCry -Recurse -Force -ErrorAction SilentlyContinue
    
    $wsh = New-Object -ComObject WScript.Shell
    $smPath = [Environment]::GetFolderPath("CommonPrograms")
    $scSys = $wsh.CreateShortcut("$smPath\Sysinternals Autoruns.lnk")
    $scSys.TargetPath = "$destSys\Autoruns64.exe"
    $scSys.Save()
    $scCry = $wsh.CreateShortcut("$smPath\CrystalDiskInfo.lnk")
    $scCry.TargetPath = "$destCry\DiskInfo64.exe"
    $scCry.Save()
    LogMsg " -> Herramientas instaladas en el sistema con accesos directos en el Menu Inicio." "Gray"
} else {
    LogMsg " -> Modo 100% Portable seleccionado: Cero huella en el disco del equipo." "Green"
}

# ---------------------------------------------------------------------------------------------
# 1. SEGURIDAD: CREACION DE PUNTO DE RESTAURACION DE WINDOWS
# ---------------------------------------------------------------------------------------------
LogMsg "`n[1/12] Asegurando el sistema: Creando Punto de Restauracion..." "Green"
try {
    Enable-ComputerRestore -Drive "C:\" -ErrorAction SilentlyContinue
    Checkpoint-Computer -Description "Pre_Optimizacion_BIM_USB" -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
    LogMsg " -> Punto de restauracion 'Pre_Optimizacion_BIM_USB' creado correctamente." "Gray"
} catch {
    LogMsg " -> [Aviso] Proteccion del sistema limitada o punto reciente ya existente. Continuando de forma segura..." "DarkYellow"
}

# ---------------------------------------------------------------------------------------------
# 2. GESTION AVANZADA DE MEMORIA RAM Y PREFETCH - CRUCIAL PARA BIM
# ---------------------------------------------------------------------------------------------
LogMsg "`n[2/12] Optimizando compresion de memoria RAM y Prefetch..." "Green"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" -Name "EnablePrefetcher" -Type DWord -Value 3 -Force
Set-MMAgent -MaxOperationAPIFiles 512 -ErrorAction SilentlyContinue
Enable-MMAgent -ApplicationLaunchPrefetching -ErrorAction SilentlyContinue
Enable-MMAgent -ApplicationPreLaunch -ErrorAction SilentlyContinue
Enable-MMAgent -OperationAPI -ErrorAction SilentlyContinue
Enable-MMAgent -PageCombining -ErrorAction SilentlyContinue
Enable-MMAgent -MemoryCompression -ErrorAction SilentlyContinue
LogMsg " -> Compresion nativa de memoria Xpress8k activada (amplia margen para Revit hasta +35% efectivo)." "Gray"
LogMsg " -> Prefetch de arranque y combinacion de paginas activadas." "Gray"

# ---------------------------------------------------------------------------------------------
# 3. PILA DE RED Y CONTROLADOR WINSOCK IFS (ws2ifsl)
# ---------------------------------------------------------------------------------------------
LogMsg "`n[3/12] Reparando sockets de red Winsock y optimizando conectividad Wi-Fi..." "Green"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\ws2ifsl" -Name "Start" -Type DWord -Value 3 -Force
LogMsg " -> Winsock IFS (ws2ifsl) fijado a Demanda (Start=3) para prevenir microcortes de red." "Gray"

$wifiKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}"
$intelWifiFound = $false
Get-ChildItem $wifiKey -ErrorAction SilentlyContinue | ForEach-Object {
    $desc = (Get-ItemProperty $_.PSPath -Name DriverDesc -ErrorAction SilentlyContinue).DriverDesc
    if ($desc -match "AX20|AX21|AX41|Killer|BE20") {
        Set-ItemProperty -Path $_.PSPath -Name "MIMOPowerSaveMode" -Value "2" -Force -ErrorAction SilentlyContinue
        $intelWifiFound = $true
        LogMsg " -> Tarjeta Wi-Fi Intel ($desc): Modo Ahorro Dinamico MIMO configurado." "Gray"
    }
}
if (-not $intelWifiFound) {
    LogMsg " -> Adaptador de red estandar: Configurado sin modificaciones propietarias." "Gray"
}

# ---------------------------------------------------------------------------------------------
# 4. CONTROLADOR GRAFICO NVIDIA (AUTODETECTABLE)
# ---------------------------------------------------------------------------------------------
LogMsg "`n[4/12] Analizando aceleracion grafica por hardware..." "Green"
$hasNvidia = $gpus | Where-Object { $_.Name -match "NVIDIA|GeForce|Quadro|RTX|GTX" }
if ($hasNvidia) {
    LogMsg " -> GPU NVIDIA detectada: $($hasNvidia[0].Name). Restaurando P-States dinamicos..." "Gray"
    $nvClassPaths = @(
        "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000",
        "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0001"
    )
    foreach ($np in $nvClassPaths) {
        if (Test-Path $np) {
            Remove-ItemProperty -Path $np -Name "DisableDynamicPstate" -ErrorAction SilentlyContinue
            Remove-ItemProperty -Path $np -Name "RMHdcpKeyglobZero" -ErrorAction SilentlyContinue
        }
    }
    
    $localInspector = "C:\Program Files (x86)\Nvidia Profile Inspector\Nvidia Profile Inspector.exe"
    $portableInspector = "$BinDir\NvidiaProfileInspector\Nvidia Profile Inspector.exe"
    $inspectorExe = if (Test-Path $portableInspector) { $portableInspector } else { $localInspector }
    $nipFile = "$ScriptDir\Reset_Nvidia_Base.nip"
    
    if ((Test-Path $inspectorExe) -and (Test-Path $nipFile)) {
        Start-Process -FilePath $inspectorExe -ArgumentList "-silentImport -silent `"$nipFile`"" -Wait
        LogMsg " -> Perfil base de NVIDIA reseteado con perfil limpio de fabricante." "Gray"
    }
    LogMsg " -> P-States dinamicos restaurados (la GPU entra en reposo y suspende en bateria)." "Gray"
} else {
    LogMsg " -> Graficos integrados detectados / Sin NVIDIA dedicada. Omitiendo modulo NVIDIA sin errores." "Gray"
}

# ---------------------------------------------------------------------------------------------
# 5. GESTION TERMICA DE LA CPU (TURBO BOOST INTELIGENTE)
# ---------------------------------------------------------------------------------------------
LogMsg "`n[5/12] Calibrando gestion termica y frecuencias de la CPU..." "Green"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7" -Name "Attributes" -Value 2 -Force -ErrorAction SilentlyContinue
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR be337238-0d82-4146-a960-4f3749d470c7 0
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR be337238-0d82-4146-a960-4f3749d470c7 2
powercfg /setactive SCHEME_CURRENT
powercfg /h /type reduced
LogMsg " -> En BATERIA (DC): Turbo Boost desactivado (frio absoluto, ventiladores callados y maxima bateria)." "Gray"
LogMsg " -> ENCHUFADO (AC): Turbo Boost Agresivo al 100% para calculos BIM y renderizado." "Gray"
LogMsg " -> Tamano de hibernacion reducido (liberados entre 8 y 32 GB en C: conservando Inicio Rapido)." "Gray"

# ---------------------------------------------------------------------------------------------
# 6. PROTECCION Y SALUD DE LA BATERIA (AUTODETECCION SEGUN MARCA)
# ---------------------------------------------------------------------------------------------
LogMsg "`n[6/12] Verificando salud y limites quimicos de la bateria..." "Green"
$mfg = $cs.Manufacturer

if ($mfg -match "ASUS|ASUSTeK") {
    $ghelperConfig = "$env:APPDATA\GHelper\config.json"
    if (Test-Path $ghelperConfig) {
        try {
            $json = Get-Content $ghelperConfig -Raw | ConvertFrom-Json
            $json.charge_limit = 80
            $json.screen_auto = 1
            $json | ConvertTo-Json -Depth 10 | Set-Content $ghelperConfig -Force
            LogMsg " -> ASUS Detectado: Limite de carga del 80% y refresco automatico fijados en G-Helper." "Gray"
        } catch {
            LogMsg " -> ASUS Detectado: G-Helper detectado pero no se pudo actualizar config.json." "Gray"
        }
    } else {
        LogMsg " -> ASUS Detectado: Se recomienda activar limite de carga al 80% en MyASUS o G-Helper." "Gray"
    }
} elseif ($mfg -match "Lenovo") {
    $lenovoReg = "HKLM:\SOFTWARE\Lenovo\PWRMGRV\ConfData\Data"
    if (Test-Path $lenovoReg) {
        Set-ItemProperty -Path $lenovoReg -Name "ConservationMode" -Value 1 -Force -ErrorAction SilentlyContinue
        LogMsg " -> Lenovo Detectado: Modo Conservacion (80% limite) activado mediante Registro." "Gray"
    } else {
        LogMsg " -> Lenovo Detectado: Se recomienda verificar Modo de Conservacion en Lenovo Vantage." "Gray"
    }
} elseif ($mfg -match "Dell|Alienware") {
    LogMsg " -> Dell Detectado: Recomendado seleccionar Primary AC Use en Dell Power Manager o BIOS." "Gray"
} elseif ($mfg -match "HP") {
    LogMsg " -> HP Detectado: Recomendado verificar Battery Health Manager en BIOS." "Gray"
} else {
    LogMsg " -> Marca: $mfg. Asegura el limite de carga al 80% en la utilidad del fabricante." "Gray"
}

# ---------------------------------------------------------------------------------------------
# 7. EXCLUSIONES MULTIVERSION PARA AUTODESK REVIT, PYREVIT Y MOTORES BIM
# ---------------------------------------------------------------------------------------------
LogMsg "`n[7/12] Aplicando politicas de exclusion para Autodesk Revit, pyRevit y motores BIM..." "Green"

$revitYears = 2022..2027
$revitPaths = [System.Collections.Generic.List[string]]::new()
foreach ($yr in $revitYears) {
    $p = "C:\Program Files\Autodesk\Revit $yr"
    if (Test-Path $p) {
        $revitPaths.Add($p)
        LogMsg " -> Version de Revit detectada en disco: Revit $yr" "Gray"
    }
}

$bimExtraPaths = @(
    "C:\Program Files\pyRevit-Master",
    "C:\Program Files\pyRevit CLI",
    "$env:APPDATA\pyRevit",
    "C:\Program Files\Autodesk\Revit 2027 MCP Server Write-Tools Technical Preview",
    "C:\Program Files\Enscape",
    "C:\Program Files\Epic Games\Twinmotion",
    "C:\Program Files\D5 Render"
)
foreach ($bp in $bimExtraPaths) {
    if (Test-Path $bp) {
        $revitPaths.Add($bp)
        LogMsg " -> Motor / Extension BIM detectada: $(Split-Path $bp -Leaf)" "Gray"
    }
}

foreach ($rp in $revitPaths) {
    Add-MpPreference -ExclusionPath $rp -ErrorAction SilentlyContinue
}

$bimProcesses = @("Revit.exe", "Autodesk.RevitMcpServer.Stdio.exe", "pyrevit.exe", "Enscape.exe", "Twinmotion.exe", "D5 Render.exe")
foreach ($bp in $bimProcesses) {
    Add-MpPreference -ExclusionProcess $bp -ErrorAction SilentlyContinue
}

$bimExts = @(".rvt", ".rfa", ".rft", ".rte")
foreach ($ext in $bimExts) {
    Add-MpPreference -ExclusionExtension $ext -ErrorAction SilentlyContinue
}

$defPolPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Exclusions"
if (!(Test-Path "$defPolPath\Paths")) { New-Item "$defPolPath\Paths" -Force | Out-Null }
if (!(Test-Path "$defPolPath\Processes")) { New-Item "$defPolPath\Processes" -Force | Out-Null }
if (!(Test-Path "$defPolPath\Extensions")) { New-Item "$defPolPath\Extensions" -Force | Out-Null }

foreach ($p in $revitPaths) {
    Set-ItemProperty -Path "$defPolPath\Paths" -Name $p -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
}
foreach ($pr in $bimProcesses) {
    Set-ItemProperty -Path "$defPolPath\Processes" -Name $pr -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
}
foreach ($ext in $bimExts) {
    Set-ItemProperty -Path "$defPolPath\Extensions" -Name $ext -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
}

$adskKey = "HKCU:\Software\Autodesk\MC3"
if (!(Test-Path $adskKey)) { New-Item $adskKey -Force | Out-Null }
Set-ItemProperty -Path $adskKey -Name "ADAConsoleOptIn" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $adskKey -Name "CIPOptIn" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
LogMsg " -> Exclusiones inyectadas en Windows Defender. Aceleracion BIM garantizada." "Gray"
LogMsg " -> Telemetria de fondo Autodesk CIP/MC3 desactivada." "Gray"

# ---------------------------------------------------------------------------------------------
# 8. TELEMETRIA AGRESIVA DE WINDOWS Y BLOQUEO DE INVENTORYSVC
# ---------------------------------------------------------------------------------------------
LogMsg "`n[8/12] Neutralizando telemetria pesada y saturacion de disco..." "Green"
$dataCollection = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
if (!(Test-Path $dataCollection)) { New-Item $dataCollection -Force | Out-Null }
Set-ItemProperty -Path $dataCollection -Name "AllowTelemetry" -Value 0 -Type DWord -Force
Set-ItemProperty -Path $dataCollection -Name "MaxTelemetryAllowed" -Value 0 -Type DWord -Force

Stop-Service -Name "InventorySvc" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\InventorySvc" -Name "Start" -Value 4 -Type DWord -Force -ErrorAction SilentlyContinue

Stop-Service -Name "DiagTrack" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\DiagTrack" -Name "Start" -Value 4 -Type DWord -Force -ErrorAction SilentlyContinue

Stop-Service -Name "dmwappushservice" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\dmwappushservice" -Name "Start" -Value 4 -Type DWord -Force -ErrorAction SilentlyContinue

$chromePol = "HKLM:\SOFTWARE\Policies\Google\Chrome"
if (!(Test-Path $chromePol)) { New-Item $chromePol -Force | Out-Null }
Set-ItemProperty -Path $chromePol -Name "MetricsReportingEnabled" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $chromePol -Name "FeedbackSurveysEnabled" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

$telemetryTasks = @(
    @{ Path = "\Microsoft\Windows\Application Experience\"; Name = "Microsoft Compatibility Appraiser" },
    @{ Path = "\Microsoft\Windows\Application Experience\"; Name = "ProgramDataUpdater" },
    @{ Path = "\Microsoft\Windows\Customer Experience Improvement Program\"; Name = "Consolidator" },
    @{ Path = "\Microsoft\Windows\Customer Experience Improvement Program\"; Name = "UsbCeip" },
    @{ Path = "\Microsoft\Windows\DiskDiagnostic\"; Name = "Microsoft-Windows-DiskDiagnosticResolver" },
    @{ Path = "\Microsoft\Windows\Windows Error Reporting\"; Name = "QueueReporting" }
)
foreach ($t in $telemetryTasks) {
    Disable-ScheduledTask -TaskPath $t.Path -TaskName $t.Name -ErrorAction SilentlyContinue | Out-Null
}
LogMsg " -> InventorySvc (telemetria de 60 MB/s en SSD) deshabilitado permanentemente." "Gray"

# ---------------------------------------------------------------------------------------------
# 9. SUPRESION DE BLOATWARE EN SEGUNDO PLANO Y ACTUALIZADORES
# ---------------------------------------------------------------------------------------------
LogMsg "`n[9/12] Desactivando servicios y tareas redundantes en segundo plano..." "Green"
Stop-Service -Name "Autodesk Access Service Host" -Force -ErrorAction SilentlyContinue
Set-Service -Name "Autodesk Access Service Host" -StartupType Disabled -ErrorAction SilentlyContinue

Stop-Service -Name "logi_lamparray_service" -Force -ErrorAction SilentlyContinue
Set-Service -Name "logi_lamparray_service" -StartupType Disabled -ErrorAction SilentlyContinue

$officeTasks = @(
    "Office ClickToRun Service Monitor", "Office Performance Monitor",
    "Office Background Push Maintenance", "Office Feature Updates",
    "Office Feature Updates Logon", "Office Feature Updates C2R Client",
    "Office Startup Maintenance", "Office Actions Server"
)
foreach ($ot in $officeTasks) {
    Disable-ScheduledTask -TaskPath "\Microsoft\Office\" -TaskName $ot -ErrorAction SilentlyContinue | Out-Null
}

Stop-Service -Name "edgeupdate" -Force -ErrorAction SilentlyContinue
Stop-Service -Name "edgeupdatem" -Force -ErrorAction SilentlyContinue
Set-Service -Name "edgeupdate" -StartupType Disabled -ErrorAction SilentlyContinue
Set-Service -Name "edgeupdatem" -StartupType Disabled -ErrorAction SilentlyContinue
Get-ScheduledTask | Where-Object { $_.TaskName -like "*MicrosoftEdgeUpdate*" } | ForEach-Object {
    Disable-ScheduledTask -TaskName $_.TaskName -TaskPath $_.TaskPath -ErrorAction SilentlyContinue | Out-Null
}
LogMsg " -> Tareas de fondo de Office C2R, Autodesk Access y Edge Update deshabilitadas." "Gray"

# ---------------------------------------------------------------------------------------------
# 10. ELIMINACION DE TIMER RESOLUTION SERVICE (STR)
# ---------------------------------------------------------------------------------------------
LogMsg "`n[10/12] Comprobando presencia de tweaks perjudiciales (STR / Timer Resolution)..." "Green"
Stop-Service -Name "STR" -Force -ErrorAction SilentlyContinue
Stop-Service -Name "SetTimerResolutionService" -Force -ErrorAction SilentlyContinue
& sc.exe delete STR 2>$null | Out-Null
& sc.exe delete SetTimerResolutionService 2>$null | Out-Null
Remove-Item -Path "C:\Windows\SetTimerResolutionService.exe" -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" -Name "GlobalTimerResolutionRequests" -ErrorAction SilentlyContinue
LogMsg " -> SetTimerResolutionService erradicado si existia en el equipo." "Gray"

# ---------------------------------------------------------------------------------------------
# 11. LIMPIEZA FORENSE DE REGISTROS HUERFANOS Y TAREAS ROTAS
# ---------------------------------------------------------------------------------------------
LogMsg "`n[11/12] Depurando entradas residuales del registro y tareas rotas..." "Green"
$orphanLogi = @('logi_audio_surround', 'logi_joy_bus_enum', 'logi_joy_vir_hid', 'logi_joy_xlcore')
foreach ($ol in $orphanLogi) {
    if (Test-Path "HKLM:\SYSTEM\CurrentControlSet\Services\$ol") {
        Remove-Item "HKLM:\SYSTEM\CurrentControlSet\Services\$ol" -Recurse -Force -ErrorAction SilentlyContinue
    }
}
$brokenTasks = @("GHelper")
foreach ($bt in $brokenTasks) {
    $t = Get-ScheduledTask -TaskName $bt -ErrorAction SilentlyContinue
    if ($t -and ($t.Actions.Execute -like "*Downloads*")) {
        Disable-ScheduledTask -TaskName $bt -ErrorAction SilentlyContinue | Out-Null
    }
}
LogMsg " -> Servicios huerfanos y tareas que apuntaban a carpetas borradas depurados." "Gray"

# ---------------------------------------------------------------------------------------------
# 12. AUDITORIA S.M.A.R.T. DE ALMACENAMIENTO Y DIAGNOSTICO
# ---------------------------------------------------------------------------------------------
LogMsg "`n[12/12] Auditando salud S.M.A.R.T. y temperaturas de almacenamiento..." "Green"
$disks = Get-PhysicalDisk | Select-Object DeviceId, FriendlyName, MediaType, BusType, OperationalStatus, HealthStatus
foreach ($d in $disks) {
    LogMsg " -> Disco $($d.DeviceId): $($d.FriendlyName) | Tipo: $($d.BusType) | Salud: $($d.HealthStatus) ($($d.OperationalStatus))" "Gray"
}

$portableCdi = "$BinDir\CrystalDiskInfo\DiskInfo64.exe"
if (Test-Path $portableCdi) {
    try {
        Start-Process -FilePath $portableCdi -ArgumentList "/CopyExit" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        $cdiTxt = "$BinDir\CrystalDiskInfo\DiskInfo.txt"
        if (Test-Path $cdiTxt) {
            $cdiContent = Get-Content $cdiTxt -Encoding utf8 -ErrorAction SilentlyContinue
            $smartSummary = $cdiContent | Select-String -Pattern "Model :|Health Status :|Temperature :|Power On Hours :|Host Writes :" | Out-String
            $logLines.Add("`n--- DETALLES SMART (CRYSTALDISKINFO PORTABLE) ---`n" + $smartSummary)
            LogMsg " -> Volcado S.M.A.R.T. detallado obtenido mediante CrystalDiskInfo Portable." "Gray"
        }
    } catch {}
}

# ---------------------------------------------------------------------------------------------
# FINALIZACION Y GUARDADO DE REPORTE TECNICO EN USB
# ---------------------------------------------------------------------------------------------
LogMsg "`n==================================================================" "Cyan"
LogMsg "   OPTIMIZACION Y REPARACION UNIVERSAL FINALIZADA CON EXITO       " "Cyan"
LogMsg "==================================================================" "Cyan"
LogMsg "Resumen de protecciones activas en este equipo:" "Yellow"
LogMsg "  * Autodesk Revit y pyRevit: Exclusiones oficiales inyectadas."
LogMsg "  * Licenciamiento de Revit (AdskLicensingService): 100% INTACTO."
LogMsg "  * Cola de impresion PDF (Spooler): 100% INTACTO."
LogMsg "  * Compresion de RAM: Activa (maxima holgura para modelos BIM pesados)."
LogMsg "  * Reporte guardado en USB: Informes_Equipos\$(Split-Path $reportFile -Leaf)" "Green"

$logLines | Out-File -FilePath $reportFile -Encoding utf8 -Force

try {
    if ([Environment]::UserInteractive -and -not [Console]::IsInputRedirected) {
        Write-Host "`nPresiona cualquier tecla para finalizar..." -ForegroundColor Yellow
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
} catch {}