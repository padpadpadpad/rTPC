# Lists or searches the models available in rTPC

Lists or searches the models available in rTPC

## Usage

``` r
get_model_names(model, returnall = FALSE)
```

## Arguments

- model:

  Optional string (or vector of strings) representing model/s to search
  for.

- returnall:

  Also return the names of deprecated functions

## Value

character vector of thermal performance curves available in rTPC

## Author

Daniel Padfield

Francis Windram

## Examples

``` r
get_model_names()
#>  [1] "analytiskontodimas_2004"       "ashrafi1_2018"                
#>  [3] "ashrafi2_2018"                 "ashrafi3_2018"                
#>  [5] "ashrafi4_2018"                 "ashrafi5_2018"                
#>  [7] "atkin_2005"                    "beta_2012"                    
#>  [9] "betatypesimplified_2008"       "boatman_2017"                 
#> [11] "briere1_1999"                  "briere1simplified_1999"       
#> [13] "briere2_1999"                  "briere2simplified_1999"       
#> [15] "briereextended_2021"           "briereextendedsimplified_2021"
#> [17] "delong_2017"                   "deutsch_2008"                 
#> [19] "eubank_1973"                   "flextpc_2024"                 
#> [21] "flinn_1991"                    "gaussian_1987"                
#> [23] "gaussianmodified_2006"         "hinshelwood_1947"             
#> [25] "janisch1_1925"                 "janisch2_1925"                
#> [27] "joehnk_2008"                   "johnsonlewin_1946"            
#> [29] "kamykowski_1985"               "lactin2_1995"                 
#> [31] "lobry_1991"                    "mitchell_2009"                
#> [33] "oneill_1972"                   "pawar_2018"                   
#> [35] "quadratic_2008"                "ratkowsky_1983"               
#> [37] "rezende_2019"                  "rosso_1993"                   
#> [39] "sharpeschoolfull_1981"         "sharpeschoolhigh_1981"        
#> [41] "sharpeschoollow_1981"          "spain_1982"                   
#> [43] "stinner_1974"                  "taylorsexton_1972"            
#> [45] "thomas_2012"                   "thomas_2017"                  
#> [47] "tomlinsonphillips_2015"        "warrendreyer_2006"            
#> [49] "weibull_1995"                 
get_model_names("briere")
#> [1] "briere1_1999"                  "briere1simplified_1999"       
#> [3] "briere2_1999"                  "briere2simplified_1999"       
#> [5] "briereextended_2021"           "briereextendedsimplified_2021"
```
