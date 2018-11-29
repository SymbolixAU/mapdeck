
function add_pointcloud_geo( map_id, pointcloud_data, radius, layer_id, light_settings, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer ) {

  const pointcloudLayer = new deck.PointCloudLayer({
  	map_id: map_id,
    id: 'pointcloud-'+layer_id,
    data: pointcloud_data,
    radiusPixels: radius,
    //getPosition: d => d.geometry.geometry.coordinates,
    getPosition: d => get_point_coordinates( d ),
    getColor: d => hexToRGBA2( d.properties.fill_colour ),
    lightSettings: light_settings,
    pickable: true,
    autoHighlight: auto_highlight,
    onClick: info => layer_click( map_id, "pointcloud", info ),
    onHover: updateTooltip
  });
  update_layer( map_id, 'pointcloud-'+layer_id, pointcloudLayer );

  if (legend !== false) {
    add_legend(map_id, layer_id, legend);
  }
  layer_view( map_id, layer_id, focus_layer, bbox, update_view );
}

function add_pointcloud_polyline( map_id, pointcloud_data, radius, layer_id, light_settings, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer ) {

  const pointcloudLayer = new deck.PointCloudLayer({
    map_id: map_id,
    id: 'pointcloud-'+layer_id,
    data: pointcloud_data,
    radiusPixels: radius,
    getPosition: d => decode_pointcloud( d.polyline, d.elevation ),
    getColor: d => hexToRGBA2( d.fill_colour ),
    lightSettings: light_settings,
    pickable: true,
    autoHighlight: auto_highlight,
    highlightColor: hexToRGBA2( highlight_colour ),
    onClick: info => layer_click( map_id, "pointcloud", info ),
    onHover: updateTooltip
  });
  update_layer( map_id, 'pointcloud-'+layer_id, pointcloudLayer );

  if (legend !== false) {
    add_legend(map_id, layer_id, legend);
  }
  layer_view( map_id, layer_id, focus_layer, bbox, update_view );
}


function decode_pointcloud( polyline, elevation ) {
  var position = [0,0,0];
  var coords = decode_points( polyline );
  position[0] = coords[0];
  position[1] = coords[1];
  position[2] = elevation;
  return position;
}
