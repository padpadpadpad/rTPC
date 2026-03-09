# Internal dev functions

#' Traverse up a directory on a path/vector of paths
#'
#' @param v A vector of paths to traverse.
#' @param n The number of directories to traverse each path upwards.
#'
#' @returns A vector of traversed paths.
#'
#' @examples
#' path_traverse_up(getwd(), 1)
path_traverse_up <- function(v, n = 1) {
  sapply(strsplit(v, split = "/"), \(x) {paste(head(x, length(x)-min(length(x), n)), collapse = "/")})
}

#' @title Precompute package vignettes (INTERNAL ONLY)
#'
#' @description
#' Precompute all ".Rmd" package vignettes within the prerender_vignettes folder (or another specified folder).
#'
#' @param inpath Directory of vignettes.
#' @param outpath Directory within which to put computed vignettes. If NULL, defaults to a sister folder to `inpath` named "vignettes".
#' @param cores Number of cores to use in parallel mode, set to 1 for sequential mode.
#' @param pkgpath The path of the package (if not in the current dir).
#' @param onlynodified Only re-compute modified readmes (defaults to TRUE).
#' @param fileext The file extension of the file (with the ".", defaults to .Rmd).
#' @param protect Whether to make output files read-only. This defaults to TRUE.
#'
#' @note
#' This is only useful when developing `ohvbd` (or other packages I suppose).
#'
#' This function also requires the following packages:
#'
#' - rlang
#' - cli
#' - stringr
#' - knitr
#' - doParallel
#' - foreach
#' - parallel
#' - devtools
#' - withr
#'
#' @section Setup:
#' Generally this function expects that you have a folder `inpath` at the top level of your package (such as "prerender_vignettes"). This folder should be ignored in your .Rbuildignore file.
#'
#' @section Small protections:
#' By default this function renders vignettes into `outpath` and makes them READ-ONLY.
#' This is trivial to undo, but should just add a step to make sure you really want to change the precomputed vignette rather than the source.
#'
#'
#' @author Francis Windram
#'
#' @examplesIf interactive()
#' .precompute_vignettes("vignettes")
#'
.precompute_vignettes <- function(inpath = "prerender_vignettes", outpath = NULL, cores = 1, pkgpath = ".", onlymodified = TRUE, fileext = ".Rmd", protect = TRUE) {
  rlang::check_installed(c("cli", "withr", "devtools", "knitr"))
  parmode <- rlang::is_installed(c("stringr", "knitr", "doParallel", "foreach", "parallel"))
  # if (!getOption("ohvbd_devmode", default = FALSE)) {
  #   cli::cli_alert_warning("This function is only intended to be used for development and should not be used otherwise!")
  # }
  local_knit <- function(inpath, outpath, pkg, expath) {
    # Force packages to be built in their own local env
    withr::local_environment(new.env())
    # Triple dots are generally very bad form, but this is only for dev work
    devtools:::local_install(pkg, quiet = TRUE)
    withr::with_path(expath, {
      knitr::knit(inpath, output = outpath, quiet = TRUE)
    })
  }
  
  if (is.null(outpath)) {
    outtmp <- path_traverse_up(inpath, 1)
    if (nchar(outtmp) == 0) {
      outpath <- "vignettes"
    } else {
      outpath <- file.path(outtmp, "vignettes")
    }
  }
  
  if (inpath == outpath && tolower(fileext) == ".rmd") {
    cli::cli_abort(c("x" = "{.arg inpath} and {.arg outpath} are the same place and {.arg fileext} = {.val .rmd}!",
                     "!" = "This would lead to the source files being overwritten, which is probably not what you want!"))
  }
  
  # Set up for run
  pkg <- devtools::as.package(pkgpath)
  
  vs <- list.files(inpath, pattern = paste0("*", fileext), full.names = TRUE)
  basenames <- stringr::str_replace(basename(vs), stringr::fixed(fileext), ".Rmd")
  outfiles <- file.path(outpath, basenames)
  vs <- normalizePath(vs, winslash = "/")
  outfiles <- suppressWarnings(normalizePath(outfiles, winslash = "/"))
  
  # Check for a lack of files!
  if (length(vs) < 1) {
    cli::cli_abort(c("x" = 'No "{fileext}" files detected in {.path {inpath}}!'))
  }
  
  if (onlymodified) {
    tokeep <- rlang::rep_along(vs, FALSE)
    for (i in 1:length(vs)) {
      if (file.exists(outfiles[i])) {
        if (file.mtime(vs[i]) > file.mtime(outfiles[i])) {
          # If orig is newer than Rmd
          tokeep[i] <- TRUE
        }
      } else {
        # If there is no Rmd file
        tokeep[i] <- TRUE
      }
    }
    vs <- vs[tokeep]
    outfiles <- outfiles[tokeep]
  }
  
  # Check for a lack of files again!
  if (length(vs) < 1) {
    cli::cli_alert_success('No modified "{fileext}" files detected in {.path {inpath}}!')
    return(invisible(NULL))
  }
  
  # Make all destination files open again so they can be deleted
  Sys.chmod(outfiles, mode = "777")
  
  
  cli::cli_alert("{length(vs)} vignette{?s} to render!")
  if (parmode && (cores > 1) && (length(vs) > 1)) {
    # Set up parallel cluster
    n_cores <- parallel::detectCores()
    n_jobs <- length(vs)
    max_cores <- min(cores, n_cores - 1)
    req_cores <- min(n_jobs, max_cores)
    cluster <- parallel::makeCluster(req_cores)
    doParallel::registerDoParallel(cluster)
    cli::cli_progress_step('Rendering {length(vs)} "{fileext}" {cli::qty(vs)}vignette{?s} in parallel on {req_cores} cores.')
    
    # Run job in parallel
    done <- tryCatch({
      foreach::`%dopar%`(foreach::foreach(i=1:length(vs), .combine = c), {
        local_knit(vs[i], outfiles[i], pkg, expath = outpath)
      })
    }, error = function(e) {
      cli::cli_abort(c("x" = "Failed for some reason (try with {.arg {cores = 1}})"), parent = e)
    }, finally = {
      # Always tear down cluster afterwards
      parallel::stopCluster(cl = cluster)
      cli::cli_progress_done()
      # Just in case this is turned off in the session and escapes the parallelism
      options("cli.default_handler" = NULL)
    })
  } else {
    for (i in 1:length(vs)) {
      withr::with_environment(new.env(), {
        withr::with_dir(outpath, {
          knitr::knit(vs[i], output = outfiles[i], quiet = TRUE)
          # Just in case this is turned off in the session
          options("cli.default_handler" = NULL)
        })
      })
      cli::cli_alert_success("Rendered {.path {outfiles[i]}}.")
    }
    cli::cli_progress_done()
  }
  cli::cli_alert_success("Rendered {length(vs)} vignette{?s}.")
  if (protect) {
    Sys.chmod(outfiles, mode = "444")
    cli::cli_alert_success("Made {length(vs)} vignette{?s} read-only.")
  }
  invisible(NULL)
}
