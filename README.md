# Optimum_WWindows ⚡💻

> **Optimizador, Reparador y Suite de Rendimiento para Portátiles con Windows 10 y 11**  
> *Diseñado especialmente para estaciones de trabajo móviles de Arquitectura, Modelado BIM (Autodesk Revit, pyRevit), IA y cálculo pesado.*

[![Windows](https://img.shields.io/badge/Plataforma-Windows%2010%20%7C%2011-0078D6?logo=windows)](https://www.microsoft.com)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%20%2B-5391FE?logo=powershell)](https://github.com/PowerShell/PowerShell)
[![License: MIT](https://img.shields.io/badge/Licencia-MIT-green.svg)](LICENSE)
[![GitHub Repo](https://img.shields.io/badge/GitHub-xycnww%2FOptimum__WWindows-blue?logo=github)](https://github.com/xycnww/Optimum_WWindows)
[![Revit](https://img.shields.io/badge/Autodesk-Revit%202022--2027-red?logo=autodesk)](https://www.autodesk.com/revit)
[![Portable](https://img.shields.io/badge/Modo-100%25%20Portable%20%2F%20USB-orange)](#modo-de-uso-y-despliegue)

---

## 📋 ¿Por qué este optimizador para portátiles?

Los portátiles modernos de alto rendimiento sufren frecuentemente de:
1. **Altas temperaturas y ruido excesivo en reposo** provocados por servicios de telemetría agresiva (`InventorySvc`, `CompatTelRunner`) y tweaks dañinos de YouTube/e-sports que rompen los estados C de la CPU y bloquean la VRAM al 100%.
2. **Degradación acelerada de la batería** por mantener cargas constantes al 100% mientras se trabaja enchufado a la corriente.
3. **Ralentizaciones severas al abrir modelos BIM** en Autodesk Revit debido al análisis redundante en tiempo real de Windows Defender.
4. **Microcortes de red en llamadas y WebSockets** (ChatGPT, Claude, ERP corporativo) causados por controladores de red desincronizados.

**Laptop-Optimizer-BIM** soluciona todos estos problemas con una sola ejecución desatendida y **autodetección inteligente de hardware**.

---

## 🚀 Características Principales

* 🔍 **Autodetección de Fabricante de Portátil:**
  * **ASUS (ROG / TUF / ZenBook):** Bloquea el límite de carga al 80% y activa la tasa de refresco adaptativa (144Hz enchufado / 60Hz en batería) en G-Helper.
  * **Lenovo (ThinkPad / Legion / Yoga):** Activa el Modo de Conservación de Batería (80%) a nivel de Registro/WMI.
  * **Dell / Alienware / HP / MSI:** Detecta la marca y proporciona instrucciones guiadas para la suite nativa del fabricante.
* 🎮 **Aceleración Gráfica NVIDIA Inteligente:**
  * Detecta si el portátil dispone de GPU NVIDIA GeForce/Quadro o si cuenta únicamente con gráfica integrada (Intel Iris Xe / AMD Radeon).
  * Restaura los **P-States dinámicos** y resetea el perfil base para que la GPU descanse en reposo (evitando que la VRAM se quede clavada a 6.000 MHz consumiendo 28W en silencio).
* 🏢 **Blindaje Específico para Autodesk Revit & pyRevit:**
  * Escanea y aplica exclusiones oficiales de Windows Defender para cualquier versión instalada (**Revit 2022, 2023, 2024, 2025, 2026, 2027**).
  * Soporte completo para **pyRevit**, **pyRevit CLI**, conectores **MCP Server** y motores de render (**Enscape, Twinmotion, D5 Render**).
  * Desactiva la telemetría invasiva de Autodesk CIP/MC3 para agilizar el arranque de proyectos.
* 🧠 **Compresión de Memoria RAM Xpress8k:**
  * Activa la compresión nativa de Windows (ratio 2.5:1), expandiendo efectivamente 16 GB de RAM física a **~20-22 GB virtuales libres**, evitando cierres inesperados por falta de memoria al renderizar o trabajar con nubes de puntos.
* ❄️ **Control Térmico de CPU (Turbo Boost Energético):**
  * **En Batería:** Desactiva el Turbo Boost (la CPU se mantiene fría a su frecuencia base de 3.3 GHz, el portátil no quema las piernas y la batería dura de 1 a 3 horas más).
  * **Enchufado (Corriente):** Activa Turbo Boost al 100% de agresividad para máxima velocidad de renderizado y cálculo.
* 🛡️ **Seguridad Total:**
  * Intenta crear automáticamente un **Punto de Restauración de Windows** antes de realizar cualquier cambio.
  * Genera un informe técnico forense (con horas de uso y salud S.M.A.R.T. de tus discos SSD) guardado en `Informes_Equipos/`.

---

## 🛠️ Estructura del Repositorio

```text
Laptop-Optimizer-BIM/
│
├── INICIAR_OPTIMIZADOR.bat       <-- Lanzador de 1 clic (Auto-elevación a Administrador)
├── README.md                     <-- Documentación oficial del proyecto
├── LICENSE                       <-- Licencia de código abierto MIT
├── .gitignore                    <-- Filtro para informes locales y temporales
│
├── scripts/
│   ├── Optimizador_Universal_Engine.ps1  <-- Motor central de optimización (12 módulos)
│   └── Reset_Nvidia_Base.nip             <-- Perfil limpio de fábrica para GPU NVIDIA
│
├── docs/
│   └── ARQUITECTURA_TECNICA.md   <-- Fundamentos de ingeniería de cada módulo
│
└── Informes_Equipos/             <-- Reportes de salud SSD generados automáticamente
```

---

## 💻 Modo de Uso

### Opción A: Ejecución Directa en este Portátil
1. Haz clic derecho sobre `INICIAR_OPTIMIZADOR.bat` y selecciona **Ejecutar como Administrador** (o haz doble clic; el script solicitará permisos automáticamente).
2. Selecciona el modo:
   * **[1] 100% Portable (Recomendado):** Ejecuta todas las optimizaciones sin instalar ningún archivo en tu disco.
   * **[2] Instalación Local:** Instala Sysinternals y CrystalDiskInfo en `C:\Program Files` con accesos en el menú Inicio.

### Opción B: Uso como Kit Portable en Memoria USB (Cualquier Portátil)
1. Copia toda la carpeta del repositorio a un pendrive USB.
2. Conecta el USB a cualquier portátil con Windows 10/11 que quieras reparar o enfriar.
3. Ejecuta `INICIAR_OPTIMIZADOR.bat`. El sistema quedará optimizado en menos de 60 segundos.

---

## ⚙️ Los 12 Módulos de Optimización

| # | Módulo | Función y Beneficio |
| :-: | :--- | :--- |
| **01** | **Punto de Restauración** | Garantía de seguridad previa mediante `Checkpoint-Computer`. |
| **02** | **Compresión de RAM & Prefetch** | Habilita `MemoryCompression` y `EnablePrefetcher = 3` para Revit. |
| **03** | **Pila de Red Winsock (ws2ifsl)** | Restaura sockets a Demanda; previene cortes en ChatGPT, Claude y ERP. |
| **04** | **GPU NVIDIA (P-States)** | Resetea perfil base y desbloquea bajada de reloj de memoria VRAM. |
| **05** | **Turbo Boost Inteligente** | Frío absoluto en batería (DC=0) / Máxima potencia en corriente (AC=2). |
| **06** | **Protección de Batería (80%)** | Ajusta el umbral de carga para frenar el desgaste químico de litio. |
| **07** | **Exclusiones BIM / Revit** | Excluye rutas de Revit 2022-2027, pyRevit, Enscape y extensiones `.rvt`. |
| **08** | **Erradicación de Telemetría** | Deshabilita `InventorySvc` (detiene escrituras de 60 MB/s en el SSD). |
| **09** | **Limpieza de Tareas de Fondo** | Desactiva tareas parasitarias de Office ClickToRun y Edge Update. |
| **10** | **Eliminación de STR Service** | Erradica `SetTimerResolutionService` (causante de CPU a 74°C en reposo). |
| **11** | **Depuración Forense** | Elimina claves residuales de controladores no instalados y tareas rotas. |
| **12** | **Auditoría S.M.A.R.T. SSD** | Inspecciona terabytes escritos (TBW), horas de encendido y reservas NAND. |

---

## 📄 Licencia

Este proyecto está bajo la Licencia **MIT**. Consulta el archivo [LICENSE](LICENSE) para más detalles.
