# code as issue02c.R but with u set to NA for the northeast point
library(oce)
source("wb.R")
data(coastlineWorld)
if (!interactive()) png("issue04.png", width = 7, height = 7, unit = "in", res = 200)
par(mar = rep(2, 4))
mapPlot(coastlineWorld,
    border = "black",
    col = "grey95",
    projection = "+proj=lcc +lat_1=60 +lat_2=65 +lon_0=-115",
    longitudelim = c(-140, -90), latitudelim = c(55, 70)
)
lon <- -110
lat <- 60
u <- 15
v <- 15
U <- sqrt(u^2 + v^2)

dlat <- 5
dlon <- 10

cat(sprintf("Flow to northeast (u=%.0f v=%.0f)\n", u, v))

mapPoints(lon, lat)
mapDirectionField(lon, lat,
    u = u, v = v, scale = .1,
    length = .08, code = 2, col = 2
)
mapDirectionFieldBarbs(lon, lat, u = u, v = v, scale = 1.5, col = 4)

mapPoints(lon - dlon, lat)
mapDirectionField(lon - dlon, lat,
    u = u, v = v, scale = .1,
    length = .08, code = 2, col = 2
)
mapDirectionFieldBarbs(lon - dlon, lat, u = u, v = v, scale = 1.5, col = 4)

mapPoints(lon + dlon, lat)
mapDirectionField(lon + dlon, lat,
    u = u, v = v, scale = .1,
    length = .08, code = 2, col = 2
)
mapDirectionFieldBarbs(lon + dlon, lat, u = u, v = v, scale = 1.5, col = 4)

cat(sprintf("Flow to east (u=%.0f v=%.0f)\n", U, 0))
mapPoints(lon, lat - dlat)
mapDirectionField(lon, lat - dlat,
    u = U, v = 0, scale = .1,
    length = .08, code = 2, col = 2
)
mapDirectionFieldBarbs(lon, lat - dlat, u = U, v = 0, scale = 1.5, col = 4)

mapPoints(lon - dlon, lat - dlat)
mapDirectionField(lon - dlon, lat - dlat,
    u = U, v = 0, scale = .1,
    length = .08, code = 2, col = 2
)
mapDirectionFieldBarbs(lon - dlon, lat - dlat, u = U, v = 0, scale = 1.5, col = 4)

mapPoints(lon + dlon, lat - dlat)
mapDirectionField(lon + dlon, lat - dlat,
    u = U, v = 0, scale = .1,
    length = .08, code = 2, col = 2
)
mapDirectionFieldBarbs(lon + dlon, lat - dlat, u = U, v = 0, scale = 1.5, col = 4)

cat(sprintf("Flow to north (u=%.0f v=%.0f)\n", 0, U))
mapPoints(lon, lat + dlat)
mapDirectionField(lon, lat + dlat,
    u = 0, v = U, scale = .1,
    length = .08, code = 2, col = 2
)
mapDirectionFieldBarbs(lon, lat + dlat, u = 0, v = U, scale = 1.5, col = 4)

mapPoints(lon - dlon, lat + dlat)
mapDirectionField(lon - dlon, lat + dlat,
    u = 0, v = U, scale = .1,
    length = .08, code = 2, col = 2
)
mapDirectionFieldBarbs(lon - dlon, lat + dlat, u = 0, v = U, scale = 1.5, col = 4)

mapPoints(lon + dlon, lat + dlat)
mapDirectionField(lon + dlon, lat + dlat,
    u = NA, v = U, scale = .1,
    length = .08, code = 2, col = 2
)
mapDirectionFieldBarbs(lon + dlon, lat + dlat, u = NA, v = U, scale = 1.5, col = 4)

if (!interactive()) dev.off()
