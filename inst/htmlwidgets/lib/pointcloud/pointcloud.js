
function add_pointcloud_geo_columnar( map_id, map_type, pointcloud_data, data_count, radius, layer_id, light_settings, auto_highlight, highlight_colour, legend, legend_format, bbox, update_view, focus_layer, js_transition, brush_radius ) {

  var extensions = [];

  if ( brush_radius > 0 ) {
  	extensions.push( new deck.BrushingExtension() );
  }

  let hasTooltip = pointcloud_data.tooltip !== undefined;

  //console.log( pointcloud_data );

  const binaryLocation = new Float32Array(pointcloud_data.geometry);
  const binaryRadius = new Float32Array(pointcloud_data.radius);
  const binaryFillColour = new Uint8Array(pointcloud_data.fill_colour);

  const pointcloudLayer = new deck.PointCloudLayer({
  	map_id: map_id,
    id: 'pointcloud-'+layer_id,

    data: {
      length: data_count,
      attributes: {
        getPosition: {value: binaryLocation, size: 3},
        getRadius: {value: binaryRadius, size: 1},
        getColor: {value: binaryFillColour, size: 4},
      },
      tooltip: pointcloud_data.tooltip
    },

    pointSize: radius,
    lightSettings: light_settings,
    pickable: true,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    onClick: info => md_layer_click( map_id, "pointcloud", info ),
    onHover: info => hasTooltip ? md_update_binary_tooltip( info.layer, info.index, info.x, info.y ) : null,
    transitions: js_transition || {},
    brushingRadius: brush_radius,
    extensions: extensions
  });

  if( map_type == "google_map") {
	  md_update_overlay( map_id, 'pointcloud-'+layer_id, pointcloudLayer );
	} else {
	  md_update_layer( map_id, 'pointcloud-'+layer_id, pointcloudLayer );
	}

	if (legend !== false) {
	  md_add_legend(map_id, map_type, layer_id, legend, legend_format );
	}
	md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}

function add_pointcloud_polyline( map_id, map_type, pointcloud_data, radius, layer_id, light_settings, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition, brush_radius ) {

  var extensions = [];

  if ( brush_radius > 0 ) {
  	extensions.push( new deck.BrushingExtension() );
  }

  const pointcloudLayer = new deck.PointCloudLayer({
    map_id: map_id,
    id: 'pointcloud-'+layer_id,
    data: pointcloud_data,
    pointSize: radius,
    getPosition: d => decode_pointcloud( d.polyline, d.elevation ),
    getColor: d => md_hexToRGBA( d.fill_colour ),
    lightSettings: light_settings,
    pickable: true,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    onClick: info => md_layer_click( map_id, "pointcloud", info ),
    onHover: md_update_tooltip,
    transitions: js_transition || {},
    brushingRadius: brush_radius,
    extensions: extensions
  });

  if( map_type == "google_map") {
	  md_update_overlay( map_id, 'pointcloud-'+layer_id, pointcloudLayer );
	} else {
	  md_update_layer( map_id, 'pointcloud-'+layer_id, pointcloudLayer );
	}

	if (legend !== false) {
	  md_add_legend(map_id, map_type, layer_id, legend, "hex" );
	}
	md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}


function decode_pointcloud( polyline, elevation ) {
  var position = [0,0,0];
  var coords = md_decode_points( polyline );
  position[0] = coords[0];
  position[1] = coords[1];
  position[2] = elevation;
  return position;
}
