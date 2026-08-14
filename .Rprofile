# ===========================================
# Configuración del entorno R
# Proyecto: ingresos-costo-vida-chile
# ===========================================

# Verificar si renv está disponible
if (!require("renv", quietly = TRUE, warn.conflicts = FALSE)) {
  message("renv no encontrado. Instálalo con: install.packages('renv')")
} else {
  suppressPackageStartupMessages(renv::load())
}

# ===========================================
# CONFIGURACIÓN REGIONAL Y LOCALE
# ===========================================

# Configurar locale para español
if (Sys.info()["sysname"] == "Windows") {
  Sys.setlocale("LC_TIME", "Spanish")
  Sys.setlocale("LC_COLLATE", "Spanish_Spain.1252")
} else {
  Sys.setlocale("LC_ALL", "es_ES.UTF-8")
}

# ===========================================
# OPCIONES GLOBALES
# ===========================================

options(
  # Ancho de consola (caracteres)
  width = 100,
  # Número de dígitos significativos a mostrar
  digits = 4,
  # No usar notación científica automáticamente
  scipen = 999,
  # Número máximo de items a mostrar
  max.print = 1000,
  # CRAN repository
  repos = c(CRAN = "https://cloud.r-project.org"),
  # Warnings como mensajes
  warn = 1,
  # No usar stringsAsFactors por defecto
  stringsAsFactors = FALSE,
  # Timeout para descargas
  timeout = 300
)

# ===========================================
# MENSAJE DE BIENVENIDA
# ===========================================

cat("\n")
cat("╔════════════════════════════════════════════════════════════╗\n")
cat("║   Análisis de Ingresos y Costo de Vida en Chile          ║\n")
cat("║   Proyecto: ingresos-costo-vida-chile                    ║\n")
cat("╚════════════════════════════════════════════════════════════╝\n")
cat("\n")

# ===========================================
# DEFINIR RUTAS DEL PROYECTO
# ===========================================

# Obtener el directorio del proyecto (donde está .Rprofile)
project_root <- tryCatch({
  # Intenta obtener el directorio del proyecto
  getwd()
}, error = function(e) {
  path.expand("~")
})

# Definir rutas estándar
data_raw <- file.path(project_root, "data", "raw")
data_processed <- file.path(project_root, "data", "processed")
scripts_dir <- file.path(project_root, "scripts")
output_dir <- file.path(project_root, "output")

# Crear directorios si no existen
invisible(lapply(
  list(data_raw, data_processed, output_dir),
  function(dir) {
    if (!dir.exists(dir)) {
      dir.create(dir, showWarnings = FALSE, recursive = TRUE)
    }
  }
))

# ===========================================
# FUNCIONES AUXILIARES
# ===========================================

# Limpiar el entorno de trabajo
clean_env <- function() {
  rm(list = ls(envir = .GlobalEnv)[-which(ls(envir = .GlobalEnv) %in% 
                                           c("clean_env", "project_info", "load_project_libs"))],
     envir = .GlobalEnv)
  gc()
  cat("✓ Entorno limpiado\n")
}

# Información del proyecto
project_info <- function() {
  cat("\n📊 Información del Proyecto:\n")
  cat("─────────────────────────────\n")
  cat("Directorio raíz:", project_root, "\n")
  cat("Datos raw:", data_raw, "\n")
  cat("Datos procesados:", data_processed, "\n")
  cat("Scripts:", scripts_dir, "\n")
  cat("Output:", output_dir, "\n")
  cat("\n")
  cat("R version:", R.version$version.string, "\n")
  cat("Paquetes cargados:", length(loadedNamespaces()), "\n")
  cat("─────────────────────────────\n\n")
}

# Cargar librerías comunes del proyecto
load_project_libs <- function() {
  required_libs <- c("tidyverse", "readxl", "janitor")
  missing_libs <- required_libs[!require(required_libs, character.only = TRUE, 
                                        quietly = TRUE, warn.conflicts = FALSE)]
  
  if (length(missing_libs) > 0) {
    cat("📦 Instalando librerías faltantes:", paste(missing_libs, collapse = ", "), "\n")
    # Las librerías se cargarán automáticamente con renv::restore()
  }
  
  suppressPackageStartupMessages({
    library(tidyverse, quietly = TRUE, warn.conflicts = FALSE)
    library(readxl, quietly = TRUE, warn.conflicts = FALSE)
    library(janitor, quietly = TRUE, warn.conflicts = FALSE)
  })
  
  cat("✓ Librerías principales cargadas\n")
}

# ===========================================
# CONFIGURACIÓN DE PROMPT
# ===========================================

# Personalizar el prompt de R
options(prompt = "R> ", continue = "+ ")

# ===========================================
# CARGAR LIBRERÍAS AUTOMÁTICAMENTE
# ===========================================

# Cargar librerías principales silenciosamente
suppressPackageStartupMessages({
  if (require("tidyverse", quietly = TRUE, warn.conflicts = FALSE)) {
    # tidyverse cargado
  }
})

# ===========================================
# MENSAJES FINALES
# ===========================================

cat("✓ Entorno configurado correctamente\n")
cat("  Ejecuta project_info() para ver detalles\n")
cat("  Ejecuta load_project_libs() para cargar todas las librerías\n")
cat("\n")
