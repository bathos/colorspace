
# Wrapper around specplot. Used by the tcltk interface.
PlotSpectrum <- function(pal.cols, cex=1.0, plot=TRUE)
   specplot(pal.cols,cex=cex,plot=plot)


# Plot map example 
PlotMap <- function(pal.cols,...) {
   n <- length(pal.cols)
   plot(0, 0, type="n", xlab="", ylab="", xaxt="n", yaxt="n", bty="n",
        xlim=c(-88.5, -78.6), ylim=c(30.2, 35.2), asp=1)
   polygon(colorspace::USSouthPolygon,
           col=pal.cols[cut(stats::na.omit(colorspace::USSouthPolygon$z), 
           breaks=0:n / n)])
}
  
# Plot heatmap example
PlotHeatmap <- function(pal.cols,...) {
   image(datasets::volcano, col=rev(pal.cols), xaxt="n", yaxt="n", useRaster=TRUE)
}
  
# Plot scatter example
.example_env <- new.env()
.example_env$xyhclust <- NULL
PlotScatter <- function(pal.cols,...) {
  
   # Generate artificial data 
   if (is.null(.example_env$xyhclust)) {
      set.seed(1071)
      x0 <- sin(pi * 1:60 / 30) / 5
      y0 <- cos(pi * 1:60 / 30) / 5
      xr <- c(0.1, -0.6, -0.7, -0.9,  0.4,  1.3, 1.0)
      yr <- c(0.3,  1.0,  0.1, -0.9, -0.8, -0.4, 0.6)
      dat <- data.frame(
        x=c(x0 + xr[1], x0 + xr[2], x0 + xr[3], x0 + xr[4], x0 + xr[5], 
            x0 + xr[6], x0 + xr[7]),
        y=c(y0 + yr[1], y0 + yr[2], y0 + yr[3], y0 + yr[4], y0 + yr[5], 
            y0 + yr[6], y0 + yr[7])
      )
      attr(dat, "hclust") <- stats::hclust(stats::dist(dat), method = "ward.D")
      dat$xerror <- stats::rnorm(nrow(dat), sd=stats::runif(nrow(dat), 0.05, 0.45))
      dat$yerror <- stats::rnorm(nrow(dat), sd=stats::runif(nrow(dat), 0.05, 0.45))
      .example_env$xyhclust <- dat
   }
   plot(.example_env$xyhclust$x +
        .example_env$xyhclust$xerror,
	.example_env$xyhclust$y +
	.example_env$xyhclust$yerror,
        col="black", bg=pal.cols[stats::cutree(attr(.example_env$xyhclust, "hclust"), length(pal.cols))],
        xlab="", ylab="", axes=FALSE, pch=21, cex=1.3)
}
  
# Plot spine example
PlotSpine <- function(pal.cols,...) {
   n <- length(pal.cols)
   
   # Rectangle dimensions
   off <- 0.015
   widths <- c(0.05, 0.1, 0.15, 0.1, 0.2, 0.08, 0.12, 0.16, 0.04)
   k <- length(widths)
   heights <- sapply(
      c(2.5, 1.2, 2.7, 1, 1.3, 0.7, 0.4, 0.2, 1.7),
      function(p) (0:n / n)^(1 / p)
   )
  
   # Rectangle coordinates
   xleft0 <- c(0, cumsum(widths + off)[-k])
   xleft <- rep(xleft0, each=n)
   xright <- xleft + rep(widths, each=n)
   ybottom <- as.vector(heights[-(n + 1), ])
   ytop <- as.vector(heights[-1, ])
  
   # Draw rectangles, borders, and annotation
   plot(0, 0, xlim=c(0, sum(widths) + off * (k - 1)), ylim=c(0, 1),
        xaxs="i", yaxs="i", main="", xlab="", ylab="",
        type="n", axes=FALSE)
   rect(xleft, ybottom, xright, ytop, col=rep(pal.cols, k),
        border=if(n < 10) "black" else "transparent")
   if(n >= 10) rect(xleft0, 0, xleft0 + widths, 1, border="black")
}
  
# Plot bar example
PlotBar <- function(pal.cols,...) {
   barplot(cbind(1.1 + abs(sin(0.5 + seq_along(pal.cols))) / 3,
           1.9 + abs(cos(1.1 + seq_along(pal.cols))) / 3,
           0.7 + abs(sin(1.5 + seq_along(pal.cols))) / 3,
           0.3 + abs(cos(0.8 + seq_along(pal.cols))) / 3),
           beside=TRUE, col=pal.cols, axes=FALSE)
}

# Plot pie example
PlotPie <- function(pal.cols,...) {
   pie(0.01 + abs(sin(0.5 + seq_along(pal.cols))), labels="", col=pal.cols, radius=1)
}
  
# Plot perspective example
PlotPerspective <- function(pal.cols,...) {
   # Mixture of bivariate normals
   n <- 31
   x1 <- x2 <- seq(-3, 3, length=n)
   y <- outer(x1, x2, 
              function(x, y) {
                0.5 * stats::dnorm(x, mean=-1, sd=0.80) * stats::dnorm(y, mean=-1, sd=0.80) +
                0.5 * stats::dnorm(x, mean= 1, sd=0.72) * stats::dnorm(y, mean= 1, sd=0.72)
              })

   # Compute color based on density
   if (length(pal.cols) > 1) {
      facet <- cut(y[-1, -1] + y[-1, -n] + y[-n, -1] + y[-n, -n], 
                   length(pal.cols))
      cols <- rev(pal.cols)[facet]
   } else {
      cols <- pal.cols
   }

   # Perspective plot coding z-axis with color
   persp(x1, x2, y, col=cols, phi=28, theta=20, r=5, xlab="", ylab="", zlab="")
}
  
# Plot mosaic example
.example_env$msc.matrix <- NULL
PlotMosaic <- function(pal.cols,...) {
   if (is.null(.example_env$msc.matrix)) {
      set.seed(1071)
      mat <- list()
      for (i in 1:50) {
         mat[[i]] <- matrix(stats::runif(i * 10, min=-1, max=1), nrow=10, ncol=i)
      }
      .example_env$msc.matrix <- mat
   }
   image(.example_env$msc.matrix[[length(pal.cols)]], col=pal.cols, xaxt="n", yaxt="n")
}
  
# Plot lines example
PlotLines <- function(pal.cols,...) {
   n <- length(pal.cols)
   plot(NULL, xlab="", ylab="", xaxt="n", yaxt="n", type="n", 
        xlim=c(0, 6), ylim=c(1.5, n + 1.5))
   s <- 2:(n + 1)
   rev.s <- rev(s)
   rev.pal.cols <- rev(pal.cols)
   lwd <- 6
   if (n > 5)
      lwd <- lwd -1
   if (n > 15)
      lwd <- lwd -1
   if (n > 25)
      lwd <- lwd -1
   segments(1 / s, s, 2 + 1 / rev.s, rev.s, pal.cols, lwd=lwd)
   segments(2 + 1 / s, s, 4 - 1 / s, s, rev.pal.cols, lwd=lwd)
   segments(4 - 1 / s, s, 6 - 1 / s, rev.s, rev.pal.cols, lwd=lwd)
}
