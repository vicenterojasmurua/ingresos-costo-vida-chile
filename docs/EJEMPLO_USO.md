# Ejemplo de Uso del Proyecto 📘

Este archivo muestra cómo usar las funciones y estructura del proyecto.

## Inicio del Proyecto

```R
# Primero, instalar/restaurar dependencias (una sola vez)
if (!require("renv")) install.packages("renv")
renv::restore()

# Luego, crear un nuevo script R:
# En la carpeta scripts/, crear archivo: mi_analisis.R

# ============================================
# Ejemplo: mi_analisis.R
# ============================================

# 1. Limpiar entorno (opcional)
rm(list = ls())
gc()

# 2. Cargar el .Rprofile (configuración automática)
# Esto ocurre automáticamente al abrir el proyecto

# 3. Cargar funciones auxiliares
source("scripts/0_funciones_auxiliares.R")

# 4. Cargar librerías
library(tidyverse)
library(readxl)
```

---

## Cargar Datos

```R
# Opción 1: Desde CSV
datos_ingresos <- cargar_csv("data/raw/ingresos.csv")

# Opción 2: Desde Excel
datos_costo_vida <- cargar_excel("data/raw/costo_vida.xlsx", sheet = 1)

# Ver datos básicos
ver_datos(datos_ingresos)
```

---

## Limpiar Datos

```R
# Limpiar nombres de columnas
datos_ingresos <- limpiar_nombres(datos_ingresos)

# Remover duplicados
datos_ingresos <- remover_duplicados(datos_ingresos)

# Reportar valores faltantes
reportar_na(datos_ingresos)

# Combinar datasets
datos_completos <- datos_ingresos %>%
  left_join(datos_costo_vida, by = c("fecha", "region"))

# Crear nuevas variables
datos_completos <- datos_completos %>%
  mutate(
    # Relación ingreso vs costo
    ratio_ingreso_costo = ingreso_promedio / indice_costo_vida,
    # Año desde fecha
    anio = year(fecha),
    # Trimestre
    trimestre = quarter(fecha)
  )

# Guardar datos procesados
guardar_datos(datos_completos, "datos_procesados", "data/processed")
```

---

## Análisis Exploratorio

```R
# Estadísticas por grupo
estadisticas_ingresos <- estadisticas_grupo(
  datos_completos, 
  grupo = region, 
  variable = ingreso_promedio
)

print(estadisticas_ingresos)

# Correlaciones
correlaciones <- cor(
  datos_completos %>% select(where(is.numeric)),
  use = "complete.obs"
)

# Exportar
write.csv(correlaciones, "output/correlaciones.csv")
```

---

## Crear Visualizaciones

```R
# Usando funciones de tidyverse y ggplot2

# 1. Serie temporal de ingresos
grafico_temporal <- datos_completos %>%
  group_by(fecha) %>%
  summarise(ingreso_medio = mean(ingreso_promedio, na.rm = TRUE)) %>%
  ggplot(aes(x = fecha, y = ingreso_medio)) +
  geom_line(color = "#2E86AB", linewidth = 1) +
  geom_point(color = "#A23B72", size = 2) +
  theme_minimal() +
  labs(
    title = "Evolución del Ingreso Promedio en Chile",
    x = "Fecha",
    y = "Ingreso Promedio (CLP)",
    subtitle = "Período 2020-2026"
  ) +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

# Guardar
guardar_grafico(grafico_temporal, "evolucion_ingresos.png")

# 2. Comparación por región (boxplot)
grafico_regiones <- datos_completos %>%
  ggplot(aes(x = fct_reorder(region, ingreso_promedio, .fun = median), 
             y = ingreso_promedio, fill = region)) +
  geom_boxplot(alpha = 0.7) +
  theme_minimal() +
  labs(
    title = "Distribución de Ingresos por Región",
    x = "Región",
    y = "Ingreso Promedio (CLP)"
  ) +
  theme(legend.position = "none", axis.text.x = element_text(angle = 45))

guardar_grafico(grafico_regiones, "ingresos_por_region.png")

# 3. Scatter: Ingreso vs Costo de Vida
grafico_scatter <- datos_completos %>%
  ggplot(aes(x = indice_costo_vida, y = ingreso_promedio, color = region)) +
  geom_point(alpha = 0.6, size = 3) +
  geom_smooth(method = "lm", se = FALSE, alpha = 0.2) +
  theme_minimal() +
  labs(
    title = "Relación: Ingreso vs Costo de Vida",
    x = "Índice Costo de Vida",
    y = "Ingreso Promedio (CLP)",
    color = "Región"
  )

guardar_grafico(grafico_scatter, "ingreso_vs_costo.png")
```

