function add_heatmap_geo( map_id, map_type, heatmap_data, layer_id, colour_range, radius_pixels, intensity, threshold, bbox, update_view, focus_layer, js_transitions ) {

  const heatmapLayer = new deck.HeatmapLayer({
    map_id: map_id,
    id: 'heatmap-'+layer_id,
    data: heatmap_data,

    radiusPixels: radius_pixels || 30,
    intensity: intensity || 1,
    threshold: threshold || 0.05,
    colorRange: md_to_rgba( colour_range ),

    getPosition: d => md_get_point_coordinates( d ),
    getWeight: d => d.properties.weight,
    transitions: js_transitions || {}
  });

  if( map_type == "google_map") {
	    md_update_overlay( map_id, 'heatmap-'+layer_id, heatmapLayer );
	} else {
	  md_update_layer( map_id, 'heatmap-'+layer_id, heatmapLayer );
	}
	md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}

function add_heatmap_polyline( map_id, map_type, heatmap_data, layer_id, colour_range, radius_pixels, intensity, threshold, bbox, update_view, focus_layer, js_transitions ) {

  const heatmapLayer = new deck.HeatmapLayer({
    map_id: map_id,
    id: 'heatmap-'+layer_id,
    data: heatmap_data,

    radiusPixels: radius_pixels || 30,
    intensity: intensity || 1,
    threshold: threshold || 0.05,
    colorRange: md_to_rgba( colour_range ),

    getPosition: d => md_get_point_coordinates( d ),
    getWeight: d => d.properties.weight,
		transitions: js_transitions || {}

  });
    if( map_type == "google_map") {
	    md_update_overlay( map_id, 'heatmap-'+layer_id, heatmapLayer );
	} else {
	  md_update_layer( map_id, 'heatmap-'+layer_id, heatmapLayer );
	}
	md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}



