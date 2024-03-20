library(oce)
source("wb.R")
load("exwindbarb.RData")
data(coastlineWorld)
if (!interactive()) png("issue02a.png")
mapPlot(coastlineWorld,
    border = "black",
    col = "grey95",
    projection = "+proj=lcc +lat_0=63 +lat_1=33 +lat_2=45 +lon_0=-110",
    longitudelim = c(-140, -90), latitudelim = c(57, 70)
)

mapDirectionField(lons, lats,
    u = u,
    v = v,
    scale = .02,
    length = .08, code = 2, col = "red"
)

mapDirectionFieldBarbs(lons, lats,
    u = u,
    v = v,
    length = 1.5,
    code = 2, col = "blue"
)
if (!interactive()) dev.off()
