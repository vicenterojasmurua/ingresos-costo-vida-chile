# Guía de Configuración del Proyecto 🔧

## Requisitos del Sistema

### Requerido
- **R**: 4.3.0 o superior
  - Descargar desde: https://cloud.r-project.org/
- **Git**: Para control de versiones
  - Descargar desde: https://git-scm.com/

### Recomendado
- **RStudio Desktop** (IDE para R)
  - Descargar desde: https://posit.co/products/open-source/rstudio/
- **VS Code** con extensión de R
  - Extensiones recomendadas:
    - `Ikuyadeu.r` - R Language Support
    - `RDebugger.r-debugger` - R Debugger

---

## Instalación Paso a Paso

### 1. Clonar el Repositorio

```bash
# HTTPS
git clone https://github.com/usuario/ingresos-costo-vida-chile.git
cd ingresos-costo-vida-chile

# O SSH (si tienes SSH configurado)
git clone git@github.com:usuario/ingresos-costo-vida-chile.git
cd ingresos-costo-vida-chile
```

### 2. Instalar y Restaurar Dependencias

El proyecto usa **`renv`** para gestionar versiones de paquetes R.

```R
# En R/RStudio, ejecutar:

# Instalar renv si no está disponible
install.packages("renv")

# Restaurar paquetes desde renv.lock
renv::restore()

# Responde "y" (yes) cuando se pregunte si deseas continuar
```

### 3. Verificar la Instalación

```R
# Ejecutar en la consola R:
source(".Rprofile")

# Deberías ver un mensaje como:
# ╔════════════════════════════════════════╗
# ║ Análisis de Ingresos y Costo de Vida  ║
# ╚════════════════════════════════════════╝
# ✓ Entorno configurado correctamente
```

---

## Configuración de Desarrollo

### En VS Code

1. Instalar extensión R: `Ikuyadeu.r`
2. Las configuraciones ya están en `.vscode/settings.json`
3. Reiniciar VS Code para aplicar cambios

### En RStudio

1. Abrir `ingresos-costo-vida-chile.Rproj` (si existe)
2. O simplemente abrir los scripts en la carpeta `/scripts`
3. RStudio detectará automáticamente `renv`

---

## Estructura de Carpetas

```
ingresos-costo-vida-chile/
├── data/
│   ├── raw/              # Datos sin procesar (IGNORE en .gitignore)
│   └── processed/        # Datos limpios (regenerable)
├── scripts/
│   ├── 0_funciones_auxiliares.R   # Funciones comunes
│   ├── 01_carga_datos.R           # Cargar datos
│   ├── 02_limpieza_datos.R        # Limpiar y transformar
│   ├── 03_analisis_exploratorio.R # EDA
│   └── 04_visualizaciones.R       # Gráficos
├── output/               # Resultados (gráficos, tablas, HTML)
├── docs/                 # Documentación
│   └── CONTRIBUIR.md    # Guía de contribución
├── .vscode/              # Configuración VS Code
│   └── settings.json    # Settings para R
├── .Rprofile            # Configuración automática de R
├── .gitignore           # Archivos a ignorar en git
├── renv.lock            # Lock file de dependencias
└── README.md            # Este archivo
```

---

## Flujo de Trabajo Típico

### 1. Actualizar Paquetes

```R
# Cuando instalas un nuevo paquete, actualizar snapshot:
renv::snapshot()

# Comitear cambios en renv.lock:
# git add renv.lock
# git commit -m "update: actualizar paquetes"
```

### 2. Ejecutar Pipeline Completo

```R
# Opción 1: Ejecutar cada script manualmente
source("scripts/01_carga_datos.R")
source("scripts/02_limpieza_datos.R")
source("scripts/03_analisis_exploratorio.R")
source("scripts/04_visualizaciones.R")

# Opción 2: Crear un script maestro (hacer_todo.R)
# Que ejecute todos los scripts en orden
```

### 3. Crear Nuevas Funciones

Agregar funciones a `scripts/0_funciones_auxiliares.R`:

```R
# Ejemplo: Nueva función para normalizar datos
#' Normalizar variable numérica
#'
#' @param x Vector numérico
#' @return Vector normalizado [0, 1]
#' @examples
#' datos$ingreso_norm <- normalizar(datos$ingreso)
#'
normalizar <- function(x) {
  (x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))
}

# Luego en tu script:
source("scripts/0_funciones_auxiliares.R")
datos$ingreso_normalizado <- normalizar(datos$ingreso)
```

---

## Comandos Útiles Git

```bash
# Crear rama de trabajo
git checkout -b feature/nombre-feature

# Ver estado
git status

# Agregar cambios
git add .

# Commit
git commit -m "feat: descripción del cambio"

# Push a rama
git push origin feature/nombre-feature

# Traer cambios del main
git pull origin main

# Cambiar a rama main
git checkout main
```

---

## Troubleshooting

### Error: "renv not found"

```R
# Solución:
install.packages("renv")
renv::restore()
```

### Error: Paquete X no encontrado

```R
# Restaurar nuevamente:
renv::restore()

# Si el error persiste:
renv::purge()  # Purgar cache
renv::restore()
```

### Diferentes versiones de paquetes

```R
# Verificar qué está en renv.lock vs tu entorno
renv::status()

# Sincronizar con renv.lock
renv::restore()
```

### "Encoding issues" con caracteres españoles

```R
# Ya está configurado en .Rprofile, pero si hay problemas:
Sys.setlocale("LC_ALL", "es_ES.UTF-8")
```

---

## Variables de Entorno

Puedes crear un `.Renviron` para variables personales (NO comitear):

1. Copiar `.Renviron.example` a `.Renviron`
2. Editar con tus valores personales
3. Reiniciar R para aplicar

```R
# En R:
Sys.getenv("VARIABLE_NAME")
```

---

## Recursos Útiles

- **R Documentation**: https://www.r-project.org/
- **tidyverse**: https://www.tidyverse.org/
- **renv Documentation**: https://rstudio.github.io/renv/
- **Git & GitHub**: https://guides.github.com/
- **R for Data Science**: https://r4ds.had.co.nz/

---

## Preguntas Frecuentes

**P: ¿Cómo agrego un nuevo paquete?**
```R
install.packages("nombre_paquete")
renv::snapshot()  # Guardar cambios
```

**P: ¿Cómo cambio de rama sin perder cambios?**
```bash
git stash
git checkout main
git stash pop
```

**P: ¿Cómo veo diferencias antes de hacer commit?**
```bash
git diff
git diff --staged  # Para cambios ya staged
```

---

**Última actualización**: Agosto 2026
**Versión de R**: 4.3.0+
**Gestor de dependencias**: renv 1.0.0+
