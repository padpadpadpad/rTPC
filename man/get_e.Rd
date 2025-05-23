% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_e.R
\name{get_e}
\alias{get_e}
\title{Estimate the activation energy of a thermal performance curve}
\usage{
get_e(model)
}
\arguments{
\item{model}{nls model object that contains a model of a thermal performance curve}
}
\value{
Numeric estimate of activation energy (eV)
}
\description{
Estimate the activation energy of a thermal performance curve
}
\details{
Fits a modified-Boltzmann equation to all raw data below the optimum temperature (ºC; as estimated by \code{get_topt}).
}
\concept{params}
