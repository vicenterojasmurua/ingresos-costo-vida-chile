# ===========================================
# Funciones Auxiliares del Proyecto
# ===========================================
# Este archivo contiene funciones comunes
# para carga, limpieza y análisis de datos

# -------------------------------------------
# FUNCIONES DE LECTURA
# -------------------------------------------

#' Cargar archivo CSV con validaciones
#'
#' @param archivo Ruta del archivo CSV
#' @param ... Argumentos adicionales para read_csv()
#'
#' @return data.frame
#'
#' @examples
#' \dontrun{
#' datos <- cargar_csv("data/raw/datos.csv")
#' }
#'
cargar_csv <- function(archivo, ...) {
  if (!file.exists(archivo)) {
    stop("Archivo no encontrado:", archivo)
  }
  
  cat("Cargando:", archivo, "\n")
  datos <- readr::read_csv(archivo, show_col_types = FALSE, ...)
  cat("✓ Cargado:", nrow(datos), "filas,", ncol(datos), "columnas\n")
  
  return(datos)
}

#' Cargar archivo Excel con validaciones
#'
#' @param archivo Ruta del archivo Excel
#' @param sheet Nombre o número de hoja (default: 1)
#'
#' @return data.frame
#'
cargar_excel <- function(archivo, sheet = 1) {
  if (!file.exists(archivo)) {
    stop("Archivo no encontrado:", archivo)
  }
  
  cat("Cargando sheet", sheet, "de:", archivo, "\n")
  datos <- readxl::read_excel(archivo, sheet = sheet)
  cat("✓ Cargado:", nrow(datos), "filas,", ncol(datos), "columnas\n")
  
  return(datos)
}

# -------------------------------------------
# FUNCIONES DE LIMPIEZA
# -------------------------------------------

#' Limpiar nombres de columnas
#'
#' Convierte nombres de columnas a snake_case
#'
#' @param datos data.frame
#'
#' @return data.frame con nombres limpios
#'
limpiar_nombres <- function(datos) {
  datos <- janitor::clean_names(datos)
  cat("✓ Nombres de columnas limpios\n")
  return(datos)
}

#' Remover filas duplicadas
#'
#' @param datos data.frame
#' @param ... Columnas para considerar (todas por default)
#'
#' @return data.frame sin duplicados
#'
remover_duplicados <- function(datos, ...) {
  n_original <- nrow(datos)
  datos <- distinct(datos, ...)
  n_final <- nrow(datos)
  
  if (n_original > n_final) {
    cat("⚠ Removidos", n_original - n_final, "duplicados\n")
  }
  
  return(datos)
}

#' Reportar valores faltantes
#'
#' @param datos data.frame
#'
#' @return invisibly devuelve el mismo data.frame
#'
reportar_na <- function(datos) {
  na_count <- colSums(is.na(datos))
  na_pct <- round(colMeans(is.na(datos)) * 100, 2)
  
  na_summary <- data.frame(
    columna = names(datos),
    NA_count = na_count,
    NA_pct = na_pct
  ) %>%
    filter(NA_count > 0) %>%
    arrange(desc(NA_count))
  
  if (nrow(na_summary) > 0) {
    cat("\n⚠ Valores Faltantes (NA):\n")
    print(na_summary)
    cat("\n")
  } else {
    cat("✓ No hay valores faltantes\n")
  }
  
  invisible(datos)
}

# -------------------------------------------
# FUNCIONES DE ESTADÍSTICAS
# -------------------------------------------

#' Calcular estadísticas resumidas por grupo
#'
#' @param datos data.frame
#' @param grupo Columna para agrupar (símbolo)
#' @param variable Columna numérica a resumir (símbolo)
#'
#' @return data.frame con estadísticas
#'
estadisticas_grupo <- function(datos, grupo, variable) {
  datos %>%
    group_by({{ grupo }}) %>%
    summarise(
      n = n(),
      media = mean({{ variable }}, na.rm = TRUE),
      mediana = median({{ variable }}, na.rm = TRUE),
      sd = sd({{ variable }}, na.rm = TRUE),
      min = min({{ variable }}, na.rm = TRUE),
      max = max({{ variable }}, na.rm = TRUE),
      q25 = quantile({{ variable }}, 0.25, na.rm = TRUE),
      q75 = quantile({{ variable }}, 0.75, na.rm = TRUE),
      .groups = "drop"
    )
}

# -------------------------------------------
# FUNCIONES DE SALIDA
# -------------------------------------------

#' Guardar tabla en CSV y Excel
#'
#' @param datos data.frame
#' @param nombre_base Nombre base (sin extensión)
#' @param ruta_output Directorio de salida (default: "output")
#'
#' @return invisibly devuelve el mismo data.frame
#'
guardar_datos <- function(datos, nombre_base, ruta_output = "output") {
  dir.create(ruta_output, showWarnings = FALSE)
  
  # Guardar como CSV
  archivo_csv <- file.path(ruta_output, paste0(nombre_base, ".csv"))
  readr::write_csv(datos, archivo_csv)
  cat("✓ CSV guardado:", archivo_csv, "\n")
  
  # Guardar como Excel
  archivo_xlsx <- file.path(ruta_output, paste0(nombre_base, ".xlsx"))
  writexl::write_xlsx(datos, archivo_xlsx)
  cat("✓ XLSX guardado:", archivo_xlsx, "\n")
  
  invisible(datos)
}

#' Guardar gráfico
#'
#' @param plot Objeto ggplot
#' @param nombre_archivo Nombre del archivo (con extensión .png, .pdf, etc)
#' @param ruta_output Directorio de salida
#' @param width Ancho en pulgadas (default: 10)
#' @param height Alto en pulgadas (default: 6)
#'
#' @return invisibly devuelve el gráfico
#'
guardar_grafico <- function(plot, nombre_archivo, ruta_output = "output", 
                            width = 10, height = 6) {
  dir.create(ruta_output, showWarnings = FALSE)
  
  ruta_completa <- file.path(ruta_output, nombre_archivo)
  ggsave(ruta_completa, plot = plot, width = width, height = height, dpi = 300)
  
  cat("✓ Gráfico guardado:", ruta_completa, "\n")
  invisible(plot)
}

# -------------------------------------------
# UTILIDADES VARIAS
# -------------------------------------------

#' Ver primeras filas con información
#'
#' @param datos data.frame
#'
#' @return invisibly devuelve el mismo data.frame
#'
ver_datos <- function(datos) {
  cat("Dimensiones:", nrow(datos), "×", ncol(datos), "\n")
  cat("Columnas:", paste(names(datos), collapse = ", "), "\n\n")
  print(head(datos, 10))
  invisible(datos)
}

# -------------------------------------------
# CARGAR LIBRERÍAS NECESARIAS
# -------------------------------------------

# Estas funciones necesitan estas librerías:
# tidyverse, readxl, janitor, writexl
