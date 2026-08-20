# Documentación de Datos 📊

## Estructura Esperada de Datos

Este documento describe la estructura de datos esperada para el proyecto.

---

## Datos de Entrada (data/raw/)

### 1. Archivo: `ingresos.csv` o `ingresos.xlsx`

**Descripción**: Datos de ingresos por región, sector o categoría

**Columnas esperadas**:
| Columna | Tipo | Descripción | Ejemplo |
|---------|------|-------------|---------|
| `fecha` | Date | Fecha de la observación | 2024-01-01 |
| `region` | Text | Región de Chile | Metropolitana, Valparaíso |
| `sector` | Text | Sector económico | Agricultura, Servicios |
| `ingreso_promedio` | Numeric | Ingreso promedio en CLP | 1500000 |
| `ingreso_mediana` | Numeric | Ingreso mediana en CLP | 1200000 |
| `categoria` | Text | Categoría ocupacional | Profesional, Técnico |

**Validaciones**:
- Fecha debe estar en formato YYYY-MM-DD
- Ingresos deben ser > 0
- Region y sector no pueden estar en blanco
- No pueden haber valores duplicados para la misma fecha/región/sector

---

### 2. Archivo: `costo_vida.csv` o `costo_vida.xlsx`

**Descripción**: Índices de costo de vida por región y período

**Columnas esperadas**:
| Columna | Tipo | Descripción | Ejemplo |
|---------|------|-------------|---------|
| `fecha` | Date | Mes de referencia | 2024-01-01 |
| `region` | Text | Región de Chile | Metropolitana |
| `indice_costo_vida` | Numeric | Índice base 100 | 102.5 |
| `vivienda_pct` | Numeric | % del índice en vivienda | 35.2 |
| `alimentacion_pct` | Numeric | % del índice en alimentación | 20.1 |
| `transporte_pct` | Numeric | % del índice en transporte | 15.3 |
| `otros_pct` | Numeric | % del índice en otros | 29.4 |

**Validaciones**:
- Indice debe ser > 0
- Suma de porcentajes debe ser ≈ 100 (±1%)
- Debe existir para todas las regiones en la misma fecha

---

### 3. Archivo: `poblacion.csv`

**Descripción**: Datos demográficos de población (opcional)

**Columnas esperadas**:
| Columna | Tipo | Descripción |
|---------|------|-------------|
| `fecha` | Date | Año/período |
| `region` | Text | Región |
| `poblacion_total` | Numeric | Habitantes |
| `tasa_desempleo` | Numeric | % desempleo |

---

## Datos Procesados (data/processed/)

Los archivos procesados se generan automáticamente mediante los scripts de limpieza.

### Archivo: `datos_limpios.csv`

**Descripción**: Datos combinados de ingresos y costo de vida, ya limpios

**Características**:
- Nombres de columnas en `snake_case`
- Sin valores faltantes (NA removidos o imputados)
- Sin duplicados
- Todas las fechas en formato ISO (YYYY-MM-DD)
- Todas las variables numéricas normalizadas si es necesario

---

## Resultados de Análisis

### Salida EDA

**Generados por**: `scripts/03_analisis_exploratorio.R`

**Archivos**:
- `resumen_estadistico.xlsx` - Estadísticas descriptivas
- `correlaciones.csv` - Matriz de correlaciones
- `valores_faltantes.csv` - Reporte de datos faltantes

**Ejemplo de resumen_estadistico.xlsx**:

| Variable | n | media | mediana | sd | min | max |
|----------|---|-------|---------|----|----|-----|
| ingreso_promedio | 1000 | 1500000 | 1200000 | 500000 | 800000 | 3500000 |
| indice_costo_vida | 1000 | 102.5 | 102.0 | 5.2 | 95.0 | 115.0 |

---

### Gráficos Generados

**Generados por**: `scripts/04_visualizaciones.R`

**Archivos típicos**:
- `evolucion_ingresos.png` - Serie temporal de ingresos
- `costo_vida_por_region.png` - Comparación por región
- `scatter_ingreso_costo.png` - Relación ingreso vs costo de vida
- `boxplot_sectores.png` - Distribución de ingresos por sector
- `heatmap_correlaciones.png` - Matriz de correlaciones

---

## Especificaciones Técnicas

### Formatos de Archivo

**Aceptados para entrada**:
- CSV con separador `,` (coma)
- XLSX (Excel 2007+)
- Encoding: UTF-8

**Generados en salida**:
- CSV: UTF-8, separador `,`
- XLSX: formato Excel 2007+
- PNG: 300 DPI, escala de colores accesible
- PDF: vectores, embebidos en RMarkdown

### Fechas

- **Formato**: `YYYY-MM-DD` (ISO 8601)
- **Timezone**: UTC
- **Coerción automática**: El script 02_limpieza intenta convertir fechas

### Valores Numéricos

- **Decimales**: Usar `.` (punto) como separador
- **Miles**: SIN separadores (1000000, no 1,000,000)
- **NA/Faltantes**: Celdas vacías o `NA`
- **Infinito**: Será removido/tratado

---

## Checklist de Validación

Antes de cargar datos, verifica:

- [ ] Todas las fechas están en formato `YYYY-MM-DD`
- [ ] No hay espacios en blanco en los nombres de columnas
- [ ] Los valores numéricos son > 0 (si corresponde)
- [ ] No hay caracteres especiales problemáticos (acentos OK)
- [ ] El archivo usa encoding UTF-8
- [ ] Las columnas requeridas están presentes

---

## Diccionario de Variables

### Ingresos

- **ingreso_promedio**: Promedio aritmético del ingreso en la población
- **ingreso_mediana**: Valor central del ingreso
- **ingreso_p10**: Percentil 10 (ingresos más bajos)
- **ingreso_p90**: Percentil 90 (ingresos más altos)

### Costo de Vida

- **indice_costo_vida**: Índice base 100 (mes/año de referencia)
- **vivienda_pct**: Peso (%) de vivienda en el IPC
- **alimentacion_pct**: Peso (%) de alimentación
- **transporte_pct**: Peso (%) de transporte

### Categorías

- **Región**: Metropolitana, Valparaíso, Bío-Bío, etc.
- **Sector**: Agricultura, Minería, Manufactura, Servicios, Público
- **Categoria**: Profesional, Técnico, Operario, Administrativo

---

## Preguntas Frecuentes

**P: ¿Qué hacer si tengo valores faltantes?**
A: El script 02_limpieza_datos.R reporta todos los NA. Puedes:
- Removerlos (si son pocos)
- Imputarlos con la media/mediana
- Investigar la razón del dato faltante

**P: ¿Cómo manejo fechas irregulares?**
A: Asegúrate que estén en formato ISO (YYYY-MM-DD). Luego:
```R
source("scripts/0_funciones_auxiliares.R")
datos$fecha <- as.Date(datos$fecha)  # Convertir
```

**P: ¿Puedo agregar nuevas variables?**
A: Sí, agrégalas a data/raw/ y actualiza:
1. Este documento
2. El script 02_limpieza_datos.R (si necesita limpieza)
3. El script 03_analisis_exploratorio.R (si incluirla en análisis)

---

**Última actualización**: Agosto 2026
