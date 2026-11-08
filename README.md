# Optimum_WWindows ⚡💻

> **Universal Laptop Optimization, Repair & BIM Performance Suite**  
> *Optimizador y Suite de Rendimiento para Portátiles | Windows 笔记本专属优化与 BIM 性能套件*

<p align="center">
  <a href="#-español"><b>🇪🇸 Español</b></a> •
  <a href="#-english"><b>🇬🇧 English</b></a> •
  <a href="#-中文"><b>🇨🇳 中文</b></a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Windows%2010%20%7C%2011-0078D6?logo=windows" alt="Windows" />
  <img src="https://img.shields.io/badge/PowerShell-5.1%20%2B-5391FE?logo=powershell" alt="PowerShell" />
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License" />
  <img src="https://img.shields.io/badge/Autodesk-Revit%202022--2027-red?logo=autodesk" alt="Revit" />
  <img src="https://img.shields.io/badge/Mode-100%25%20Portable%20%2F%20USB-orange" alt="Portable" />
</p>

---

## 🇪🇸 Español

### 📋 ¿Qué es Optimum_WWindows?
Una suite integral de ingeniería de software diseñada específicamente para **ordenadores portátiles con Windows 10 y 11**, optimizada para profesionales de arquitectura, modelado BIM (Autodesk Revit, pyRevit), renderizado 3D y flujos de trabajo de cálculo intensivo e IA.

### 🚀 Características Principales
1. **Detección Automática de Hardware:**
   * **ASUS (ROG / TUF / ZenBook):** Bloquea la carga al 80% y activa tasa de refresco adaptativa (144Hz enchufado / 60Hz batería) en G-Helper.
   * **Lenovo (ThinkPad / Legion):** Activa el Modo de Conservación de Batería (80%) en el Registro.
   * **Dell / HP / MSI:** Asistencia guiada de umbral de batería oficial del fabricante.
2. **GPU NVIDIA Inteligente:** Restaura estados P dinámicos y libera la VRAM de frecuencias bloqueadas (evita 28W y 75°C en reposo).
3. **Aceleración Autodesk Revit:** Exclusiones oficiales en Windows Defender para Revit (2022 a 2027), pyRevit, extensiones `.rvt`, `.rfa` y motores como Enscape, Twinmotion y D5 Render.
4. **Compresión de Memoria Xpress8k:** Convierte 16 GB de RAM física en ~20-22 GB virtuales efectivos para modelos BIM gigantescos.
5. **Turbo Boost Adaptativo:**
   * **En Batería:** Turbo desactivado (CPU a 3.3 GHz base, laptop fría y hasta +3h de batería).
   * **Enchufado:** Turbo Boost al 100% para renderizado y cálculo BIM.
6. **Erradicación de Telemetría e `InventorySvc`:** Elimina el uso del 100% y picos de 60 MB/s en el disco SSD.

### 🛠️ Uso Rápido
* Haz doble clic en `INICIAR_OPTIMIZADOR.bat` (solicitará permisos de Administrador automáticamente).
* Elige el **Modo 1** (100% Portable desde USB sin instalar nada) o **Modo 2** (Instalación de herramientas en el sistema).

---

## 🇬🇧 English

### 📋 What is Optimum_WWindows?
An engineering-grade, automated performance and debloat suite designed specifically for **Windows 10 & 11 laptops**, tailored for Architectural workstations, BIM modeling (Autodesk Revit, pyRevit), 3D visualization, and AI/CAD workflows.

### 🚀 Key Features
1. **Smart Laptop Manufacturer Autodetection:**
   * **ASUS (ROG / TUF / ZenBook):** Enforces 80% battery charge limit and auto screen refresh rate (144Hz AC / 60Hz DC) in G-Helper.
   * **Lenovo (ThinkPad / Legion):** Enables Conservation Mode (80% threshold) via registry/WMI.
   * **Dell / HP / MSI:** Provides brand-specific battery longevity profiles.
2. **NVIDIA GPU Thermal Optimization:** Restores dynamic P-States and resets corrupted base profiles, stopping the 6,000 MHz memory clock lock (drops idle consumption from 28W to 0W on battery).
3. **Autodesk Revit & pyRevit Acceleration:** Automatic Windows Defender exclusion injection for Revit versions (2022 through 2027), pyRevit CLI, `.rvt`, `.rfa` extensions, and rendering engines (Enscape, Twinmotion, D5 Render).
4. **Xpress8k Memory Compression:** Expands 16 GB of physical RAM to ~20-22 GB effective virtual headroom, preventing Out-Of-Memory crashes in heavy BIM projects.
5. **Intelligent CPU Power Profiles:**
   * **On Battery (DC):** Disables CPU Turbo Boost (whisper-quiet, chassis cool to the touch, +1 to 3 hours extra battery life).
   * **Plugged in (AC):** Full aggressive Turbo Boost for 3D renders and complex BIM calculations.
