# Load the barb-drawing code. This is wrapped in
# a test, to avoid reloading it over and over, during
# testing/developing work.  Eventually something like
# this could go into the oce package, in which case
# just using library(oce) will suffice.
if (!exists("mapDirectionFieldBarbs")) {
    source("wb.R")
}

# Step 1: create fake wind data
lon <- seq(-120, -60, 15)
lat <- 45 + seq(-15, 15, 5)
lonm <- matrix(expand.grid(lon, lat)[, 1], nrow = length(lon))
latm <- matrix(expand.grid(lon, lat)[, 2], nrow = length(lon))
theta <- 45 # math notation (CW of north), not meteorology notation
N <- prod(dim(lonm))
speed <- c(0:10, seq(7, 130, length.out = N - 11))
u <- matrix(speed * cospi(theta / 180), nrow = nrow(lonm), ncol = ncol(lonm))
v <- matrix(speed * sinpi(theta / 180), nrow = nrow(lonm), ncol = ncol(lonm))
lon <- as.vector(lonm)
lat <- as.vector(latm)
u <- as.vector(u)
v <- as.vector(v)
l <- seq_along(u)

# Step 2: create map underlay
if (!interactive()) {
    png("wb.png", unit = "in", width = 7, height = 5, res = 200)
}
library(oce)
data(coastlineWorld)
par(mar = rep(2, 4))
mapPlot(coastlineWorld,
    longitudelim = -90 + c(-35, 35), latitudelim = c(30, 60),
    projection = "+proj=lcc +lat_1=30 +lat_2=60 +lon_0=-90",
    col = gray(0.95), border = gray(0.6)
)

# Step 3: add wind barbs (using debug=TRUE to show speeds)
mapDirectionFieldBarbs(lon[l], lat[l], u[l], v[l], length = 5, debug = TRUE)

if (!interactive()) {
    dev.off()
}
