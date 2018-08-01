
function add_pointcloud( map_id, pointcloud_data, layer_id ) {

  console.log( pointcloud_data );

  // reference: https://github.com/uber/deck.gl/blob/master/docs/layers/scatterplot-layer.md

	const pointcloudLayer = new deck.PointCloudLayer({
		id: 'pointcloud-'+layer_id,  // TODO
		data: pointcloud_data,
		radiusPixels: 10,
    getPosition: d => [d.lon, d.lat, d.elevation],
    getColor: d => hexToRgb( d.fill_colour ),
    onClick: info => layer_click( map_id, "pointcloud", info )
	});

	window[map_id + 'layers'].push( pointcloudLayer );
  window[map_id + 'map'].setProps({ layers: window[map_id + 'layers'] });
}
