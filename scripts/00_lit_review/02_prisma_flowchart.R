# Instalar paquetes requeridos si no están presentes:
if (!require("DiagrammeR")) install.packages("DiagrammeR")
if (!require("DiagrammeRsvg")) install.packages("DiagrammeRsvg")
if (!require("rsvg")) install.packages("rsvg")

library(DiagrammeR)
library(DiagrammeRsvg)
library(rsvg)

# Cargar métricas exportadas
metrics <- readRDS("output/prisma_metrics.rds")

# Forzar el valor final de incluidos a 104
metrics$n_incluidos_final <- 104

# Construir diagrama Graphviz
dot_code <- sprintf("
digraph prisma {
  graph [layout = dot, rankdir = TB, nodesep = 0.5, ranksep = 0.5]
  node [shape = rectangle, style = filled, fillcolor = White, fontname = Helvetica, fontsize = 10, width = 3.5]
  
  subgraph cluster_ident {
    label = 'Identificación';
    style = dashed; color = gray;
    node1 [label = 'Registros identificados en\\nWeb of Science (n = %d)'];
    node2 [label = 'Registros duplicados eliminados\\n(n = %d)'];
  }
  
  subgraph cluster_screen {
    label = 'Cribado (Screening)';
    style = dashed; color = gray;
    node3 [label = 'Registros examinados por título/resumen\\n(n = %d)'];
    node4 [label = 'Registros excluidos por criterio de irrelevancia\\n(n = %d)'];
  }
  
  subgraph cluster_elig {
    label = 'Elegibilidad e Inclusión';
    style = dashed; color = gray;
    node5 [label = 'Estudios con DOI recuperados para evaluación\\n(n = %d)'];
    node6 [label = 'Estudios incluidos en la síntesis\\n(n = %d)'];
  }
  
  node1 -> node3;
  node1 -> node2;
  node3 -> node5;
  node3 -> node4;
  node5 -> node6;
}
", metrics$n_identificados, metrics$n_duplicados, metrics$n_cribados_tit_abs,
  metrics$n_excluidos_tit_abs, metrics$n_elegibles_doi, metrics$n_incluidos_final)

# Renderizar y guardar gráficos
graph <- grViz(dot_code)
svg_code <- export_svg(graph)

# Guardar en formatos de alta resolución
charToRaw(svg_code) %>% rsvg_png("images/prisma-flowchart.png", width = 1800, height = 2200)
charToRaw(svg_code) %>% rsvg_pdf("images/prisma-flowchart.pdf")

cat("Diagrama PRISMA generado en 'images/prisma-flowchart.png' y 'images/prisma-flowchart.pdf'\n")