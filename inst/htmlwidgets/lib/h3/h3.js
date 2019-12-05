function add_h3_hexagon( map_id, map_type, h3_hexagon_data, layer_id, light_settings, elevation_scale, auto_highlight, highlight_colour, legend, js_transition, is_extruded ) {
//bbox, update_view, focus_layer,

  const h3Layer = new H3HexagonLayer({
  	map_id: map_id,
    id: 'h3_hexagon-'+layer_id,
    data: h3_hexagon_data,
    pickable: true,
    stroked: true,
    filled: true,
    wireframe: false,
    extruded: is_extruded,
    lineWidthMinPixels: 0,
    getHexagon: d => d.hexagon,
    getLineColor: d => md_hexToRGBA( d.stroke_colour ),
    getFillColor: d => md_hexToRGBA( d.fill_colour ),
    getLineWidth: d => d.stroke_width,
    getElevation: d => d.elevation,
    elevationScale: elevation_scale,
    lightSettings: light_settings,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    onHover: md_update_tooltip,
    onClick: info => md_layer_click( map_id, "h3_hexagon", info ),
    transitions: js_transition || {}
  });

  if( map_type == "google_map") {
    md_update_overlay( map_id, 'h3_hexagon-'+layer_id, h3Layer );
  } else {
	  md_update_layer( map_id, 'h3_hexagon-'+layer_id, h3Layer );
  }

	if (legend !== false) {
	  md_add_legend(map_id, map_type, layer_id, legend);
	}

	// md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}