---

## Generar Reportes

```R
# Crear tabla resumida
resumen <- datos_completos %>%
  group_by(region) %>%
  summarise(
    n_observaciones = n(),
    ingreso_promedio = mean(ingreso_promedio, na.rm = TRUE),
    ingreso_mediana = median(ingreso_promedio, na.rm = TRUE),
    indice_promedio = mean(indice_costo_vida, na.rm = TRUE),
    desviacion = sd(ingreso_promedio, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(ingreso_promedio))

# Guardar como Excel con formato
writexl::write_xlsx(
  list(
    Resumen = resumen,
    Estadisticas = estadisticas_ingresos,
    Correlaciones = as.data.frame(correlaciones)
  ),
  "output/reporte_analisis.xlsx"
)
```

---

## Workflow Completo

Crear un script `hacer_todo.R` que ejecute todo:

```R
# ============================================
# hacer_todo.R - Pipeline Completo
# ============================================

# Limpiar entorno
clean_env()

# Cargar funciones
source("scripts/0_funciones_auxiliares.R")
library(tidyverse)

# 1. CARGA
cat("\n📥 CARGANDO DATOS...\n")
datos_ingresos <- cargar_csv("data/raw/ingresos.csv")
datos_costo_vida <- cargar_excel("data/raw/costo_vida.xlsx")

# 2. LIMPIEZA
cat("\n🧹 LIMPIANDO DATOS...\n")
datos <- datos_ingresos %>%
  limpiar_nombres() %>%
  remover_duplicados() %>%
  left_join(datos_costo_vida %>% limpiar_nombres(), 
            by = c("fecha", "region"))

# 3. ANÁLISIS
cat("\n📊 ANÁLISIS EXPLORATORIO...\n")
reportar_na(datos)
estadisticas_grupo(datos, region, ingreso_promedio)

# 4. VISUALIZACIONES
cat("\n📈 GENERANDO GRÁFICOS...\n")
# [Código de gráficos aquí]

# 5. EXPORTAR
cat("\n💾 EXPORTANDO RESULTADOS...\n")
guardar_datos(datos, "datos_procesados", "data/processed")

cat("\n✅ Pipeline completado!\n")
```

Luego ejecutar:
```R
source("hacer_todo.R")
```

---

## Funciones Auxiliares Disponibles

| Función | Uso |
|---------|-----|
| `cargar_csv()` | Cargar datos de CSV |
| `cargar_excel()` | Cargar datos de Excel |
| `limpiar_nombres()` | Convertir a snake_case |
| `remover_duplicados()` | Remover duplicados |
| `reportar_na()` | Mostrar valores faltantes |
| `estadisticas_grupo()` | Estadísticas por grupo |
| `guardar_datos()` | Guardar CSV + XLSX |
| `guardar_grafico()` | Guardar gráfico |
| `ver_datos()` | Ver estructura |

---

## Recursos Útiles

- **tidyverse cheatsheet**: https://www.tidyverse.org/
- **ggplot2 themes**: https://ggplot2.tidyverse.org/
- **Data transformation**: https://dplyr.tidyverse.org/
- **Funciones date/time**: https://lubridate.tidyverse.org/

---

**Última actualización**: Agosto 2026
