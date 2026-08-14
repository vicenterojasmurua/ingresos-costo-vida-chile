# Configuración del entorno R para el proyecto
# ingresos-costo-vida-chile

# ===========================================
# CONFIGURACIÓN GENERAL
# ===========================================

# Encoding UTF-8 para caracteres españoles
Sys.setlocale("LC_ALL", "es_ES.UTF-8")

# Opciones de sesión
options(
  # Ancho de consola
  width = 100,
  # Dígitos significativos en salida
  digits = 4,
  # No usar notación científica por defecto
  scipen = 999,
  # Tamaño máximo de string en salida
  max.print = 1000,
  # Repos para instalar paquetes
  repos = c(CRAN = "https://cloud.r-project.org")
)

# ===========================================
# CARGAR LIBRERÍAS COMUNES
# ===========================================

# Mensajes de inicio más limpios
suppressPackageStartupMessages({
  # Cargar tidyverse si está disponible
  if (require("tidyverse", quietly = TRUE)) {
    # tidyverse cargado exitosamente
  }
})

# ===========================================
# FUNCIONES ÚTILES
# ===========================================

# Limpiar entorno
clean_env <- function() {
  rm(list = ls(envir = .GlobalEnv), envir = .GlobalEnv)
  gc()
}

# Ver información de sesión
session_info <- function() {
  cat("R version:", R.version$version.string, "\n")
  cat("Working directory:", getwd(), "\n")
  cat("Paquetes cargados:", length(loadedNamespaces()), "\n")
}

# ===========================================
# RUTAS DEL PROYECTO
# ===========================================

# Definir ruta del proyecto
project_root <- dirname(normalizePath("~/.Rprofile"))
data_raw <- file.path(project_root, "data", "raw")
data_processed <- file.path(project_root, "data", "processed")
scripts_dir <- file.path(project_root, "scripts")
output_dir <- file.path(project_root, "output")

# Crear carpetas si no existen
dir.create(data_raw, showWarnings = FALSE, recursive = TRUE)
dir.create(data_processed, showWarnings = FALSE, recursive = TRUE)
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

cat("✓ Proyecto 'ingresos-costo-vida-chile' listo\n")
