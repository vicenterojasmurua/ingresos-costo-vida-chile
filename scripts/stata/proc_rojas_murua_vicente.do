* ==============================================================================
* PROYECTO: Tesis de Licenciatura en Sociología
* AUTOR: Vicente Rojas
* INSTITUCIÓN: Universidad de Chile - Facultad de Ciencias Sociales
* MÓDULO 01: Carga, Procesamiento de Datos y Exportación a LaTeX (Overleaf)
* REPRODUCIBILIDAD Y OPEN SCIENCE COMPATIBLE
* ==============================================================================

* ------------------------------------------------------------------------------
* 1. CONFIGURACIÓN INICIAL Y ENTORNO REPRODUCIBLE
* ------------------------------------------------------------------------------

clear all
set more off
macro drop _all

version 17
set seed 20260822

* Definición explícita del directorio del proyecto
cd "C:\Users\vroja\OneDrive\Escritorio\VIRTUAL STUDIO CODE\ingresos-costo-vida-chile"

* Creación automática de la estructura completa de carpetas (Previene error r(603))
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

cap log close
log using "logs/procesamiento_modulo01.log", replace text

display "Inicio de ejecucion: " c(current_date) " " c(current_time)

* ------------------------------------------------------------------------------
* 2. VERIFICACIÓN E INSTALACIÓN AUTOMÁTICA DE DEPENDENCIAS (PACKAGE MANAGEMENT)
* ------------------------------------------------------------------------------

* Librerías necesarias para la exportación directa a LaTeX/Overleaf
local packages estout outreg2
foreach pkg in `packages' {
    capture which `pkg'
    if _rc != 0 {
        display "Instalando paquete requerido: `pkg'"
        ssc install `pkg', replace
    }
}

* ------------------------------------------------------------------------------
* 3. CARGA Y PROCESAMIENTO DE DATOS
* ------------------------------------------------------------------------------

* A. CHILE - CASEN 2024
use "data/raw/chile/casen_2024.dta", clear

* B. ARGENTINA - EPH
import excel "data/raw/argentina/usu_hogar_T126.xlsx", firstrow clear
rename *, lower
save "data/processed/argentina/usu_hogar_T126.dta", replace

* C. BRASIL - PNAD CONTÍNUA
import delimited "data/raw/brasil/PNADC_012026.txt", clear

* Volvemos a la base principal de trabajo (Chile - CASEN 2024)
use "data/raw/chile/casen_2024.dta", clear

* ------------------------------------------------------------------------------
* 4. LIMPIEZA, FILTRADO Y CREACIÓN DE VARIABLES
* ------------------------------------------------------------------------------

keep folio region sexo edad numper ytotcorh expr
drop if missing(ytotcorh)

rename numper numero_personas
rename ytotcorh ingreso_total

* Generación de variables derivadas
generate ingreso_percapita = ingreso_total / numero_personas
label variable ingreso_percapita "Ingreso per cápita del hogar (CLP)"

generate tramo_edad = .
replace tramo_edad = 1 if edad >= 0 & edad <= 14
replace tramo_edad = 2 if edad >= 15 & edad <= 64
replace tramo_edad = 3 if edad >= 65 & !missing(edad)

label define etiquetas_edad 1 "0 a 14 años" 2 "15 a 64 años" 3 "65 o más años"
label values tramo_edad etiquetas_edad
label variable tramo_edad "Tramo etario"

* Save processed data (Garantiza datos limpios e intermedios para replicación)
save "data/processed/chile/casen_2024_procesada.dta", replace

* ------------------------------------------------------------------------------
* 5. EXPORTACIÓN AUTOMÁTICA DE RESULTADOS A LATEX (OVERLEAF / GITHUB)
* ------------------------------------------------------------------------------

* A. TABLA DESCRIPTIVA: Frecuencias de Tramo de Edad e Ingreso Per Cápita
eststo clear
estpost tabulate tramo_edad [aw=expr]

esttab using "output/tables/tabla_tramo_edad.tex", replace ///
    cell("b(fmt(0)) pct(fmt(2))") ///
    collabels("Frecuencia" "Porcentaje") ///
    unstack noobs nonumber ///
    booktabs ///
    title("Distribución por Tramos de Edad (CASEN 2024)\label{tab:tramo_edad}")

* B. TABLA DESCRIPTIVA DE RESUMEN ESTADÍSTICO
eststo clear
estpost summarize ingreso_percapita numero_personas edad [aw=expr], detail

esttab using "output/tables/tabla_estadisticas_descriptivas.tex", replace ///
    cells("mean(fmt(2)) sd(fmt(2)) p50(fmt(2)) min(fmt(2)) max(fmt(2))") ///
    collabels("Media" "Desv. Est." "Mediana" "Mínimo" "Máximo") ///
    booktabs nonumber ///
    title("Estadísticas Descriptivas de Variables Clave\label{tab:descriptivos}")

* C. GENERACIÓN Y EXPORTACIÓN DE GRÁFICOS (Vectorial .PDF para Overleaf)
* Opción recomendada: Usar fweights redondeando el factor de expansión
histogram ingreso_percapita [fw=round(expr)] if ingreso_percapita < 2000000, ///
    title("Distribución del Ingreso Per Cápita del Hogar") ///
    subtitle("Población con ingresos menores a $2.000.000 CLP") ///
    xtitle("Ingreso Per Cápita ($)") ytitle("Densidad") ///
    graphregion(color(white))

* Exportación en PDF vectorial para Overleaf
graph export "output/figures/histograma_ingresos.pdf", as(pdf) replace

display "Procesamiento y exportacion finalizados correctamente: " c(current_date) " " c(current_time)
log close