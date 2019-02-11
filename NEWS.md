# mapdeck 0.3

* `add_title()` for adding titles to map
* `add_scatterplot` gets `stroke_colour` and `stroke_width` arguments
* `add_hexagon` gets transitions
* `add_hexagon` gets `weight` and `colour_value` arguments for defining height and colour
* `stroke_width` units defined in help files

# mapdeck 0.2

* different palettes for both stroke & fill options
* `stroke_colour` fix for polygons
* `transitions` argument for most layers
* `mapdeck()` argument order changed so `data` is first ( to work better with pipes ) 
* `update_view` and `focus_layer` added to focus layers on data
* bearing and pitch maintained on data layer updates
* `bearing` argument to `mapdeck()`
* `add_geojson()` fully supported
* `add_sf()` convenience function
* Z attributes supported
* `MULTI`-geometry sf objects supported 
* can use variables in place of string arguments
* `highlight_colour` argument
* all `add_*()` functions migrated to c++
* `layer_id` is optional to the user
* `auto_highlight` argument
