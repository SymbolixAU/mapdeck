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

    gpuAggregation: true,

    getColorWeight: d => d.properties.colour || 1,
    colorAggregation: colour_function,

    getElevationWeight: d => d.properties.elevation || 1,
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
    onClick: info => md_layer_click( map_id, "grid", info ),
    getPosition: d => md_decode_polyline( d.polyline )[0],

    gpuAggregation: true,

    getColorWeight: d => d.properties.colour || 1,
    colorAggregation: colour_function,

    getElevationWeight: d => d.properties.elevation || 1,
    elevationAggregation: elevation_function,

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

