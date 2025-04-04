% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_thermalsafetymargin.R
\name{get_thermalsafetymargin}
\alias{get_thermalsafetymargin}
\title{Estimate thermal safety margin of a thermal performance curve}
\usage{
get_thermalsafetymargin(model)
}
\arguments{
\item{model}{nls model object that contains a model of a thermal performance curve}
}
\value{
Numeric estimate of thermal safety margin (in ºC)
}
\description{
Estimate thermal safety margin of a thermal performance curve
}
\details{
Thermal safety margin is calculated as: CTmax - Topt. This is calculated using the functions \code{get_ctmax} and \code{get_topt}.
}
\concept{params}
