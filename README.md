# mapdeck

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/mapdeck)](http://cran.r-project.org/package=mapdeck)
![downloads](http://cranlogs.r-pkg.org/badges/grand-total/mapdeck)
[![CRAN RStudio mirror downloads](http://cranlogs.r-pkg.org/badges/mapdeck)](http://cran.r-project.org/web/packages/mapdeck/index.html)
[![Github Stars](https://img.shields.io/github/stars/SymbolixAU/mapdeck.svg?style=social&label=Github)](https://github.com/SymbolixAU/mapdeck)
[![Build Status](https://travis-ci.org/SymbolixAU/mapdeck.svg?branch=master)](https://travis-ci.org/SymbolixAU/mapdeck)
[![Coverage Status](https://codecov.io/github/SymbolixAU/mapdeck/coverage.svg?branch=master)](https://codecov.io/github/SymbolixAU/mapdeck?branch=master)

Interactive maps using Mapbox GL and Deck.gl

## Installation

```r
devtools::install_github("SymbolixAU/mapdeck")
```

![Arcs](./vignettes/img/arcs.png)

## Access Token

Mapdeck uses [Mabox maps](https://www.mapbox.com/), and to use Mapbocx you need an [access token](https://www.mapbox.com/help/how-access-tokens-work/)

## Available Plots

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
