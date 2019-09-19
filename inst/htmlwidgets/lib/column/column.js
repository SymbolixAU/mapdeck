
function add_column_geo( map_id, map_type, column_data, layer_id, auto_highlight, highlight_colour, radius, elevation_scale, disk_resolution, angle, coverage, legend, bbox, update_view, focus_layer, js_transition, is_extruded, brush_radius ) {

  var extensions = [];

  if ( brush_radius > 0 ) {
  	extensions.push( new BrushingExtension() );
  }

  const columnLayer = new deck.ColumnLayer({
    map_id: map_id,
    id: 'column-'+layer_id,
    data: column_data,
    pickable: true,
    stroked: true,
    filled: true,
    wireframe: false,
    extruded: is_extruded,
    getFillColor: d => md_hexToRGBA( d.properties.fill_colour ),
    getLineColor: d => md_hexToRGBA( d.properties.stroke_colour ),
    getLineWidth: d => d.properties.stroke_width,
    getElevation: d => d.properties.elevation,
    getPosition: d => md_get_point_coordinates( d ),
    elevationScale: elevation_scale,
    radius: radius,
    diskResolution: disk_resolution,
    angle: angle,
    coverage: coverage,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    onClick: info => md_layer_click( map_id, "column", info ),
    onHover: md_update_tooltip,
    transitions: js_transition || {},
    brushingRadius: brush_radius,
    extensions: extensions
  });

  if( map_type == "google_map") {
	  md_update_overlay( map_id, 'column-'+layer_id, columnLayer );
	} else {
		md_update_layer( map_id, 'column-'+layer_id, columnLayer );
	}

  if (legend !== false) {
	  md_add_legend(map_id, map_type, layer_id, legend);
	}
	md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}


function add_column_polyline( map_id, map_type, column_data, layer_id, auto_highlight, highlight_colour, radius, elevation_scale, disk_resolution, angle, coverage, legend, bbox, update_view, focus_layer, js_transition, is_extruded, brush_radius ) {

  var extensions = [];

  if ( brush_radius > 0 ) {
  	extensions.push( new BrushingExtension() );
  }

  const columnLayer = new deck.ColumnLayer({
    map_id: map_id,
    id: 'column-'+layer_id,
    data: column_data,
		pickable: true,
    stroked: true,
    filled: true,
    wireframe: false,
    extruded: is_extruded,
    getFillColor: d => md_hexToRGBA( d.fill_colour ),
    getLineColor: d => md_hexToRGBA( d.stroke_colour ),
    getLineWidth: d => d.stroke_width,
    getElevation: d => d.elevation,
    getPosition: d => md_get_point_coordinates( d ),
    elevationScale: elevation_scale,
    radius: radius,
    diskResolution: disk_resolution,
    angle: angle,
    coverage: coverage,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    onClick: info => md_layer_click( map_id, "column", info ),
    onHover: md_update_tooltip,
    transitions: js_transition || {},
    brushingRadius: brush_radius,
    extensions: extensions
  });

  if( map_type == "google_map") {
	  md_update_overlay( map_id, 'column-'+layer_id, columnLayer );
	} else {

		md_update_layer( map_id, 'column-'+layer_id, columnLayer );
	}

	if (legend !== false) {
	  md_add_legend(map_id, map_type, layer_id, legend);
	}
	md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}

