# mapdeck

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/mapdeck)](http://cran.r-project.org/package=mapdeck)
![downloads](http://cranlogs.r-pkg.org/badges/grand-total/mapdeck)
[![CRAN RStudio mirror downloads](http://cranlogs.r-pkg.org/badges/mapdeck)](http://cran.r-project.org/web/packages/mapdeck/index.html)
[![Github Stars](https://img.shields.io/github/stars/SymbolixAU/mapdeck.svg?style=social&label=Github)](https://github.com/SymbolixAU/mapdeck)
[![Build Status](https://travis-ci.org/SymbolixAU/mapdeck.svg?branch=master)](https://travis-ci.org/SymbolixAU/mapdeck)
[![Coverage Status](https://codecov.io/github/SymbolixAU/mapdeck/coverage.svg?branch=master)](https://codecov.io/github/SymbolixAU/mapdeck?branch=master)

Interactive maps using Mapbox GL and Deck.gl

## Installation

#### From cran

```r
install.packages("mapdeck")
```

#### Development version

Version v0.1.002+ sees quite a lot of changes, so I need users to test their functions and report any errors. 

If you install the latest dev version and your plots aren't working, you can still use the old function, just add `_old` to the function call. 


The fisrt change is `add_scatterplot()`


```r
## Until googlePolylines 0.7.2+ is on CRAN you'll need 
devtools::install_github("SymbolixAU/googlePolylines")

## and colourvalues requries v0.2.0
devtools::install_github("SymbolixAU/colourvalues")

## then mapdeck
devtools::install_github("SymbolixAU/mapdeck")
```

## Basic Use

`mapdeck(token = 'your_token')` will give you a map. You then start adding layers by using one of the various `add_*()` functions. 

```r
url <- 'https://raw.githubusercontent.com/plotly/datasets/master/2011_february_aa_flight_paths.csv'
flights <- read.csv(url)
flights$info <- paste0("<b>",flights$airport1, " - ", flights$airport2, "</b>")

mapdeck(token = key, style = mapdeck_style('dark')) %>%
  add_arc(
    data = flights
    , origin = c("start_lon", "start_lat")
    , destination = c("end_lon", "end_lat")
    , stroke_from = "airport1"
    , stroke_to = "airport2"
    , tooltip = "info"
    , layer_id = 'arclayer'
  )
```

![Arcs](./vignettes/img/readme_arcs_small.gif)

## Access Token

Mapdeck uses [Mapbox maps](https://www.mapbox.com/), and to use Mapbox you need an [access token](https://www.mapbox.com/help/how-access-tokens-work/)

## Available Layers

- Arc
- GeoJSON
- Grid
- Line
- Path 
- Point cloud
- Polygon
- Scatter plot
- Screen grid
- Text


## Shiny

Mapdeck is also an `htmlwidget`, so will work in a shiny application. 

Examples of all plots and shiny can be found in the [vignette](https://github.com/SymbolixAU/mapdeck/blob/master/vignettes/mapdeck.Rmd)
