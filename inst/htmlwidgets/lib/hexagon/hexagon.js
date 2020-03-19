
function add_hexagon_geo( map_id, map_type, hexagon_data, layer_id, radius, elevation_scale, auto_highlight, highlight_colour, colour_range, bbox, update_view, focus_layer, js_transition, use_weight, use_colour, elevation_function, colour_function, legend, brush_radius ) {

  var extensions = [];

  if ( brush_radius > 0 ) {
  	extensions.push( new deck.BrushingExtension() );
  }

  const hexagonLayer = new deck.HexagonLayer({
    map_id: map_id,
    id: 'hexagon-'+layer_id,
    data: hexagon_data,
    pickable: true,
    extruded: true,
    radius: radius,
    //elevationRange: [0, 100],
    //onHover: md_update_tooltip,
    getPosition: d => md_get_point_coordinates( d ),
    colorRange: md_to_rgba( colour_range ),
    elevationScale: elevation_scale,

    getColorWeight: d => d.properties.colour || 1,
    colorAggregation: colour_function,

    getElevationWeight: d => d.properties.elevation || 1,
    elevationAggregation: elevation_function,

    highlightColor: md_hexToRGBA( highlight_colour ),
    onClick: info => md_layer_click( map_id, "hexagon", info ),
    autoHighlight: auto_highlight,
    transitions: js_transition || {},
    brushingRadius: brush_radius,
    extensions: extensions,
    onSetColorDomain: d => md_colour_domain( d, colour_range, map_id, map_type, layer_id, legend, "hex" )
  });


  if( map_type == "google_map") {
	    md_update_overlay( map_id, 'hexagon-'+layer_id, hexagonLayer );
	} else {
		md_update_layer( map_id, 'hexagon-'+layer_id, hexagonLayer );
	}
  md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}




function add_hexagon_polyline( map_id, map_type, hexagon_data, layer_id, radius, elevation_scale, auto_highlight, highlight_colour, colour_range, bbox, update_view, focus_layer, js_transition, use_weight, use_colour, elevation_function, colour_function, legend, brush_radius) {

  var extensions = [];

  if ( brush_radius > 0 ) {
  	extensions.push( new deck.BrushingExtension() );
  }

  const hexagonLayer = new deck.HexagonLayer({
  	map_id: map_id,
    id: 'hexagon-'+layer_id,
    data: hexagon_data,
    pickable: true,
    extruded: true,
    radius: radius,
    //elevationRange: [0, 100],
    getPosition: d => md_decode_points( d.polyline ),
    colorRange: md_to_rgba( colour_range ),
    elevationScale: elevation_scale,

    getColorWeight: d => d.colour || 1,
    colorAggregation: colour_function,

    getElevationWeight: d => d.elevation || 1,
    elevationAggregation: elevation_function,

    highlightColor: md_hexToRGBA( highlight_colour ),
    onClick: info => md_layer_click( map_id, "hexagon", info ),
    autoHighlight: auto_highlight,
    transitions: js_transition || {},
    brushingRadius: brush_radius,
    extensions: extensions,
    onSetColorDomain: d => md_colour_domain( d, colour_range, map_id, map_type, layer_id, legend, "hex" )
  });

  if( map_type == "google_map") {
	    md_update_overlay( map_id, 'hexagon-'+layer_id, hexagonLayer );
	} else {
	  md_update_layer( map_id, 'hexagon-'+layer_id, hexagonLayer );
	}
	md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}
