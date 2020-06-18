
function add_column_geo_columnar( map_id, map_type, column_data, data_count, layer_id, auto_highlight, highlight_colour, radius, elevation_scale, disk_resolution, angle, coverage, legend, legend_format, bbox, update_view, focus_layer, js_transition, is_extruded, brush_radius ) {

  var extensions = [];

  if ( brush_radius > 0 ) {
  	extensions.push( new deck.BrushingExtension() );
  }

  let hasTooltip = column_data.tooltip !== undefined;

  const binaryLocation = new Float32Array(column_data.geometry);
  //const binaryRadius = new Float32Array(column_data.radius);
  const binaryFillColour = new Uint8Array(column_data.fill_colour);
  const binaryLineColour = new Uint8Array(column_data.stroke_colour);
  const binaryLineWidth = new Float32Array(column_data.stroke_width);
  const binaryElevation = new Float32Array(column_data.elevation);

  const columnLayer = new deck.ColumnLayer({
    map_id: map_id,
    id: 'column-'+layer_id,

    data: {
      length: data_count,
      attributes: {
        getPosition: {value: binaryLocation, size: 2},
        //getRadius: {value: binaryRadius, size: 1},
        getFillColor: {value: binaryFillColour, size: 4},
        getLineColor: {value: binaryLineColour, size: 4},
        getLineWidth: {value: binaryLineWidth, size: 1},
        getElevation: {value: binaryElevation, size: 1}
      },
      tooltip: column_data.tooltip
    },


    pickable: true,
    stroked: true,
    filled: true,
    wireframe: false,
    extruded: is_extruded,

    elevationScale: elevation_scale,
    radius: radius,
    diskResolution: disk_resolution,
    angle: angle,
    coverage: coverage,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    onClick: info => md_layer_click( map_id, "column", info ),
    onHover: info => hasTooltip ? md_update_binary_tooltip( info.layer, info.index, info.x, info.y ) : null,
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
	  md_add_legend(map_id, map_type, layer_id, legend, legend_format );
	}
	md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}


function add_column_polyline( map_id, map_type, column_data, layer_id, auto_highlight, highlight_colour, radius, elevation_scale, disk_resolution, angle, coverage, legend, bbox, update_view, focus_layer, js_transition, is_extruded, brush_radius ) {

  var extensions = [];

  if ( brush_radius > 0 ) {
  	extensions.push( new deck.BrushingExtension() );
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
	  md_add_legend(map_id, map_type, layer_id, legend, "hex");
	}
	md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}

