# vectorized feather computation
feathers <- function(u, step = 10, debug = FALSE) {
    if (debug) message("initially u=", paste(u, collapse = " "))
    fac <- 5 * step
    pennant <- floor(u / fac)
    if (debug) print(pennant)
    u <- u - fac * pennant
    u <- ifelse(u < 0, 0, u)
    if (debug) message("after pennant, u=", paste(u, collapse = " "))
    fac <- step
    barb <- floor(u / fac)
    u <- u - fac * barb
    u <- ifelse(u < 0, 0, u)
    if (debug) print(barb)
    u <- ifelse(u < 0, 0, u)
    if (debug) message("after barb, u=", paste(u, collapse = " "))
    demibarb <- floor(u / step)
    cbind(pennant, barb, demibarb)
}

windBarbs <- function(longitude, latitude, u, v,
                      length = 5, step = 10, lwd = 1, col = 1,
                      round10 = FALSE, debug = FALSE) {
    lengthXY <- length * 111e3 # per metre
    lon0 <- longitude
    lat0 <- latitude
    theta <- 180 / pi * atan2(v, u)
    # By default, not rounding to nearest 10deg, which I've seen suggested,
    # but which seems way too coarse, to my mind.
    if (round10) {
        theta <- 10 * round(theta / 10)
    }
    S <- sinpi(theta / 180)
    C <- cospi(theta / 180)
    lat1 <- lat0 - S * length
    lon1 <- lon0 - C * length / cospi(lat0 / 180)
    xy0 <- lonlat2map(as.vector(lon0), as.vector(lat0))
    x0 <- xy0$x
    y0 <- xy0$y
    xy1 <- lonlat2map(as.vector(lon1), as.vector(lat1))
    x1 <- xy1$x
    y1 <- xy1$y
    thetaPage <- 180 / pi * atan2(y1 - y0, x1 - x0)
    phi <- 70 # degrees to rotate barbs (70 by eye)
    barbLwd <- lwd
    barbCol <- col
    flagCol <- col
    barbLength <- 0.2 * lengthXY
    # D <- 0.11 # barb separation (Used??)
    triangleWidth <- 2 * barbLength * cospi(phi / 180)
    triangleLength <- 0.5 * triangleWidth / cospi(phi / 180) # or sin?
    barbSpace <- barbLength * cospi(phi / 180)
    ds <- 0.2 * cospi(phi / 180)
    if (debug) {
        cat(sprintf(
            "length: %.4f, barbLength: %.4f, barbSpace: %.4f, triangleWidth: %.4f\ntriangleLength: %.4f\n",
            length, barbLength, barbSpace, triangleWidth, triangleLength
        ))
    }
    knots <- TRUE
    speed <- sqrt(u^2 + v^2)
    speedOrig <- speed
    speed <- speedOrig * if (knots) 1 else 1.94384 # FIXME: factor likely wrong
    speed <- 5L * as.integer(round(speed / 5))
    Spage <- sinpi(thetaPage / 180)
    Cpage <- cospi(thetaPage / 180)
    if (debug) {
        cat(sprintf("  lat0=%.1f lat1=%.1f\n", lat0, lat1))
        cat(sprintf("  lon0=%.1f lon1=%.1f\n", lon0, lon1))
        cat(sprintf(
            "  theta=%.0f thetaPage=%.0f Spage=%.0f Cpage=%.0f lengthXY=%.0f\n",
            theta, thetaPage, Spage, Cpage, lengthXY
        ))
    }
    x1 <- x0 + lengthXY * Cpage
    y1 <- y0 + lengthXY * Spage
    notStill <- speed != 0
    # points(x0[notStill], y0[notStill])
    segments(x0[notStill], y0[notStill], x1[notStill], y1[notStill], col = barbCol, lwd = barbLwd)
    f <- feathers(speed, step = step, debug = debug)
    angleBarb <- thetaPage - phi
    for (i in seq_along(x0)) {
        fi <- f[i, ]
        j <- sum(fi)
        code <- c(rep(1, fi[["pennant"]]), rep(2, fi[["barb"]]), rep(3, fi[["demibarb"]]))
        lowestNonzero <- identical(as.numeric(fi), c(0, 0, 1))
        stagnant <- speedOrig[i] == 0
        verySlow <- speedOrig[i] < 2.5
        if (debug) {
            cat(sprintf(
                "i=%d, speed=%.2f, theta=%.2f, thetaPage=%.2f, f=%s, verySlow %s, lowestNonzero=%s\n",
                i, speed[i], theta[i], thetaPage[i], paste(f[i, ], collapse = " "),
                if (verySlow) "TRUE" else "FALSE",
                if (lowestNonzero) "TRUE" else "FALSE"
            ))
            if (debug) {
                text(x0[i], y0[i], round(speedOrig[i], 1), pos = 1, cex = 0.7, col = 2, font = 2)
            }
        }
        if (stagnant) {
            points(x0[i], y0[i], col = barbCol, cex = 0.5)
        } else if (verySlow) {
            segments(x0[i], y0[i], x1[i], y1[i], col = barbCol, lwd = barbLwd)
        } else {
            lastCode <- 0 # used to nudge triangles together
            BLC <- barbLength * cospi(angleBarb[i] / 180)
            BLS <- barbLength * sinpi(angleBarb[i] / 180)
            s <- 1 # position of next item (0 at x0, 1 at x1)
            for (jj in seq_len(j)) {
                thisCode <- code[jj]
                x0i <- x0[i]
                y0i <- y0[i]
                x1i <- x1[i]
                y1i <- y1[i]
                delta <- if (thisCode == 1) 2 else if (thisCode == 2) 1.0 else if (thisCode == 3) 0.6
                if (debug) {
                    cat(sprintf(
                        "  jj: %d, code: %d, lastCode:%d, delta: %.3f",
                        jj, code[jj], lastCode, delta
                    ))
                }
                if (thisCode == 1) { # triangle
                    if (debug) {
                        cat("drawing with thisCode=", thisCode, "\n")
                        cat(sprintf(
                            "theta=%.4f, thetaPage=%.4f, barbSpace=%.4f, barbLength=%.4f, triangleLength=%.4f, triangleWidth=%.4f\n",
                            theta[i], thetaPage[i],
                            barbSpace,
                            barbLength,
                            triangleLength,
                            triangleWidth
                        ))
                    }
                    if (lastCode == 1) { # nudge triangles together
                        s <- s + ds
                    }
                    x <- x0i + s * (x1i - x0i)
                    y <- y0i + s * (y1i - y0i)
                    xt <- x + c(
                        0,
                        -triangleLength * cospi((phi + thetaPage[i]) / 180),
                        -triangleWidth * cospi(thetaPage[i] / 180)
                    )
                    yt <- y + c(
                        0,
                        -triangleLength * sinpi((phi + thetaPage[i]) / 180),
                        -triangleWidth * sinpi(thetaPage[i] / 180)
                    )
                    if (debug) {
                        cat(
                            sprintf(
                                "delta=%.3f s=%.3f thetaPage=%.3f length=%.3f triangleWidth=%.4f triangleLength=%.4f\n",
                                delta, s, thetaPage, length, triangleWidth, triangleLength
                            )
                        )
                    }
                    polygon(xt, yt, col = flagCol, border = flagCol)
                    s <- s - 3 * ds # (triangleWidth + barbSpace)
                } else if (thisCode == 2 || thisCode == 3) { # barb
                    if (lowestNonzero) {
                        s <- s - ds # barbSpace / length
                    }
                    x <- x0i + s * (x1i - x0i)
                    y <- y0i + s * (y1i - y0i)
                    segments(x, y, x + delta * BLC, y + delta * BLS, col = barbCol, lwd = barbLwd)
                    s <- s - ds
                }
                lastCode <- thisCode
            }
        }
    }
}

