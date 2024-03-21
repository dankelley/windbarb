library(oce)
source("wb.R")
# geostrophic wind (formulae in SI units)
geos <- function(x, y, R = 100e3, f = 1e-4, rho = 1.2,
                 highP = 101.5e3, lowP = 98e3) {
    E <- exp(-(x^2 + y^2) / R^2)
    deltaP <- highP - lowP
    P <- highP - deltaP * E
    dPdx <- 2 * deltaP * x / R^2 * E
    dPdy <- 2 * deltaP * y / R^2 * E
    u <- -dPdy / rho / f
    v <- dPdx / rho / f
    list(P = P, dPdx = dPdx, dPdy = dPdy, u = u, v = v)
}

N <- 50
x <- seq(-2500, 2500, length.out = N) * 1e3
y <- seq(-2500, 2500, length.out = N) * 1e3
grid <- expand.grid(x = x, y = y)
# Simulate a 3 millibar (3e3 Pa) pressure low, with radius 1000km (1000e3 m)
g <- geos(grid$x, grid$y, R = 1500e3, highP = 101.5e3, lowP = 97e3)
P <- matrix(g$P, byrow = FALSE, nrow = N)
u <- matrix(g$u, byrow = FALSE, nrow = N)
v <- matrix(g$v, byrow = FALSE, nrow = N)
if (!interactive()) png("storm.png")
data(coastlineWorld)
par(mar = c(2, 2, 1, 1), mgp = c(2, 0.7, 0))
mapPlot(coastlineWorld,
    border = "black",
    col = "grey95",
    projection = "+proj=lcc +lat_0=63 +lat_1=33 +lat_2=45 +lon_0=-100",
    longitudelim = c(-140, -50), latitudelim = c(40, 70)
)

points(0, 0, col = 2, pch = 20)

contour(x, y, P, add = TRUE, col=3)
stop()

lonlat <- map2lonlat(x, y)
mapPoints(lonlat$longitude, lonlat$latitude)
mapDirectionFieldBarbs(lonlat$longitude, lonlat$latitude, u, v,
    scalex = 20, cex = 0, type = 2, length = 0.05,
    add = TRUE, col = 2, lwd = 2
)
mapContour(lonlat$longitude, lonlat$latitude, u)
#points(lonlat$longitude, lonlat$latitude)
#plot(x, lonlat$longitude)

if (!interactive()) dev.off()
