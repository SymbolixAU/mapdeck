

function add_path_geo( map_id, map_type, path_data, layer_id, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition, billboard, brush_radius, width_units, width_scale, width_min_pixels, width_max_pixels, use_offset, use_dash ) {

	console.log( path_data );

  var extensions = [];

  if ( brush_radius > 0 ) {
  	extensions.push( new deck.BrushingExtension() );
  }

  extensions.push(
  	new deck.PathStyleExtension({dash: use_dash, offset: use_offset})
  );

  const pathLayer = new deck.PathLayer({
    map_id: map_id,
    id: 'path-'+layer_id,
    data: path_data,
    pickable: true,
    widthScale: width_scale,
    widthUnits: width_units,
    widthMinPixels: width_min_pixels || 1,
    widthMaxPixels: width_max_pixels || Number.MAX_SAFE_INTEGER,
    rounded: true,
    billboard: billboard,
    parameters: {
	    depthTest: false
	  },
    getPath: d => md_get_line_coordinates( d ),
    getColor: d => md_hexToRGBA( d.properties.stroke_colour ),
    getWidth: d => d.properties.stroke_width,
    getDashArray: d => [ d.properties.dash_size, d.properties.dash_gap ],
    getOffset: d => d.properties.offset,
    onClick: info => md_layer_click( map_id, "path", info ),
    onHover: md_update_tooltip,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    transitions: js_transition || {},
    brushingRadius: brush_radius,
    extensions: extensions
  });

  if( map_type == "google_map") {
	  md_update_overlay( map_id, 'path-'+layer_id, pathLayer );
	} else {
	  md_update_layer( map_id, 'path-'+layer_id, pathLayer );
	}

	if ( legend !== false ) {
	  md_add_legend( map_id, map_type, layer_id, legend, "hex" );
	}
	md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}

function add_path_polyline( map_id, map_type, path_data, layer_id, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition, billboard, brush_radius ) {

  var extensions = [];

  if ( brush_radius > 0 ) {
  	extensions.push( new deck.BrushingExtension() );
  }

  var extensions = [];
  extensions.push(
  	new deck.PathStyleExtension({dash: true})
  );

  const pathLayer = new deck.PathLayer({
    map_id: map_id,
    id: 'path-'+layer_id,
    data: path_data,
    pickable: true,
    widthScale: 1,
    widthMinPixels: 1,
    rounded: true,
    parameters: {
	    depthTest: false
	  },
    billboard: billboard,
    getPath: d => md_decode_polyline( d.polyline ),  // needs to be one row per polyline
    getColor: d => md_hexToRGBA( d.stroke_colour ),
    getWidth: d => d.stroke_width,
    getDashArray: d => [ d.dash_size, d.dash_gap ],
    onClick: info => md_layer_click( map_id, "path", info ),
    onHover: md_update_tooltip,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    transitions: js_transition || {},
    brushingRadius: brush_radius,
    extensions: extensions
  });

  if( map_type == "google_map") {
	  md_update_overlay( map_id, 'path-'+layer_id, pathLayer );
	} else {
	  md_update_layer( map_id, 'path-'+layer_id, pathLayer );
	}

	if ( legend !== false ) {
	  md_add_legend( map_id, map_type, layer_id, legend, "hex" );
	}
	md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}
