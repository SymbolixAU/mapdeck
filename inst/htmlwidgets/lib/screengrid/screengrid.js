
function add_screengrid( map_id, screengrid_data, layer_id ) {
	const screengridLayer = new deck.ScreenGridLayer({
		id: 'screengrid-'+layer_id,  // TODO
		data: screengrid_data,
		cellSizePixels: 50,
		//colorRange: to_rgba( colour_range ),
    getPosition: d => [d.lon, d.lat],
    getWeight: d => d.weight,
    onClick: info => layer_click( map_id, "screengrid", info )
	});

	update_layer( map_id, 'screengrid-'+layer_id, screengridLayer );
}
