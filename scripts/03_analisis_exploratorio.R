# Script 03: Análisis exploratorio de datos (EDA)
# Descripción: Exploración y estadísticas descriptivas
# Fecha: 2024

library(tidyverse)

# ===========================================
# CONFIGURACIÓN
# ===========================================

data_processed <- "data/processed"
output_dir <- "output"
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

# ===========================================
# FUNCIONES DE ANÁLISIS
# ===========================================

#' Resumen estadístico detallado
resumen_estadistico <- function(datos, variable) {
  if (!variable %in% names(datos)) {
    stop(paste("Variable no encontrada:", variable))
  }
  
  var <- datos %>% pull(variable)
  
  cat("\nResumen de:", variable, "\n")
  cat("─────────────────────────\n")
  cat("n observaciones:", length(na.omit(var)), "\n")
  cat("Media:          ", mean(var, na.rm = TRUE), "\n")
  cat("Mediana:        ", median(var, na.rm = TRUE), "\n")
  cat("Desv. Est.:     ", sd(var, na.rm = TRUE), "\n")
  cat("Mínimo:         ", min(var, na.rm = TRUE), "\n")
  cat("Máximo:         ", max(var, na.rm = TRUE), "\n")
  cat("NA's:           ", sum(is.na(var)), "\n")
}

#' Matriz de correlación
correlaciones <- function(datos, vars_numericas = NULL) {
  if (is.null(vars_numericas)) {
    datos_num <- datos %>% select(where(is.numeric))
  } else {
    datos_num <- datos %>% select(all_of(vars_numericas))
  }
  
  cor_matrix <- cor(datos_num, use = "complete.obs")
  return(cor_matrix)
}

# ===========================================
# ANÁLISIS EXPLORATORIO
# ===========================================

names(casen2024) # Listar archivos en el directorio de datos

dim(casen2024) # Dimensiones

proc_casen <- casen2024 %>%
    dplyr::select(
        id_vivienda,
        folio, 
        id_persona,
        region, 
        tot_per_h, 
        edad,
        sexo,
        salario = y1,
        pobreza,
        ytotcorh,
        ytotcor,
        yaimcorh,
        yautcorh,
        yautcor
    )

# Ejemplo de análisis (descomentar cuando tengas datos)

cor(x = proc_casen$salario, 
    y = proc_casen$pobreza, 
    use = "complete.obs")

sjPlot::plot_scatter(data = proc_casen, 
                     x = salario,
                     y = pobreza)

# ingresos <- readRDS(file.path(data_processed, "ingresos_limpio.rds"))
# 
# # Resúmenes por variable
# resumen_estadistico(ingresos, "ingresos")
# 
# # Correlaciones
# corr <- correlaciones(ingresos)
# print(corr)
# 
# # Tendencias temporales
# if ("fecha" %in% names(ingresos)) {
#   tendencia <- ingresos %>%
#     group_by(fecha) %>%
#     summarise(
#       promedio = mean(ingresos, na.rm = TRUE),
#       mediana = median(ingresos, na.rm = TRUE),
#       .groups = 'drop'
#     )
#   print(tendencia)
# }

# ===========================================
# RESUMEN
# ===========================================

cat("\n✓ Script 03 completado\n")
cat("Funciones disponibles:\n")
cat("  - resumen_estadistico(datos, variable)\n")
cat("  - correlaciones(datos, vars_numericas)\n")
