
function add_pointcloud( map_id, pointcloud_data, layer_id ) {

	const pointcloudLayer = new deck.PointCloudLayer({
		id: 'pointcloud-'+layer_id,  // TODO
		data: pointcloud_data,
		radiusPixels: 10,
    getPosition: d => [d.lon, d.lat, d.elevation],
    getColor: d => hexToRgb( d.fill_colour ),
    onClick: info => layer_click( map_id, "pointcloud", info )
	});

	update_layer( map_id, 'pointcloud-'+layer_id, pointcloudLayer );
}