6. **Telemetry & `InventorySvc` Neutralization:** Terminates aggressive diagnostic background tasks that churn SSDs at 60 MB/s.

### 🛠️ Quick Start
* Double-click `INICIAR_OPTIMIZADOR.bat` (auto-elevates to Administrator).
* Select **Mode 1** (100% Portable, zero footprint from USB) or **Mode 2** (Install Sysinternals & CrystalDiskInfo locally).

---

## 🇨🇳 中文

### 📋 什么是 Optimum_WWindows？
**Optimum_WWindows** 是一款专为 **Windows 10 和 Windows 11 笔记本电脑** 深度定制的系统级性能优化与修复套件。特别针对**建筑设计、BIM 建模（Autodesk Revit、pyRevit）、3D 渲染及重度计算/AI 场景**进行了底层硬件与操作系统调优。

### 🚀 核心功能亮点
1. **智能笔记本品牌自适应识别：**
   * **华硕 (ASUS ROG / TUF / 灵耀):** 自动锁定 G-Helper 电池充电阈值为 80%，并开启智能屏幕刷新率（插电 144Hz / 电池模式 60Hz）。
   * **联想 (Lenovo ThinkPad / 拯救者 Legion):** 注册表级自动开启“电池养护模式（80% 充电限制）”。
   * **戴尔 (Dell) / 惠普 (HP) / 微星 (MSI):** 提供针对各品牌官方电源管理方案的适配指引。
2. **NVIDIA 独立显卡功耗与发热修复：**
   * 恢复动态 P-State 电源状态，清除电竞调优包导致的显存锁定（解决待机时显存被死锁在 6000MHz、功耗飙至 28W、机身发烫达 75°C 的问题）。
3. **Autodesk Revit & pyRevit 全版本加速：**
   * 自动探测并为 **Revit 2022 至 2027 全系列**、pyRevit、Revit MCP 插件及渲染引擎（Enscape、Twinmotion、D5 渲染器）注入 Windows Defender 白名单排除项，工程启动速度提升 35% 以上。
4. **Xpress8k 原生内存压缩技术：**
   * 开启 Windows 内核级内存压缩，相当于将 16 GB 物理内存扩展出 **20-22 GB 的实际可用容量**，彻底杜绝大体量 BIM 模型爆内存崩溃。
5. **CPU 智能睿频温控方案：**
   * **电池供电状态 (DC):** 关闭高功耗睿频，CPU 恒定在基础主频运行，整机冰凉静音，电池续航大幅延长 1 至 3 小时。
   * **电源插电状态 (AC):** 开启 100% 满血睿频，释放全部多核算力用于渲染出图与复杂结构计算。
6. **彻底清除微软遥测与 `InventorySvc` 硬盘吞吐：**
   * 永久禁用 `InventorySvc` 等后台遥测服务，终结 SSD 硬盘每秒 60 MB/s 的无端读写消耗与发热。

### 🛠️ 快速使用指南
* 鼠标右键或双击运行 `INICIAR_OPTIMIZADOR.bat`（将自动以管理员权限启动）。
* 按提示选择 **[1] 100% 便携模式（推荐）**，直接在 U 盘运行，对系统不留冗余文件；或选择 **[2] 本地安装模式**。

---

## 📂 项目结构 / Project Structure / 项目结构

```text
Optimum_WWindows/
│
├── INICIAR_OPTIMIZADOR.bat       <-- 一键管理员启动器 (One-click Launcher)
├── SUBIR_A_GITHUB.bat            <-- 一键同步到 GitHub (One-click Git Push)
├── README.md                     <-- 多语言文档 (Trilingual Documentation)
├── LICENSE                       <-- MIT 开源协议 (MIT License)
├── .gitignore                    <-- Git 忽略配置
│
├── docs/
│   └── ARQUITECTURA_TECNICA.md   <-- 深度技术原理解析
│
├── scripts/
│   ├── Optimizador_Universal_Engine.ps1  <-- 核心 12 模块优化引擎
│   └── Reset_Nvidia_Base.nip             <-- NVIDIA 官方出厂配置重置档
│
├── bin/                          <-- 便携式免安装工具箱 (Portable Utilities)
│   ├── Sysinternals/             <-- 微软官方系统诊断工具
│   ├── CrystalDiskInfo/          <-- 硬盘健康度与 SMART 监测工具
│   └── NvidiaProfileInspector/   <-- 显卡配置文件管理工具
│
└── Informes_Equipos/             <-- 各设备自动生成的健康诊断报告目录
```

---

## 📄 许可证 / License / 许可证
本项目采用 [MIT License](LICENSE) 开源协议。
