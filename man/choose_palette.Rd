\name{choose_palette}
\alias{choose_palette}
\alias{hclwizard}

\title{Graphical User Interface for Choosing HCL Color Palettes}

\description{
A graphical user interface (GUI) for viewing, manipulating,
and choosing HCL color palettes.
}

\usage{
choose_palette(pal = diverge_hcl, n = 7L, parent = NULL, gui = "tcltk")
hclwizard(n = 7L, gui = "shiny", shiny.trace = FALSE)
}

\arguments{
  \item{pal}{function; the initial palette, see \sQuote{Value} below.
         Only used if \code{gui="tcltk"}.}
  \item{n}{integer; the initial number of colors in the palette.}
  \item{parent}{tkwin; the GUI parent window.
         Only used if \code{gui="tcltk"}.}
  \item{gui}{character; GUI to use. Available options are
      \code{tcltk} and \code{shiny}, see \sQuote{Details} below.}
  \item{shiny.trace}{boolean, default \code{FALSE}. Used
      for debugging if \code{gui="shiny"}.}
}

\details{
Computes palettes based on the HCL (hue-chroma-luminance) color
model (as implemented by \code{\link{polarLUV}}). The GUIs interface
the palette functions
\code{\link{rainbow_hcl}} for qualitative palettes,
\code{\link{sequential_hcl}} for sequential palettes with a single hue,
\code{\link{heat_hcl}} for sequential palettes with multiple hues, and
\code{\link{diverge_hcl}} for diverging palettes (composed from two single-hue
sequential palettes).

Two different GUIs are implemented and can be selected using the
function input argument \code{gui} (\code{"tcltk"} or \code{"shiny"}).
Both GUIs allows for interactive modification of the arguments of the respective
palette-generating functions, i.e.,
starting/ending hue (wavelength, type of color),
minimal/maximal chroma (colorfulness),
minimal maximal luminance (brightness, amount of gray), and
a power transformations that control how quickly/slowly chroma and/or
luminance are changed through the palette. Subsets of the parameters
may not be applicable depending on the type of palette chosen. See
\code{\link{rainbow_hcl}} and Zeileis et al. (2009) for a more detailed
explanation of the different arguments. Stauffer et al. (2015) provide
more examples and guidance.

Optionally, active palette can be illustrated by using a range of examples
such as a map, heatmap, scatter plot, perspective 3D surface etc.

To demonstrate different types of deficiencies, the active palette may
be desaturated (emulating printing on a grayscale printer) and, if the
\code{\link[dichromat]{dichromat}} package is available, collapsed to
emulate different types of color-blindness (without red-green or green-blue
contrasts).
}

\value{
Returns a palette-generating function with the selected arguments.
Thus, the returned function takes an integer argument and returns the corresponding
number of HCL colors by traversing HCL space through interpolation
of the specified hue/chroma/luminance/power values.
}

\author{Jason C. Fisher, Reto Stauffer, Achim Zeileis}

\references{
  Zeileis A, Hornik K, Murrell P (2009).
  Escaping RGBland: Selecting Colors for Statistical Graphics.
  \emph{Computational Statistics & Data Analysis}, \bold{53}, 3259--3270.
  \doi{10.1016/j.csda.2008.11.033}
  Preprint available from \url{https://eeecon.uibk.ac.at/~zeileis/papers/Zeileis+Hornik+Murrell-2009.pdf}.

  Stauffer R, Mayr GJ, Dabernig M, Zeileis A (2015).
  Somewhere over the Rainbow: How to Make Effective Use of Colors in Meteorological Visualizations.
  \emph{Bulletin of the American Meteorological Society}, \bold{96}(2), 203--216.
  \doi{10.1175/BAMS-D-13-00155.1}
}

\seealso{
\code{\link{rainbow_hcl}}
}

\examples{
if(interactive()) {
## Using tcltk GUI
## Analog to: hclwizard(gui="tcltk")
pal <- choose_palette()
## Using shiny GUI
## Analog to: choose_palette(gui = "shiny")
pal <- hclwizard()

## use resulting palette function
filled.contour(volcano, color.palette = pal, asp = 1)
}
}

\keyword{misc}
