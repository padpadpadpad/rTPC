## Resubmission

This is a major resubmission of rTPC v1.1.0 to CRAN. In this version we have:

- fixed additional notes
- added several new models
- reshaped how start values and limits are called
- updated the README and vignettes to reflect the changes
- updated NEWS.md
- updated the versioning
- updated all links and urls to reflect best practice (DOIs instead of links, fixing identified issues)
- added vignette about parallelisation
- added internal function for pre-rendering vignettes that take a long time
- updated R dependency to >= 4.1 due to use of new-style pipes

## Test environments

- local OS X on MacBook Pro M2 (Sequoia 15.4.1) install, R 4.5.1
- win-builder (using devtools::check_win_devel() and devtools::check_win_release())
- GitHub Actions using R-CMD-check ("check-standard")

## R CMD check results

- There were no NOTEs ERRORs or WARNINGs
