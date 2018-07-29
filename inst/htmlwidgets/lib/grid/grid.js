
function add_grid( map_id, grid_data, layer_id, cell_size, extruded, elevation_scale ) {

	const gridLayer = new deck.GridLayer({
		id: 'grid-'+layer_id,  // TODO
		data: grid_data,
		pickable: true,
		extruded: extruded,
		cellSize: cell_size,
		elevationScale: elevation_scale,
    getPosition: d => [d.lon, d.lat],
    onClick: info => layer_click( map_id, "grid", info )
	});

	window[map_id + 'layers'].push( gridLayer );
  window[map_id + 'map'].setProps({ layers: window[map_id + 'layers'] });
}
