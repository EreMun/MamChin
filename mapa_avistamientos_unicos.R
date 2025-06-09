library(leaflet)
library(readxl)
library(htmlwidgets)
library(dplyr)
library(tidyr)
library(stringr)

Datos <- NULL

# Leer archivo
#datoos <- read_excel("DATOS LIMPIOS.xlsx")
Datos <- read.csv("SRAP_2013-2024.csv")
View(Datos)

Datos <- Datos %>%
  rename(
    latitud = X,
    longitud = Y,
    especie = Especie,
    nombre_comun = `Nombre.común`,
    ID = `Código.de.la.foto`
  ) %>%
  mutate(
    latitud = as.numeric(latitud),
   longitud = as.numeric(longitud)
   # especie = ifelse(is.na(especie) | especie == "" | str_trim(especie) == "", "Sin dato", as.character(especie)),
  #  nombre_comun = ifelse(is.na(nombre_comun) | nombre_comun == "" | str_trim(nombre_comun) == "", "Sin dato", as.character(nombre_comun))
  )

unicos <- Datos %>% 
  select(nombre_comun, especie, latitud, longitud, ID)%>% 
  drop_na() %>% 
  count(especie, nombre_comun, latitud, longitud,
        name= "Numero")
View(unicos)

# Crear popups
unicos$popup <- paste(
  "<strong>Especie:</strong>", unicos$especie, "<br/>",
  "<strong>Nombre común:</strong>", unicos$nombre_comun, "<br/>",
  "<strong>No. de avistamientos:</strong>", unicos$Numero
)

#colores leyenda
colores <- c(
 "khaki2","#FB9A99", "darkturquoise","#FF7F00", "#CAB2D6", "deeppink1","skyblue2","orchid1","green1")

pal <- colorFactor(palette = colores, domain = unicos$nombre_comun)

#iconos
icons = awesomeIcons(
  icon = 'paw',
  library = 'fa',
  iconColor = pal(unicos$nombre_comun),
  markerColor ="white"
 )


# Crear mapa
mapaAvistamientos <- leaflet(unicos) %>%
  addProviderTiles(provider = providers$Esri.WorldImagery) %>%
  addAwesomeMarkers(
    lng = ~longitud,
    lat = ~latitud,
    popup = ~popup,
    label = ~nombre_comun,
    icon=icons,
    clusterOptions = markerClusterOptions()) %>% 
  addLegend(position = "bottomright", pal = pal, values = ~nombre_comun, opacity = 1)

#visualizar mapa
mapaAvistamientos


# Guardar el mapa como archivo HTML
saveWidget(mapaAvistamientos, "mapa_avistamientos_detalle.html", selfcontained = TRUE)
