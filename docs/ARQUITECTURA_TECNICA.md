# Arquitectura Técnica y Justificación de Ingeniería

Este documento desglosa el funcionamiento interno de cada módulo en **Laptop-Optimizer-BIM** y por qué es crítico para la longevidad y el rendimiento de ordenadores portátiles de trabajo.

---

## 1. Compresión de Memoria Xpress8k (`MemoryCompression`)
* **Problema:** Los modelos de información de construcción (BIM) en Revit consumen fácilmente entre 12 y 24 GB de RAM. En portátiles con 16 GB físicos, el sistema satura la memoria y recurre a la paginación masiva en disco (*paging*), provocando congelamientos.
* **Solución:** Activa el compresor nativo del Administrador de Memoria de Windows (`MMAgent`). Comprime bloques de memoria poco usados con un ratio típico de **2.5:1**, permitiendo que 16 GB de RAM física almacenen el equivalente a **20-22 GB de datos útiles** sin tocar el disco.

---

## 2. Pila de Red Winsock IFS (`ws2ifsl.sys`)
* **Problema:** Paquetes de "tweaking" de videojuegos suelen desactivar este controlador (`Start = 4`), lo que destruye el stack de sockets no bloqueantes y provoca desconexiones aleatorias en WebSockets (ChatGPT llamadas, Claude Desktop, VPNs y ERPs web).
* **Solución:** Restablece `ws2ifsl` a inicio por demanda (`Start = 3`), blindando las conexiones corporativas y de streaming de datos.

---

## 3. Estados P Dinámicos en GPU NVIDIA (`DisableDynamicPstate`)
* **Problema:** En muchos portátiles con dGPU (como la RTX 3060), ciertos scripts fijan la GPU en estado de máximo rendimiento P0/P2, impidiendo que la frecuencia de memoria (VRAM) baje de 6.000 MHz incluso con la pantalla apagada. Esto genera un consumo continuo de 25-30W y calienta el chasis a más de 70°C en reposo.
* **Solución:** Elimina las claves forzadas del registro y resetea el perfil base del controlador mediante *Nvidia Profile Inspector*, permitiendo que la tarjeta entre en suspensión profunda (Eco mode) y P8 en reposo.

---

## 4. Gestión Térmica de CPU (Turbo Boost Energético)
* **Problema:** Por defecto, los procesadores Intel Core (i7/i9) y AMD Ryzen activan Turbo Boost agresivo incluso al abrir una simple pestaña del navegador o estar en batería, consumiendo 45-65W y disparando los ventiladores.
* **Solución:** Desbloquea el atributo oculto en el esquema de energía de Windows (`be337238-0d82-4146-a960-4f3749d470c7`):
  * **En Batería (DC):** Desactiva Turbo Boost (valor `0`), fijando la CPU en su frecuencia base (3.3 GHz en el i7-11370H), lo que mantiene el equipo frío al tacto y duplica la autonomía.
  * **Enchufado (AC):** Habilita Turbo Boost agresivo (valor `2`) para aprovechar los 4.8 GHz en cálculo de renderizado, Revit y compilación.

---

## 5. Límite Químico de Batería (80%)
* **Problema:** Mantener celdas de iones de litio al 100% de carga a voltajes de 4.2V - 4.35V por celda mientras el portátil trabaja caliente degrada la capacidad hasta un 30% en menos de 2 años.
* **Solución:** Configura automáticamente el umbral de corte al 80% según el fabricante detectado:
  * ASUS: Modifica `config.json` de G-Helper.
  * Lenovo: Activa el `ConservationMode` en el registro del controlador de energía.
  * Dell / HP: Registra la recomendación para configurar *Primary AC Use* o *Battery Health Manager*.

---

## 6. Neutralización de `InventorySvc`
* **Problema:** El *Servicio de inventario y compatibilidad de aplicaciones* de Microsoft (`CompatTelRunner.exe`) escanea periódicamente gigabytes de archivos en segundo plano, generando lecturas continuas de 60 MB/s en el SSD, calentando el bus PCIe y degradando la vida útil del disco.
* **Solución:** Detiene el servicio y bloquea su arranque (`Start = 4` Disabled), liberando el disco inmediatamente.
