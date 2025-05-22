library(leaflet)
library(readxl)
library(htmlwidgets)
library(dplyr)
library(tidyr)
library(stringr)

# Leer archivo
datoos <- read_excel("datoos.xlsx")

datoos <- datoos %>%
  rename(
    latitud = X,
    longitud = Y,
    altitud = Altitud,
    especie = Especie,
    nombre_comun = `Nombre común`,
    observaciones = `Observaciones adicionales`
  ) %>%
  mutate(
    latitud = as.numeric(latitud),
    longitud = as.numeric(longitud),
    altitud = as.character(altitud),
    especie = ifelse(is.na(especie) | especie == "" | str_trim(especie) == "", "Sin dato", as.character(especie)),
    nombre_comun = ifelse(is.na(nombre_comun) | nombre_comun == "" | str_trim(nombre_comun) == "", "Sin dato", as.character(nombre_comun)),
    observaciones = ifelse(is.na(observaciones) | observaciones == "" | str_trim(observaciones) == "", "Sin observaciones", as.character(observaciones))
  )


# Crear popups
datoos$popup <- paste(
  "<strong>Especie:</strong>", datoos$especie, "<br/>",
  "<strong>Nombre común:</strong>", datoos$nombre_comun, "<br/>",
  "<strong>Altitud:</strong>", datoos$altitud, " msnm<br/>",
  "<strong>Latitud:</strong>", datoos$latitud, "<br/>",
  "<strong>Longitud:</strong>", datoos$longitud, "<br/>",
  "<strong>Observaciones:</strong>", datoos$observaciones
)

icons = awesomeIcons(
  icon = 'paw',
  library = 'fa',
  iconColor = 'lightgray',
  markerColor = 'darkgreen')


# Crear mapa
mapaAvistamientos <- leaflet(datoos) %>%
  addTiles() %>%
  addAwesomeMarkers(
    lng = ~longitud,
    lat = ~latitud,
    popup = ~popup,
    label = ~nombre_comun,
    icon=icons,
    clusterOptions = markerClusterOptions()
  )

mapaAvistamientos




# Guardar el mapa como archivo HTML
saveWidget(mapaAvistamientos, "mapa_avistamientos.html", selfcontained = TRUE)
