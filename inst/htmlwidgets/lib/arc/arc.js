function add_arc_geo( map_id, map_type, arc_data, layer_id, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition ) {

  const arcLayer = new ArcLayer({
  	map_id: map_id,
    id: 'arc-'+layer_id,
    data: arc_data,
    pickable: true,
    getWidth: d => d.properties.stroke_width,
    getSourcePosition: d => md_get_origin_coordinates( d ),
    getTargetPosition: d => md_get_destination_coordinates( d ),
    getSourceColor: d => md_hexToRGBA( d.properties.stroke_from ),
    getTargetColor: d => md_hexToRGBA( d.properties.stroke_to ),
    getTilt: d => d.properties.tilt,
    getHeight: d => d.properties.height,
    onClick: info => md_layer_click( map_id, "arc", info ),
    onHover: md_update_tooltip,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    transitions: js_transition || {}
  });

  if( map_type == "google_map") {
	  md_update_overlay( map_id, 'arc-'+layer_id, arcLayer );
	} else {
	  md_update_layer( map_id, 'arc-'+layer_id, arcLayer );
	}

	if (legend !== false) {
	  md_add_legend( map_id, map_type, layer_id, legend );
	}
	md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}


function add_arc_polyline( map_id, map_type, arc_data, layer_id, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition ) {

  const arcLayer = new ArcLayer({
    map_id: map_id,
    id: 'arc-'+layer_id,
    data: arc_data,
    pickable: true,
    getWidth: d => d.stroke_width,
    getSourcePosition: d => md_decode_points( d.origin ),
    getTargetPosition: d => md_decode_points( d.destination ),
    getSourceColor: d => md_hexToRGBA( d.stroke_from ),
    getTargetColor: d => md_hexToRGBA( d.stroke_to ),
    getTilt: d => d.tilt,
    getHeight: d => d.height,
    onClick: info => md_layer_click( map_id, "arc", info ),
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    onHover: md_update_tooltip,
    transitions: js_transition || {}
  });

  if( map_type == "google_map") {
	  md_update_overlay( map_id, 'arc-'+layer_id, arcLayer );
	} else {
	  md_update_layer( map_id, 'arc-'+layer_id, arcLayer );
	}

	if (legend !== false) {
	  md_add_legend( map_id, map_type, layer_id, legend );
	}
	md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}
