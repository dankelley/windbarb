library(oce)
source("wb.R")
load("exwindbarb.RData")
data(coastlineWorld)
if (!interactive()) png("issue02b.png", width = 7, height = 7, unit = "in", res = 200)
mapPlot(coastlineWorld,
    border = "black",
    col = "grey95",
    projection = "+proj=lcc +lat_1=60 +lat_2=65 +lon_0=-115",
    longitudelim = c(-140, -90), latitudelim = c(55, 70)
)
lon <- -111.95
lat <- 63.95
u <- 13.53003
v <- 19.93275
mapDirectionField(lon, lat,
    u = u, v = v, scale = .1,
    length = .08, code = 2, col = 2
)
mapDirectionFieldBarbs(lon, lat, u = u, v = v, scale = 1.5, col = 4)
if (!interactive()) dev.off()
