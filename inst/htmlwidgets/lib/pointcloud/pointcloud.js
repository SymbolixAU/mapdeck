
function add_pointcloud( map_id, pointcloud_data, layer_id, light_settings ) {
  const pointcloudLayer = new deck.PointCloudLayer({
    id: 'pointcloud-'+layer_id,
    data: pointcloud_data,
    radiusPixels: 10,
    getPosition: d => decode_pointcloud(d.polyline, d.elevation),
    getColor: d => hexToRGBA( d.fill_colour, d.fill_opacity ),
    lightSettings: light_settings,
    //onClick: info => layer_click( map_id, "pointcloud", info )
  });
  update_layer( map_id, 'pointcloud-'+layer_id, pointcloudLayer );
}

function decode_pointcloud( polyline, elevation ) {
  var position = [0,0,0];
  var coords = decode_points( polyline );
  position[0] = coords[0];
  position[1] = coords[1];
  position[2] = elevation;
  return position;
}
