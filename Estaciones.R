library(leaflet)
library(htmlwidgets)
library(dplyr)
library(tidyr)
library(stringr)

# Leer archivo
camaras <- read.csv("Estaciones.csv")

camaras <- camaras %>%
  rename(
    latitud = X,
    longitud = Y,
    altitud = Altitud,
  #  estacion = `Estación`
    
  ) %>%
  mutate(
    latitud = as.numeric(latitud),
    longitud = as.numeric(longitud),
    Estación = as.character(Estación)
     )


# Crear popups
camaras$popup <- paste(
  "<strong>Estación:</strong>", camaras$Estación, "<br/>",
  "<strong>Altitud:</strong>", camaras$altitud, " msnm<br/>",
  "<strong>Latitud:</strong>", camaras$latitud, "<br/>",
  "<strong>Longitud:</strong>", camaras$longitud
)

# Crear mapa
mapaEstaciones <- leaflet(camaras) %>%
  addTiles() %>%
  addMarkers(
    lng = ~longitud,
    lat = ~latitud,
    popup = ~popup,
    clusterOptions = markerClusterOptions()
  )

mapaEstaciones




# Guardar el mapa como archivo HTML
saveWidget(mapaEstaciones, "mapa_estaciones.html", selfcontained = TRUE)
