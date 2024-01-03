
function add_line_geo( map_id, map_type, line_data, layer_id, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition, brush_radius ) {

  var extensions = [];

  if ( brush_radius > 0 ) {
  	extensions.push( new deck.BrushingExtension() );
  }

  const lineLayer = new deck.LineLayer({
  	map_id: map_id,
    id: 'line-'+layer_id,
    data: line_data,
    pickable: true,
    parameters: {
	    depthTest: false
	  },
    getWidth: d => d.properties.stroke_width,
    getSourcePosition: d => md_get_origin_coordinates( d ),
    getTargetPosition: d => md_get_destination_coordinates( d ),
    getColor: d => md_hexToRGBA( d.properties.stroke_colour ),
    onClick: info => md_layer_click( map_id, "line", info ),
    onHover: md_update_tooltip,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    transitions: js_transition || {},
    brushingRadius: brush_radius,
    extensions: extensions
  });

  if( map_type == "google_map") {
	  md_update_overlay( map_id, 'line-'+layer_id, lineLayer );
	} else {
	  md_update_layer( map_id, 'line-'+layer_id, lineLayer );
	}

	if (legend !== false) {
	  md_add_legend(map_id, map_type, layer_id, legend, "hex" );
	}
	md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}


function add_line_polyline( map_id, map_type, line_data, layer_id, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition, brush_radius ) {

  var extensions = [];

  if ( brush_radius > 0 ) {
  	extensions.push( new deck.BrushingExtension() );
  }

  const lineLayer = new deck.LineLayer({
    map_id: map_id,
    id: 'line-'+layer_id,
    data: line_data,
    pickable: true,
    parameters: {
	    depthTest: false
	  },
    getWidth: d => d.stroke_width,
    getSourcePosition: d => md_decode_points( d.origin ),
    getTargetPosition: d => md_decode_points( d.destination ),
    getColor: d => md_hexToRGBA( d.stroke_colour ),
    onClick: info => md_layer_click( map_id, "line", info ),
    onHover: md_update_tooltip,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    transitions: js_transition || {},
    brushingRadius: brush_radius,
    extensions: extensions
  });

  if( map_type == "google_map") {
	  md_update_overlay( map_id, 'line-'+layer_id, lineLayer );
	} else {
	  md_update_layer( map_id, 'line-'+layer_id, lineLayer );
	}

	if (legend !== false) {
	  md_add_legend(map_id, map_type, layer_id, legend, "hex" );
	}
	md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}
