# mapdeck 0.3


* More lays get `brush_radius` - [issue164](https://github.com/SymbolixAU/mapdeck/issues/164)
* `show_view_state` option to overlay the current View State [issue238](https://github.com/SymbolixAU/mapdeck/issues/238)
* performance improvements for dates and factors [issue235](https://github.com/SymbolixAU/mapdeck/issues/235)
* `add_bitmap()` to add a bitmap / image to the map
* input$map_view_change now observed [issue211](https://github.com/SymbolixAU/mapdeck/issues/211) - thanks @zacdav
* `update_stype()` function
* `add_path()` accepts dashed lines
* mapbox tokens are searched for in environement variables if one isn't provided [issue209](https://github.com/SymbolixAU/mapdeck/issues/209)
* z-fighting [issue 199](https://github.com/SymbolixAU/mapdeck/issues/199)
* factors correctly used in legends [issue #138](https://github.com/SymbolixAU/mapdeck/issues/138)
* `add_trips()` for adding animated trips to the map
* `add_path` gets `billboard` argument so the path always faces the 'camera'
* Fix for legends in GeoJSON layer - [issue #190](https://github.com/SymbolixAU/mapdeck/issues/190)
* `add_hexagon` now supports GPU aggregation for colour and elevation
* `radius_min_pixels` and `radius_max_pixels` arguemnts for scatterplots
* `add_mesh()` for quadmesh objects
* Google Map supported
* `mapdeck_legend` and `legend_element` for manually creating legends
* `add_column()` to draw columns (as any polygon shape)
* `add_text()` gets `billbaord`, `font_family`, `font_weight`
* `add_greatcircles()` to draw flat great circles
* `add_line` width docs updated to say 'metres'
* `add_arc` gets `tilt` and `height` arguments
* `add_arc` gets `brush_radius` argument for brushing
* opacity values can be in [0,1) OR [0,255]
* layeres work without an access token
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
