# Loading packages (install if not yet installed)
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, readr, plyr, RColorBrewer, raster, maps, rgdal, egg, hexbin, tictoc, extrafont)

soil <- readOGR(dsn = "/Users/laz/Downloads/Bodeneignungskarte_Landwirtschaft_D/Bodeneignungskarte der Schweiz LV95 Shape/Bodeneignungskarte_LV95.shp", stringsAsFactors = F)
border <- readOGR(dsn = "/Users/laz/Library/Mobile Documents/com~apple~CloudDocs/Projects/restaurants/svizzera/geodata/Shapefiles/23_DKM500_HOHEITSGRENZE.shp", stringsAsFactors = F)
  
# Transform coordinates
crs(soil)
soil <- spTransform(soil, "+init=epsg:4326")
border <- spTransform(border, "+init=epsg:4326")

# generate a unique ID for each polygon
soil@data$seq_id <- seq(1:nrow(soil@data))

# in order to plot polygons, first fortify the data
soil@data$id <- rownames(soil@data)
border@data$id <- rownames(border@data)

# create a data.frame from our spatial object
soildata <- fortify(soil, region = "id")
borderdata <- fortify(border, region = "id")

# merge the "fortified" data with the data from our spatial object
soildf <- merge(soildata, soil@data,
                   by = "id")
borderdata <- merge(borderdata, border@data,
                by = "id")

# Coordinating
x_center = 8.117523
x_range = 0.75
y_center = 47.337892
y_range = 0.4

xmin = x_center-x_range/2 #8.053150 #
xmax = x_center+x_range/2 #8.180523 #

ymin = y_center-y_range/2 #47.299489 #
ymax = y_center+y_range/2 #47.364874 #

soildf_red <- subset(soildf, (long > xmin) & (long < xmax) & (lat > ymin) & (lat < ymax))
borderdata_red <- subset(borderdata, (long > xmin) & (long < xmax) & (lat > ymin) & (lat < ymax))

# Labelling
soildf_red$kategorie <- soildf_red$Eignungsei

soildf_red$kategorie <- gsub("(.*),.*", "\\1", soildf_red$Eignungsei)
soildf_red$kategorie[grep("vieh",soildf_red$kategorie)] <- "Viehweide"
soildf_red$kategorie[grep("Acker",soildf_red$kategorie)] <- "Acker"
soildf_red$kategorie[grep("Getreide",soildf_red$kategorie)] <- "Getreide"
soildf_red$kategorie[grep("Futterbau",soildf_red$kategorie)] <- "Futterbau"
soildf_red$kategorie[grep("futterbau",soildf_red$kategorie)] <- "Futterbau"
soildf_red$kategorie[grep("Naturf-b",soildf_red$kategorie)] <- "Futterbau"
soildf_red$kategorie[grep("Siedlungsgebiet",soildf_red$kategorie)] <- "Siedlungsgebiet"
soildf_red$kategorie[grep("Seen",soildf_red$kategorie)] <- "See"

# Plot
p <- ggplot() +
  geom_polygon(data = soildf_red, 
                        aes(x = long, y = lat, group = group, fill = kategorie), alpha = 0.7) +
  geom_path(data = borderdata_red, 
                     aes(x = long, y = lat, group = group), size = 0.7, alpha = 0.9) +
  theme_void() +
  coord_map(xlim=c(xmin,xmax), ylim=c(ymin,ymax)) +
  theme(panel.background=element_blank()) +
  scale_fill_manual(breaks = c("Acker","Futterbau","Getreide","See","Siedlungsgeiet","Viehweide"),
                     values = c("brown","chocolate","gold","cornflowerblue","white","green")) +
  theme(panel.background= element_rect(color="black")) +
  theme(axis.title = element_blank(), axis.text = element_blank()) +
  labs(title = "Bodenstruktur",
       fill = "Kategorie")
p 

# Saving
ggsave(plot = p, dpi = 320, filename = "bodenstruktur.png")



