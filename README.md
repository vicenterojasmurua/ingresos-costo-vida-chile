# Análisis de Ingresos y Costo de Vida en Chile 📊

![R version](https://img.shields.io/badge/R-4.3.0+-blue)
![License](https://img.shields.io/badge/license-MIT-green)

## Descripción

Este proyecto analiza la relación entre ingresos y costo de vida en Chile, proporcionando visualizaciones y análisis exploratorio de datos sobre indicadores económicos y sociales.

## 📁 Estructura del Proyecto

```
ingresos-costo-vida-chile/
├── data/
│   ├── raw/              # Datos sin procesar
│   └── processed/        # Datos limpios y procesados
├── scripts/
│   ├── 01_carga_datos.R           # Carga de datos
│   ├── 02_limpieza_datos.R        # Limpieza y transformación
│   ├── 03_analisis_exploratorio.R # EDA (Exploratory Data Analysis)
│   └── 04_visualizaciones.R       # Gráficos y visualizaciones
├── output/               # Resultados (gráficos, reportes)
├── docs/
│   └── CONTRIBUIR.md    # Guía de contribución
├── .Rprofile            # Configuración del entorno R
├── renv.lock            # Lock file de dependencias
└── README.md            # Este archivo
```

## 🚀 Inicio Rápido

### Requisitos Previos
- **R**: versión 4.3.0 o superior
- **RStudio** (opcional pero recomendado)
- **Git**: para control de versiones

### Instalación

1. Clonar el repositorio:
```bash
git clone <repository-url>
cd ingresos-costo-vida-chile
```

2. Restaurar el entorno con `renv`:
```R
install.packages("renv")
renv::restore()
```

3. Ejecutar el pipeline:
```R
# En orden de dependencia:
source("scripts/01_carga_datos.R")
source("scripts/02_limpieza_datos.R")
source("scripts/03_analisis_exploratorio.R")
source("scripts/04_visualizaciones.R")
```

## 📊 Dependencias Principales

- **tidyverse** (2.0.0) - Manipulación y visualización de datos
- **readxl** (1.4.3) - Lectura de archivos Excel
- **janitor** (2.2.0) - Limpieza de datos
- **ggplot2** - Visualizaciones avanzadas
- **plotly** - Gráficos interactivos
- **knitr** - Generación de reportes

Ver [renv.lock](renv.lock) para la lista completa de dependencias y versiones.

## 📝 Flujo de Trabajo

### Scripts Principales

| Script | Descripción | Entrada | Salida |
|--------|-------------|---------|--------|
| `01_carga_datos.R` | Carga datos de fuentes | - | `data/raw/` |
| `02_limpieza_datos.R` | Limpia y transforma | `data/raw/` | `data/processed/` |
| `03_analisis_exploratorio.R` | Análisis exploratorio | `data/processed/` | Estadísticas básicas |
| `04_visualizaciones.R` | Genera gráficos | `data/processed/` | `output/` |

## 🤝 Contribución

Las contribuciones son bienvenidas. Por favor, consulta [CONTRIBUIR.md](docs/CONTRIBUIR.md) para detalles sobre el proceso de contribución.

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Ver LICENSE para más detalles.

## 👤 Autor

Creado para análisis de datos económicos de Chile.

## 📞 Contacto

Para preguntas o sugerencias, abre un issue en el repositorio. 
