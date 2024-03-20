library(oce)
source("wb.R")
load("exwindbarb.RData")
data(coastlineWorld)
if (!interactive()) png("issue02b.png")
mapPlot(coastlineWorld,
    border = "black",
    col = "grey95",
    projection = "+proj=lcc +lat_0=63 +lat_1=33 +lat_2=45 +lon_0=-110",
    longitudelim = c(-140, -90), latitudelim = c(57, 70)
)

# Found a point with mapLocator
#> selectLon <- -112.1021
#> selectLat <- 63.84438
#> wlon <- which.min((lons - selectLon)^2)
#> wlat <- which.min((lats - selectLat)^2)
#> print(lons[wlon])
#> print(lats[wlat])
#> print(u[wlon, wlat])
#> print(v[wlon, wlat])
lon <- -111.95
lat <- 63.95
u <- 13.53003
v <- 19.93275
mapDirectionField(lon, lat,
    u = u, v = v, scale = .1,
    length = .08, code = 2, col = "red"
)
mapDirectionFieldBarbs(lon, lat,
    u = u, v = v, length = 3,
    code = 2, col = "blue"
)
if (!interactive()) dev.off()
