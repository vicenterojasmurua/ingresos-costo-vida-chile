# Script 04: Visualizaciones
# Descripción: Crear gráficos para análisis y reportes
# Fecha: 2024

library(tidyverse)
library(ggplot2)

# ===========================================
# CONFIGURACIÓN
# ===========================================

data_processed <- "data/processed"
output_dir <- "output"
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

# Tema personalizado
tema_proyecto <- function() {
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0),
    plot.subtitle = element_text(size = 11, color = "gray40"),
    axis.title = element_text(size = 10),
    legend.position = "bottom",
    panel.grid.major = element_line(color = "gray90"),
    panel.grid.minor = element_blank()
  )
}

# ===========================================
# FUNCIONES DE VISUALIZACIÓN
# ===========================================

#' Gráfico de serie temporal
grafico_temporal <- function(datos, fecha_col, valor_col, titulo = "") {
  p <- datos %>%
    ggplot(aes(x = .data[[fecha_col]], y = .data[[valor_col]])) +
    geom_line(color = "#2E86AB", size = 0.8) +
    geom_point(color = "#2E86AB", size = 2) +
    labs(
      title = titulo,
      x = "Fecha",
      y = valor_col
    ) +
    tema_proyecto()
  
  return(p)
}

#' Gráfico de distribución
grafico_distribucion <- function(datos, variable, titulo = "") {
  p <- datos %>%
    ggplot(aes(x = .data[[variable]])) +
    geom_histogram(fill = "#A23B72", alpha = 0.7, bins = 30) +
    geom_density(aes(y = after_stat(count)), color = "#F18F01", size = 1) +
    labs(
      title = titulo,
      x = variable,
      y = "Frecuencia"
    ) +
    tema_proyecto()
  
  return(p)
}

#' Gráfico de comparación por grupo
grafico_comparacion <- function(datos, grupo_col, valor_col, titulo = "") {
  p <- datos %>%
    ggplot(aes(x = .data[[grupo_col]], y = .data[[valor_col]], fill = .data[[grupo_col]])) +
    geom_boxplot(alpha = 0.7, show.legend = FALSE) +
    labs(
      title = titulo,
      x = grupo_col,
      y = valor_col
    ) +
    tema_proyecto()
  
  return(p)
}

#' Guardar gráfico
guardar_grafico <- function(plot, nombre_archivo, ancho = 10, alto = 6) {
  ruta <- file.path(output_dir, nombre_archivo)
  ggsave(ruta, plot, width = ancho, height = alto, dpi = 300)
  cat("✓ Gráfico guardado:", nombre_archivo, "\n")
}

# ===========================================
# EJEMPLOS DE VISUALIZACIÓN
# ===========================================

# Ejemplo (descomentar cuando tengas datos):
#
# ingresos <- readRDS(file.path(data_processed, "ingresos_limpio.rds"))
# 
# # Gráfico de serie temporal
# p1 <- grafico_temporal(ingresos, "fecha", "ingresos", "Evolución de ingresos")
# guardar_grafico(p1, "01_evolucion_ingresos.png")
# 
# # Gráfico de distribución
# p2 <- grafico_distribucion(ingresos, "ingresos", "Distribución de ingresos")
# guardar_grafico(p2, "02_distribucion_ingresos.png")

# ===========================================
# RESUMEN
# ===========================================

cat("\n✓ Script 04 completado\n")
cat("Funciones disponibles:\n")
cat("  - grafico_temporal(datos, fecha_col, valor_col, titulo)\n")
cat("  - grafico_distribucion(datos, variable, titulo)\n")
cat("  - grafico_comparacion(datos, grupo_col, valor_col, titulo)\n")
cat("  - guardar_grafico(plot, nombre_archivo, ancho, alto)\n")
