# Registro de Cambios

Todos los cambios notables en este proyecto se documentan en este archivo.

El formato se basa en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/) 
y este proyecto adhiere a [Semantic Versioning](https://semver.org/lang/es/).

## [Sin versión] - 2026-08-14

### Agregado
- ✅ Configuración completa del proyecto
  - `.Rprofile` mejorado con funciones auxiliares
  - `.gitignore` completo para R
  - `renv.lock` con dependencias pinned
  - `.vscode/settings.json` con configuración de R

- ✅ Documentación
  - `README.md` con estructura clara
  - `docs/SETUP.md` - Guía de instalación paso a paso
  - `docs/CONTRIBUIR.md` - Directrices de contribución
  - `docs/DATOS.md` - Especificación de estructura de datos
  - `CHANGELOG.md` - Este archivo

- ✅ Funciones auxiliares
  - `scripts/0_funciones_auxiliares.R` con utilidades comunes
  - Funciones para carga, limpieza, análisis y exportación de datos

- ✅ Estructura de carpetas
  - Directorios `data/raw/`, `data/processed/`, `output/`
  - Archivos `.gitkeep` para mantener directorios vacíos

- ✅ Configuración de entorno
  - `.Renviron.example` para variables de ambiente
  - Soporte multiplatforma (Windows, Linux, macOS)

### Modificado
- `.Rprofile` - Versión simplificada mejorada con más funciones
- `.gitignore` - Ampliado con más patrones
- `README.md` - Documentación expandida

### Próximo (Roadmap)

- [ ] Crear scripts iniciales de carga (01_carga_datos.R)
- [ ] Agregar ejemplos de datasets de prueba
- [ ] Crear GitHub Actions para CI/CD
- [ ] Configurar linting automático de código R
- [ ] Agregar tests unitarios
- [ ] Documentación de API/resultados esperados
- [ ] Docker configuration (opcional)

---

## Notas de Desarrollo

### Convenciones Adoptadas

- **Idioma**: Español para comentarios, inglés para código (estándar R)
- **Nombres de funciones**: `snake_case`
- **Nombres de variables**: `snake_case`
- **Ancho líneas**: Max 100 caracteres (configurado en .Rprofile)
- **Indentación**: 2 espacios
- **Commits**: Semánticos con prefijos (feat, fix, docs, etc)

### Dependencias Principales

- `tidyverse` - Manipulación y visualización de datos
- `readxl` - Lectura de archivos Excel
- `janitor` - Limpieza de datos y nombres
- `writexl` - Escritura de archivos Excel
- `ggplot2` - Visualizaciones avanzadas (incluido en tidyverse)

### Versionado de Dependencias

Usar `renv` para garantizar reproducibilidad:
```bash
# Restaurar versiones exactas
renv::restore()

# Después de instalar nuevo paquete
renv::snapshot()

# Comitear cambios
git add renv.lock
git commit -m "chore: actualizar renv.lock"
```

---

## Historial de Cambios Anteriores

*Este es un proyecto en fase de configuración inicial*

---

## Cómo Contribuir

Ver [docs/CONTRIBUIR.md](docs/CONTRIBUIR.md) para detalles sobre cómo reportar bugs, sugerir cambios, y hacer contribuciones.

---

**Mantenido por**: [Tu nombre/equipo]  
**Última actualización**: 2026-08-14
