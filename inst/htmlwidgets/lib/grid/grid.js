function add_grid_geo( map_id, map_type, grid_data, layer_id, cell_size, extruded, elevation_scale, colour_range, auto_highlight, highlight_colour, bbox, update_view, focus_layer, js_transition, use_weight, use_colour, elevation_function, colour_function, legend  ) {

  const gridLayer = new deck.GridLayer({
  	map_id: map_id,
    id: 'grid-'+layer_id,
    data: grid_data,
    pickable: true,
    extruded: extruded,
    cellSize: cell_size,
    colorRange: md_to_rgba( colour_range ),
    elevationScale: elevation_scale,
    getPosition: d => md_get_point_coordinates( d ),

    //getElevationValue: d => md_grid_elevation( d, use_weight, false, elevation_function ),
    //getColorValue: d => md_grid_colour( d, use_colour, false, colour_function ),

    getColorWeight: d => d.properties.colour,
    colorAggregation: colour_function,

    getElevationWeight: d => d.properties.elevation,
    elevationAggregation: elevation_function,

    onClick: info => md_layer_click( map_id, "grid", info ),
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    transitions: js_transition || {},
    onSetColorDomain: d => md_colour_domain( d, colour_range, map_id, map_type, layer_id, legend )
  });

  if( map_type == "google_map") {
	    md_update_overlay( map_id, 'grid-'+layer_id, gridLayer );
	} else {
	  md_update_layer( map_id, 'grid-'+layer_id, gridLayer );
	}
	md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}

function add_grid_polyline( map_id, map_type, grid_data, layer_id, cell_size, extruded, elevation_scale, colour_range, auto_highlight, highlight_colour, bbox, update_view, focus_layer, js_transition, use_weight, use_colour, elevation_function, colour_function, legend  ) {

  const gridLayer = new deck.GridLayer({
    map_id: map_id,
    id: 'grid-'+layer_id,
    data: grid_data,
    pickable: true,
    extruded: extruded,
    cellSize: cell_size,
    colorRange: md_to_rgba( colour_range ),
    elevationScale: elevation_scale,
    getPosition: d => md_decode_polyline( d.polyline )[0],
    onClick: info => md_layer_click( map_id, "grid", info ),
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    getElevationValue: d => md_grid_elevation( d, use_weight, true, elevation_function ),
    getColorValue: d => md_grid_colour( d, use_colour, true, colour_function ),
    transitions: js_transition || {},
    onSetColorDomain: d => md_colour_domain( d, colour_range, map_id, map_type, layer_id, legend )
  });

  if( map_type == "google_map") {
	    md_update_overlay( map_id, 'grid-'+layer_id, gridLayer );
	} else {
	  md_update_layer( map_id, 'grid-'+layer_id, gridLayer );
	}
	md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}


function md_grid_elevation(d, use_weight, use_polyline, colour_function) {

	if( !use_weight ) {
		return d.length;
	}

	var i, total = 0;

	if( use_polyline ) {
		for( i = 0; i < d.length; i++ ) {
		  total = total + d[i].elevation;
	  }
	} else {
		for( i = 0; i < d.length; i++ ) {
		  total = total + d[i].properties.elevation;
	  }
	}
	if ( elevation_function === "average" ) {
		total = total / d.length;
	}
	return total;
}

function md_grid_colour(d, use_colour, use_polyline, colour_function ) {

	if( !use_colour ) {
		return d.length;
	}

	var i, total = 0;

	if( use_polyline ) {
		for( i = 0; i < d.length; i++ ) {
		  total = total + d[i].colour;
	  }
	} else {
		for( i = 0; i < d.length; i++ ) {
	  	total = total + d[i].properties.colour;
	  }
	}
	if ( colour_function === "average" ) {
		total = total / d.length;
	}
	return total;
}
