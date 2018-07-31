
function add_scatterplot( map_id, scatter_data, layer_id ) {

  console.log( scatter_data );

	const scatterLayer = new deck.ScatterplotLayer({
		id: 'scatterplot-'+layer_id,  // TODO
		data: scatter_data,
    radiusScale: 1,
    radiusMinPixels: 1,
    getRadius: d => d.radius,
    getPosition: d => decode_points( d.polyline ),
    getColor: d => hexToRgb( d.fill_colour ),
    onClick: info => layer_click( map_id, "scatterplot", info )
	});

	update_layer( map_id, 'scatterplot-'+layer_id, scatterLayer );
}
