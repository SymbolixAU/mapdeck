# v0.3.4

* fixed `update_style` bug [issue 322](https://github.com/SymbolixAU/mapdeck/issues/322)
* various updates to documentation
* initial support for cesium js via add_cesium and add_i3s layers
* add Linking to geometries ready for migration
* fixed bug when plotting a single point

# v0.3.3

* fixed bug in polygon layer when using `sfheaders::sf_cast()`
* fixed bug in manual legend for point layers [issue 301](https://github.com/SymbolixAU/mapdeck/issues/301)
* path width options [issue 300](https://github.com/SymbolixAU/mapdeck/issues/300)
* min and max pitch and zoom options [issue 295](https://github.com/SymbolixAU/mapdeck/issues/295)

# v0.3.2

* `add_animated_arc()` layer
* better handling of polygon colours [issue287](https://github.com/SymbolixAU/mapdeck/issues/287)
* bug fixed when clearing a layer [issue286](https://github.com/SymbolixAU/mapdeck/issues/286)
* layers can repeat at low zoom levels [issue282](https://github.com/SymbolixAU/mapdeck/issues/282)
* mapbox dependencies updated to 1.9.0
* tooltip for binary layers fixed [issue280](https://github.com/SymbolixAU/mapdeck/issues/280)

# v0.3.1

* you can now use most `sfc` geometry types in any plotting layer
* performance boost for `add_scatterplot()`, `add_column()` and `add_pointcloud()`
* Arc layer supports 3D positions
* More layers get `brush_radius` - [issue164](https://github.com/SymbolixAU/mapdeck/issues/164)
* `show_view_state` option to overlay the current View State [issue238](https://github.com/SymbolixAU/mapdeck/issues/238)
* performance improvements for dates and factors [issue235](https://github.com/SymbolixAU/mapdeck/issues/235)
* `add_bitmap()` to add a bitmap / image to the map
* input$map_view_change now observed [issue211](https://github.com/SymbolixAU/mapdeck/issues/211) - thanks @zacdav
* `update_style()` function
* `add_path()` accepts dashed lines
* mapbox tokens are searched for in environement variables if one isn't provided [issue209](https://github.com/SymbolixAU/mapdeck/issues/209)
* z-fighting [issue 199](https://github.com/SymbolixAU/mapdeck/issues/199)
* factors correctly used in legends [issue #138](https://github.com/SymbolixAU/mapdeck/issues/138)
* `add_trips()` for adding animated trips to the map
* `add_path` gets `billboard` argument so the path always faces the 'camera'
* Fix for legends in GeoJSON layer - [issue #190](https://github.com/SymbolixAU/mapdeck/issues/190)
* `add_hexagon` now supports GPU aggregation for colour and elevation
* `radius_min_pixels` and `radius_max_pixels` arguemnts for scatterplots
* `add_mesh()` for mesh3d objects
* Google Map supported
* `mapdeck_legend` and `legend_element` for manually creating legends
* `add_column()` to draw columns (as any polygon shape)
* `add_text()` gets `billbaord`, `font_family`, `font_weight`
* `add_greatcircles()` to draw flat great circles
* `add_line` width docs updated to say 'metres'
* `add_arc` gets `tilt` and `height` arguments
* `add_arc` gets `brush_radius` argument for brushing
* opacity values can be in [0,1) OR [0,255]
* layers work without an access token
* `add_title()` for adding titles to map
* `add_scatterplot` gets `stroke_colour` and `stroke_width` arguments
* `add_hexagon` gets transitions
* `add_hexagon` gets `weight` and `colour_value` arguments for defining height and colour
* `stroke_width` units defined in help files

# v0.2

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
