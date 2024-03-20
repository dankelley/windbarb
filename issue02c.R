northeast <- !FALSE
north <- TRUE
east <- !FALSE
full <- !FALSE

library(oce)
source("wb.R")
load("exwindbarb.RData")
data(coastlineWorld)
if (!interactive()) png("issue02c.png")
par(mar = rep(2, 4))
mapPlot(coastlineWorld,
    border = "black",
    col = "grey95",
    projection = "+proj=lcc +lat_0=63 +lat_1=33 +lat_2=45 +lon_0=-110",
    longitudelim = c(-140, -90), latitudelim = c(57, 70)
)
lon <- -110
lat <- 60
u <- 15
v <- 15
U <- sqrt(u^2 + v^2)

dlat <- 4
dlon <- 8

if (northeast) {
    # Northeast
    mapDirectionField(lon, lat,
        u = u, v = v, scale = .1,
        length = .08, code = 2, col = 2
    )

    mapDirectionFieldBarbs(lon, lat,
        u = u, v = v, length = 2, code = 2, col = 4
    )

    mapDirectionField(lon - dlon, lat,
        u = u, v = v, scale = .1,
        length = .08, code = 2, col = 2
    )

    mapDirectionFieldBarbs(lon - dlon, lat,
        u = u, v = v, length = 2, code = 2, col = 4
    )

    mapDirectionField(lon + dlon, lat,
        u = u, v = v, scale = .1,
        length = .08, code = 2, col = 2
    )

    mapDirectionFieldBarbs(lon + dlon, lat,
        u = u, v = v, length = 2, code = 2, col = 4
    )
}

# East
if (east) {
    mapDirectionField(lon, lat - dlat,
        u = U, v = 0, scale = .1,
        length = .08, code = 2, col = 2
    )

    mapDirectionFieldBarbs(lon, lat - dlat,
        u = U, v = 0, length = 2, code = 2, col = 4
    )

    mapDirectionField(lon - dlon, lat - dlat,
        u = U, v = 0, scale = .1,
        length = .08, code = 2, col = 2
    )

    mapDirectionFieldBarbs(lon - dlon, lat - dlat,
        u = U, v = 0, length = 2, code = 2, col = 4
    )

    mapDirectionField(lon + dlon, lat - dlat,
        u = U, v = 0, scale = .1,
        length = .08, code = 2, col = 2
    )

    mapDirectionFieldBarbs(lon + dlon, lat - dlat,
        u = U, v = 0, length = 2, code = 2, col = 4
    )
}

# North
cat(sprintf("Flow to NORTH (u=%.0f v=%.0f)\n", 0, U))
mapDirectionField(lon, lat + dlat,
    u = 0, v = U, scale = .1,
    length = .08, code = 2, col = 2
)

mapDirectionFieldBarbs(lon, lat + dlat,
    u = 0, v = U, length = 2, code = 2, col = 4
)
if (full) {
    mapDirectionField(lon - dlon, lat + dlat,
        u = 0, v = U, scale = .1,
        length = .08, code = 2, col = 2
    )

    mapDirectionFieldBarbs(lon - dlon, lat + dlat,
        u = 0, v = U, length = 2, code = 2, col = 4
    )

    mapDirectionField(lon + dlon, lat + dlat,
        u = 0, v = U, scale = .1,
        length = .08, code = 2, col = 2
    )

    mapDirectionFieldBarbs(lon + dlon, lat + dlat,
        u = 0, v = U, length = 2, code = 2, col = 4
    )
}


if (!interactive()) dev.off()
