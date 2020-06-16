#' Example metabolic thermal performance curves
#'
#' A dataset containing example data of rates of photosynthesis and respiration of the phytoplankton Chlorella vulgaris. Instantaneous rates of metabolism were made across a range of assay temperatures to incorporate the entire thermal performance of the populations. The dataset is the cleaned version so some datapoints have been omitted.
#'
#' @format A data frame with 649 rows and 7 variables:
#' \describe{
#'   \item{curve_id}{a unique value for each separate curve}
#'   \item{growth_temp}{the growth temperature that the culture was maintained at before measurements were taken (degrees centigrade)}
#'   \item{process}{whether the cultures had been kept for a long time at their growth temperature (adaptation/~100 generations) or a short time (a measure of acclimation/~10 generations)}
#'   \item{flux}{whether the curve depicts respiration or gross photosynthesis}
#'   \item{temp}{the assay temperature at which the metabolic rate was measured (degrees centigrade)}
#'   \item{rate}{the metabolic rate measured (micro mol O2 micro gram C-1 hr-1)}
#' }
#' @source Daniel Padfield
#' @references Padfield, D., Yvon-durocher, G., Buckling, A., Jennings, S. & Yvon-durocher, G. (2015). Rapid evolution of metabolic traits explains thermal adaptation in phytoplankton, Ecology Letters, 19, 133-142.
#' @keywords dataset
#' @docType data
#' @usage data("chlorella_tpc")
#' @examples
#' data("chlorella_tpc")
#' library(ggplot2)
#' ggplot(chlorella_tpc) +
#'  geom_point(aes(temp, rate, col = process)) +
#'  facet_wrap(~ growth_temp + flux)
"chlorella_tpc"

#' Example thermal performance curves of bacterial growth
#'
#' A dataset containing example data of growth rates of the bacteria Pseudomonas fluorescens in the presence and absence of its phage, phi2. Growth rates were measured across a range of assay temperatures to incorporate the entire thermal performance of the bacteria The dataset is the cleaned version so some data points have been omitted. There are multiple independent measurements per temperature for each treatment.
#'
#' @format A data frame with 649 rows and 7 variables:
#' \describe{
#'   \item{phage}{whether the bacteria was grown with or without phage}
#'   \item{temp}{the assay temperature at which the growth rate was measured (degrees centigrade)}
#'   \item{rate}{estimated growth rate per hour}
#' }
#' @source Daniel Padfield
#' @references Padfield, D., Castledine, M., & Buckling, A. (2020). Temperature-dependent changes to host–parasite interactions alter the thermal performance of a bacterial host. The ISME Journal, 14(2), 389-398.
#' @keywords dataset
#' @docType data
#' @usage data("bacteria_tpc")
#' @examples
#' data("bacteria_tpc")
#' library(ggplot2)
#' ggplot(bacteria_tpc) +
#'  geom_point(aes(temp, rate, col = phage))
"bacteria_tpc"
