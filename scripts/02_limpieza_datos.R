# Script 02: Limpieza y transformación de datos
# Descripción: Procesar y limpiar datos para análisis
# Fecha: 2024

library(tidyverse)
library(janitor)

# ===========================================
# CONFIGURACIÓN
# ===========================================

data_processed <- "data/processed"
dir.create(data_processed, showWarnings = FALSE, recursive = TRUE)

# ===========================================
# FUNCIONES DE LIMPIEZA
# ===========================================

#' Limpieza básica de datos
limpiar_datos <- function(datos) {
  datos %>%
    # Limpiar nombres de columnas
    clean_names() %>%
    # Remover filas completamente vacías
    filter(!if_all(everything(), is.na)) %>%
    # Remover duplicados
    distinct()
}

#' Validar tipos de datos
validar_tipos <- function(datos) {
  cat("Tipos de datos:\n")
  print(data.frame(
    columna = names(datos),
    tipo = sapply(datos, class),
    valores_unicos = sapply(datos, function(x) n_distinct(x, na.rm = TRUE)),
    na_count = sapply(datos, function(x) sum(is.na(x)))
  ))
}

# ===========================================
# PROCESAMIENTO DE DATOS
# ===========================================

# Ejemplo de flujo de limpieza (descomentar cuando tengas datos)
 
 ingresos_limpio <- readRDS("data/processed/ingresos_raw.rds") %>%
   limpiar_datos() %>%
   # Convertir columnas de fechas
   mutate(
     fecha = as.Date(fecha)
   ) %>%
   # Convertir a numérico
   mutate(
     ingresos = as.numeric(ingresos)
   )
 
 # Validar
 validar_tipos(ingresos_limpio)
 
 # Guardar
 saveRDS(ingresos_limpio, file.path(data_processed, "ingresos_limpio.rds"))

# ===========================================
# RESUMEN
# ===========================================

cat("\n✓ Script 02 completado\n")
cat("Funciones disponibles:\n")
cat("  - limpiar_datos(datos)\n")
cat("  - validar_tipos(datos)\n")
