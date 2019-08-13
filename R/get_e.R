#' Estimate the activation energy
#'
#' @description Estimates the activation energy of a given thermal performance curve
#' @param model nls model object that contains a model of a thermal performance curve
#' @author Daniel Padfield
#' @export get_e

get_e <- function(model){

  # capture environment from model - contains data
  x <- model$m$getEnv()

  # get the name of the temperature column
  formula <- stats::as.formula(model$m$formula())
  param_ind <- all.vars(formula[[3]])[! all.vars(formula[[3]]) %in%
                                        names(model$m$getPars())]

  # extract the temperature values
  vals <- x[[param_ind]]

  # new datasets - one for extrapolation and one without
  newdata <- data.frame(x = seq(min(vals), max(vals), by = 0.001), stringsAsFactors = FALSE)

  # rename to be the correct column name
  names(newdata) <- param_ind
  names(newdata_extrap) <- param_ind

  # predict over a whole wide range of data - both extrap and non-extrap
  newdata$preds <- stats::predict(model, newdata = newdata)

  # calc topt and rmax
  topt = newdata[newdata$preds == max(newdata$preds, na.rm = TRUE), param_ind]
  rmax = newdata[newdata$preds == max(newdata$preds),'preds']

  # keep just temperatures lower than topt
  newdata <- newdata[newdata[,param_ind] <= topt,]
  newdata$preds[newdata$preds <= 0] <- NA

  # log data
  newdata$ln_preds <- log(newdata$preds)
  # create K column if needed
  newdata$K <- ifelse(newdata[,param_ind] < 150, newdata[,param_ind] + 273.15, newdata[,param_ind])
  newdata$Ktrans <- 1/8.62e-05/newdata$K

  mod <- stats::nls(preds ~ lnc*exp(e/8.62e-05*(1/median(K) - 1/K)), newdata, start = c(lnc = -1, e = 1), na.action = stats::na.omit)
  e = unname(stats::coef(mod)[2])

  return(e)
}

