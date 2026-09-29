* ==============================================================================
* PROYECTO: Tesis de Licenciatura en Sociología
* AUTOR: Vicente Rojas
* INSTITUCIÓN: Universidad de Chile - Facultad de Ciencias Sociales
* MÓDULO 01: Carga, Procesamiento de Datos y Exportación a LaTeX (Overleaf)
* ==============================================================================

* ------------------------------------------------------------------------------
* 1. CONFIGURACIÓN INICIAL Y ENTORNO REPRODUCIBLE
* ------------------------------------------------------------------------------

* Limpia la memoria de Stata (borra bases de datos previas)
clear all

* Evita que Stata pause la pantalla pidiendo presionar una tecla
set more off

* Elimina variables globales o locales guardadas anteriormente
macro drop _all

* Fija la versión de Stata para asegurar reproducibilidad
version 17

* Establece la semilla aleatoria para replicar resultados exactos
set seed 20260822

* Cambia el directorio de trabajo a la carpeta del proyecto
cd "C:\Users\vroja\OneDrive\Escritorio\VIRTUAL STUDIO CODE\ingresos-costo-vida-chile"

* Crea automáticamente las carpetas del proyecto si aún no existen
capture mkdir "logs"
capture mkdir "data"
capture mkdir "data/raw"
capture mkdir "data/raw/chile"
capture mkdir "data/raw/argentina"
capture mkdir "data/raw/brasil"
capture mkdir "data/processed"
capture mkdir "data/processed/chile"
capture mkdir "data/processed/argentina"
capture mkdir "data/processed/brasil"
capture mkdir "output"
capture mkdir "output/tables"
capture mkdir "output/figures"

* Cierra logs previos e intenta borrar el archivo anterior para evitar el error r(608)
capture log close _all
capture erase "logs/procesamiento_modulo01.log"

* Inicia la grabación del archivo log donde se guardará todo el historial de la consola
log using "logs/procesamiento_modulo01.log", replace text

* Muestra en pantalla la fecha y hora de inicio
display "Inicio de ejecucion: " c(current_date) " " c(current_time)

* ------------------------------------------------------------------------------
* 2. VERIFICACIÓN E INSTALACIÓN AUTOMÁTICA DE DEPENDENCIAS
* ------------------------------------------------------------------------------

* Revisa si los paquetes estout y outreg2 están instalados; si no, los instala automáticamente
local packages estout outreg2
foreach pkg in `packages' {
    capture which `pkg'
    if _rc != 0 {
        display "Instalando paquete requerido: `pkg'"
        ssc install `pkg', replace
    }
}

* ------------------------------------------------------------------------------
* 3. CARGA DE DATOS
* ------------------------------------------------------------------------------

* Carga la base de datos principal de Chile (CASEN 2024)
use "data/raw/chile/casen_2024.dta", clear

* NOTA: Las bases de Argentina y Brasil se dejan comentadas temporalmente 
* para no sobrecargar la memoria RAM durante las pruebas del Módulo 01.
* import excel "data/raw/argentina/usu_hogar_T126.xlsx", firstrow clear
* save "data/processed/argentina/usu_hogar_T126.dta", replace
* import delimited "data/raw/brasil/PNADC_012026.txt", clear

* ------------------------------------------------------------------------------
* 4. LIMPIEZA, FILTRADO Y CREACIÓN DE VARIABLES
* ------------------------------------------------------------------------------

* Mantiene únicamente las variables necesarias para el estudio
keep folio region sexo edad numper ytotcorh expr

* Elimina del análisis los casos sin información de ingresos (valores perdidos)
drop if missing(ytotcorh)

* Renombra variables para que sus nombres sean más claros y descriptivos
rename numper numero_personas
rename ytotcorh ingreso_total

* Calcula la variable 'ingreso per cápita' (Ingreso Total / Personas en el hogar)
generate ingreso_percapita = ingreso_total / numero_personas
label variable ingreso_percapita "Ingreso per cápita del hogar (CLP)"

* Construye la variable categórica para tramos de edad (1: 0-14, 2: 15-64, 3: 65+)
generate tramo_edad = .
replace tramo_edad = 1 if edad >= 0 & edad <= 14
replace tramo_edad = 2 if edad >= 15 & edad <= 64
replace tramo_edad = 3 if edad >= 65 & !missing(edad)

* Define y asigna las etiquetas de texto a los tramos de edad
label define etiquetas_edad 1 "0 a 14 años" 2 "15 a 64 años" 3 "65 o más años"
label values tramo_edad etiquetas_edad
label variable tramo_edad "Tramo etario"

* Guarda la base de datos limpia y procesada en la carpeta 'processed'
save "data/processed/chile/casen_2024_procesada.dta", replace

* ------------------------------------------------------------------------------
* 5. EXPORTACIÓN AUTOMÁTICA DE RESULTADOS A LATEX (OVERLEAF / GITHUB)
* ------------------------------------------------------------------------------

* A. TABLA DESCRIPTIVA: Tramos de Edad
eststo clear
* Calcula frecuencias y porcentajes ponderados por el factor de expansión
estpost tabulate tramo_edad [fw=round(expr)]

* Exporta la tabla en formato LaTeX (.tex) a la carpeta 'output/tables'
esttab using "output/tables/tabla_tramo_edad.tex", replace ///
    cell("b(fmt(0)) pct(fmt(2))") ///
    collabels("Frecuencia" "Porcentaje") ///
    unstack noobs nonumber ///
    booktabs ///
    title("Distribución por Tramos de Edad (CASEN 2024)")

* B. TABLA DESCRIPTIVA: Estadísticas de variables continuas
eststo clear
* Calcula Media, Desviación Estándar, Mediana, Mínimo y Máximo ponderados
estpost summarize ingreso_percapita numero_personas edad [aw=expr], detail

* Exporta los descriptivos a LaTeX
esttab using "output/tables/tabla_estadisticas_descriptivas.tex", replace ///
    cells("mean(fmt(2)) sd(fmt(2)) p50(fmt(2)) min(fmt(2)) max(fmt(2))") ///
    collabels("Media" "Desv. Est." "Mediana" "Mínimo" "Máximo") ///
    booktabs nonumber ///
    title("Estadísticas Descriptivas de Variables Clave")

* C. GENERACIÓN Y EXPORTACIÓN DE GRÁFICOS
* Crea un histograma del ingreso per cápita para personas con ingresos menores a $2.000.000 CLP
histogram ingreso_percapita [fw=round(expr)] if ingreso_percapita < 2000000, ///
    title("Distribución del Ingreso Per Cápita del Hogar") ///
    subtitle("Población con ingresos menores a $2.000.000 CLP") ///
    xtitle("Ingreso Per Cápita ($)") ytitle("Densidad") ///
    graphregion(color(white))

* Exporta el gráfico en formato PDF vectorial para alta calidad en Overleaf
graph export "output/figures/histograma_ingresos.pdf", as(pdf) replace

* Muestra mensaje final de éxito en la consola y cierra la grabación del Log
display "Procesamiento y exportacion finalizados correctamente: " c(current_date) " " c(current_time)
log close