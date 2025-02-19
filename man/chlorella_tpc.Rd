% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{chlorella_tpc}
\alias{chlorella_tpc}
\title{Example metabolic thermal performance curves}
\format{
A data frame with 649 rows and 7 variables:
\describe{
  \item{curve_id}{a unique value for each separate curve}
  \item{growth_temp}{the growth temperature that the culture was maintained at before measurements were taken (degrees centigrade)}
  \item{process}{whether the cultures had been kept for a long time at their growth temperature (adaptation/~100 generations) or a short time (a measure of acclimation/~10 generations)}
  \item{flux}{whether the curve depicts respiration or gross photosynthesis}
  \item{temp}{the assay temperature at which the metabolic rate was measured (degrees centigrade)}
  \item{rate}{the metabolic rate measured (micro mol O2 micro gram C-1 hr-1)}
}
}
\source{
Daniel Padfield
}
\usage{
data("chlorella_tpc")
}
\description{
A dataset containing example data of rates of photosynthesis and respiration of the phytoplankton Chlorella vulgaris. Instantaneous rates of metabolism were made across a range of assay temperatures to incorporate the entire thermal performance of the populations. The dataset is the cleaned version so some datapoints have been omitted.
}
\examples{
data("chlorella_tpc")
library(ggplot2)
ggplot(chlorella_tpc) +
 geom_point(aes(temp, rate, col = process)) +
 facet_wrap(~ growth_temp + flux)
}
\references{
Padfield, D., Yvon-durocher, G., Buckling, A., Jennings, S. & Yvon-durocher, G. (2015). Rapid evolution of metabolic traits explains thermal adaptation in phytoplankton, Ecology Letters, 19, 133-142.
}
\concept{data}
\keyword{dataset}
