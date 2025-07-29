# rTPC 2.0.0 - 29/07/2025

* Prepared for CRAN submission.

# rTPC 1.0.7 08/01/2024

* Added many more models
* Reshaped how models are added and how start values and limits are included.

# rTPC 1.0.6 19/08/2024

* Added ashrafi1_2018() to the package
* Added a ... argument to calc_params() to allow users to change the level of the calculation of get_breadth()
* Re-rendered the website in its entirety.

# rTPC 1.0.5 - 08/09/2023

* Updated thomas_2012() to have better lower and upper limits for tref. Relabelled topt to be tref as it rarely reflect the optimum temperature
* Re-rendered website in its entirety

# rTPC 1.0.4 - 16/08/2023

* Updated documentation to include return value information
* Accepted onto CRAN

# rTPC 1.0.3 - 10/08/2023

* Added a modified version of the Deutsch model to the package
* Updated all other functions to include the deutsch_2008() model
* Re-rendered website

# rTPC 1.0.2 - 03/12/2021

* Added the Lobry–Rosso–Flandrois model to the package
* Updated all other functions to include the lrf_1991() model

# rTPC 1.0.1

* Added a `NEWS.md` file to track changes to the package.
* Added a new vignette `vignette("bootstrapping_many_curves")` to demonstrate how to run the bootstrap procedure on multiple curves at once
* Updated README to reflect this
