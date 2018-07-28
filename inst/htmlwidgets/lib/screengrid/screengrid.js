
function add_screengrid( map_id, screengrid_data, layer_id ) {

  console.log( screengrid_data );

	const screengridLayer = new deck.ScreenGridLayer({
		id: 'screengrid-'+layer_id,  // TODO
		data: screengrid_data,
		cellSizePixels: 50,
    getPosition: d => [d.lon, d.lat],
    getWeight: d => d.weight,
    onClick: info => layer_click( map_id, "screengrid", info )
	});

	window[map_id + 'layers'].push( screengridLayer );
  window[map_id + 'map'].setProps({ layers: window[map_id + 'layers'] });
}
