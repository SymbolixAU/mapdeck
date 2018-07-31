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

## Available Plots

Most of these plots are avialble in a limited capacity. I haven't implemented all attributes (fill, strokes, widths, elevations)

- Arc
- GeoJSON
- Grid
- Line
- Path (partial - uses encoded polylines)
- Polygon (partial - uses encoded polylines)
- Scatter
- ScreenGrid

## TODO

- Hexagon
- Icon
- PointCloud
- Text

## Shiny

Basic plots work in shiny, but I'm still working on the interactive updates
