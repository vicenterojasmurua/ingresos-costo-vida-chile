# Script 01: Carga de datos
# Descripción: Importar datos de fuentes externas
# Fecha: 2024

# ===========================================
# CARGAR LIBRERÍAS
# ===========================================

library(tidyverse)
library(haven)
library(readxl)

# ===========================================
# CONFIGURACIÓN
# ===========================================

# Rutas
data_raw <- "data/raw"
data_processed <- "data/processed"

# Crear carpetas si no existen
dir.create(data_raw, showWarnings = FALSE, recursive = TRUE)
dir.create(data_processed, showWarnings = FALSE, recursive = TRUE)

# ===========================================
# FUNCIONES DE CARGA
# ===========================================

#' Cargar datos Stata (.dta) con validación
cargar_dta <- function(archivo, ...) {
  ruta <- file.path(data_raw, archivo)
  if (!file.exists(ruta)) {
    warning(paste("Archivo no encontrado:", ruta))
    return(NULL)
  }
  
  datos <- read_dta(ruta, ...)
  cat("✓ Cargado:", archivo, "-", nrow(datos), "filas\n")
  return(datos)
}

#' Cargar datos CSV con validación
cargar_csv <- function(archivo, ...) {
  ruta <- file.path(data_raw, archivo)
  if (!file.exists(ruta)) {
    warning(paste("Archivo no encontrado:", ruta))
    return(NULL)
  }
  
  datos <- read_csv(ruta, ...)
  cat("✓ Cargado:", archivo, "-", nrow(datos), "filas\n")
  return(datos)
}

#' Cargar datos Excel con validación
cargar_excel <- function(archivo, sheet = 1, ...) {
  ruta <- file.path(data_raw, archivo)
  if (!file.exists(ruta)) {
    warning(paste("Archivo no encontrado:", ruta))
    return(NULL)
  }
  
  datos <- read_excel(ruta, sheet = sheet, ...)
  cat("✓ Cargado:", archivo, "-", nrow(datos), "filas\n")
  return(datos)
}

# ===========================================
# CARGAR DATASETS
# ===========================================

# Ejemplo: cargar casen 2024
casen2024 <- cargar_dta("casen_2024.dta")

# Ejemplo: cargar costo de vida
# costo_vida <- cargar_csv("costo_vida_chile.csv")

# Ejemplo: cargar datos regionales
# datos_regionales <- cargar_excel("datos_regionales.xlsx", sheet = 1)

# ===========================================
# GUARDAR DATOS CARGADOS
# ===========================================

# Ejemplo de guardado (descomentar cuando tengas datos)

saveRDS(casen2024, file.path(data_processed, "casen2024_raw.rds"))

# saveRDS(costo_vida, file.path(data_processed, "costo_vida_raw.rds"))

cat("\n✓ Script 01 completado\n")
cat("Nota: Coloca tus datos en 'data/raw/' antes de ejecutar\n")
