
function add_hexagon_geo( map_id, hexagon_data, layer_id, radius, elevation_scale, auto_highlight, highlight_colour, colour_range, bbox, update_view, focus_layer, js_transition, use_weight, use_colour ) {

  const hexagonLayer = new deck.HexagonLayer({
        map_id: map_id,
        id: 'hexagon-'+layer_id,
        data: hexagon_data,
        pickable: true,
        extruded: true,
        //elevationRange: [0, 100],
        colorRange: md_to_rgba( colour_range ),
        elevationScale: elevation_scale,
        radius: radius,
        getPosition: d => md_get_point_coordinates( d ),
        autoHighlight: auto_highlight,
        highlightColor: md_hexToRGBA( highlight_colour ),
        onClick: info => md_layer_click( map_id, "hexagon", info ),
        //onHover: md_update_tooltip,
        getElevationValue: d => md_hexagon_elevation( d, use_weight, false ),
        getColorValue: d => md_hexagon_colour( d, use_colour, false ),
        transitions: js_transition || {}
  });
	md_update_layer( map_id, 'hexagon-'+layer_id, hexagonLayer );
	md_layer_view( map_id, layer_id, focus_layer, bbox, update_view );
}

function add_hexagon_polyline( map_id, hexagon_data, layer_id, radius, elevation_scale, auto_highlight, highlight_colour, colour_range, bbox, update_view, focus_layer, js_transition, use_weight, use_colour) {


  const hexagonLayer = new deck.HexagonLayer({
  	map_id: map_id,
        id: 'hexagon-'+layer_id,
        data: hexagon_data,
        pickable: true,
        extruded: true,
        //elevationRange: [0, 100],
        colorRange: md_to_rgba( colour_range ),
        elevationScale: elevation_scale,
        radius: radius,
        getPosition: d => md_decode_points( d.polyline ),
        autoHighlight: auto_highlight,
        highlightColor: md_hexToRGBA( highlight_colour ),
        onClick: info => md_layer_click( map_id, "hexagon", info ),
        //onHover: md_update_tooltip,
        getElevationValue: d => md_hexagon_elevation( d, use_weight, true ),
        getColorValue: d => md_hexagon_colour( d, use_colour, true ),
        transitions: js_transition || {}
  });

  md_update_layer( map_id, 'hexagon-'+layer_id, hexagonLayer );
  md_layer_view( map_id, layer_id, focus_layer, bbox, update_view );
}

function md_hexagon_elevation(d, use_weight, use_polyline) {

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
	return total;
}

function md_hexagon_colour(d, use_colour, use_polyline) {

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
	return total;
}
