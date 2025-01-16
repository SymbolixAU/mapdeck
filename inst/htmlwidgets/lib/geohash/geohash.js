function add_geohash( map_id, map_type, geohash_data, layer_id, light_settings, elevation_scale, auto_highlight, highlight_colour, legend, legend_format, js_transition, is_extruded ) {
//bbox, update_view, focus_layer,

  console.log( legend );

  const geohashLayer = new deck.GeohashLayer({
  	map_id: map_id,
    id: 'geohash-'+layer_id,
    data: geohash_data,
    pickable: true,
    stroked: true,
    filled: true,
    wireframe: false,
    extruded: is_extruded,
    lineWidthMinPixels: 0,
    getGeohash: d => d.geohash
    getLineColor: d => d.stroke_colour,
    getFillColor: d => d.fill_colour,
    getLineWidth: d => d.stroke_width,
    getElevation: d => d.elevation,
    elevationScale: elevation_scale,
    lightSettings: light_settings,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    onHover: md_update_tooltip,
    onClick: info => md_layer_click( map_id, "geohash", info ),
    transitions: js_transition || {}
  });

  if( map_type == "google_map") {
    md_update_overlay( map_id, 'geohash-'+layer_id, geohashLayer );
  } else {
	  md_update_layer( map_id, 'geohash-'+layer_id, geohashLayer );
  }

	if (legend !== false) {
	  md_add_legend(map_id, map_type, layer_id, legend, legend_format);
	}

	// md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}
