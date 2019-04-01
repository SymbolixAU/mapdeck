
function add_column_geo( map_id, column_data, layer_id, radius, elevation_scale, auto_highlight, highlight_colour, colour_range, bbox, update_view, focus_layer, js_transition, use_weight, use_colour, elevation_function, colour_function ) {

  const columnLayer = new deck.ColumnLayer({
        map_id: map_id,
        id: 'column-'+layer_id,
        data: column_data,
        pickable: true,
        extruded: true,
        colorRange: md_to_rgba( colour_range ),
        elevationScale: elevation_scale,
        radius: radius,
        getPosition: d => md_get_point_coordinates( d ),
        autoHighlight: auto_highlight,
        highlightColor: md_hexToRGBA( highlight_colour ),
        onClick: info => md_layer_click( map_id, "column", info ),
        getElevation: d => md_column_elevation( d, use_weight, false, elevation_function ),
        getColor: d => md_column_colour( d, use_colour, false, colour_function ),
        transitions: js_transition || {}
  });
	md_update_layer( map_id, 'column-'+layer_id, columnLayer );
	md_layer_view( map_id, layer_id, focus_layer, bbox, update_view );
}

function add_column_polyline( map_id, column_data, layer_id, radius, elevation_scale, auto_highlight, highlight_colour, colour_range, bbox, update_view, focus_layer, js_transition, use_weight, use_colour) {


  const columnLayer = new deck.ColumnLayer({
  	map_id: map_id,
        id: 'column-'+layer_id,
        data: column_data,
        pickable: true,
        extruded: true,
        colorRange: md_to_rgba( colour_range ),
        elevationScale: elevation_scale,
        radius: radius,
        getPosition: d => md_decode_points( d.polyline ),
        autoHighlight: auto_highlight,
        highlightColor: md_hexToRGBA( highlight_colour ),
        onClick: info => md_layer_click( map_id, "column", info ),
        getElevation: d => md_column_elevation( d, use_weight, true ),
        getColor: d => md_column_colour( d, use_colour, true ),
        transitions: js_transition || {}
  });

  md_update_layer( map_id, 'column-'+layer_id, columnLayer );
  md_layer_view( map_id, layer_id, focus_layer, bbox, update_view );
}

function md_column_elevation(d, use_weight, use_polyline, elevation_function ) {

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

function md_column_colour(d, use_colour, use_polyline, colour_function ) {

	//console.log( d );
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