# FIXME: if put into oce, document parameters, explain
# plot, give an example, set up familial links with
# sibling functions, etc.
mapDirectionFieldBarbs <- function(
    longitude, latitude, u, v,
    length = 1, step = 10, col = par("fg"), lwd = par("lwd"),
    debug = FALSE, ...) {
    # Check (and flatten location and velocity parameters)
    if (!is.vector(longitude)) {
        stop("longitude must be a vector")
    }
    if (!is.vector(latitude)) {
        stop("latitude must be a vector")
    }
    if (is.matrix(u) || is.matrix(v)) {
        if (!is.matrix(u) || !is.matrix(v)) {
            stop("if either of u or v is a matrix, then both must be")
        }
        if (!identical(dim(u), dim(v))) {
            stop("u and v must have identical dimensions")
        }
        nlon <- length(longitude)
        nlat <- length(latitude)
        if (nlon != nrow(u)) {
            stop("length of longitude must match number of rows in u")
        }
        if (nlat != ncol(u)) {
            stop("length of latitude must match number of columns in u")
        }
        longitude <- matrix(rep(longitude, nlat), nrow = nlon)
        latitude <- matrix(rep(latitude, nlon), byrow = TRUE, nrow = nlon)
        longitude <- as.vector(longitude)
        latitude <- as.vector(latitude)
        u <- as.vector(u)
        v <- as.vector(v)
    }
    longitude <- oce:::angleShift(longitude)
    latitude <- oce:::angleShift(latitude)
    windBarbs(longitude, latitude,
        u = u, v = v,
        length = length, step = step, debug = debug, col = col, lwd = lwd
    )
}
