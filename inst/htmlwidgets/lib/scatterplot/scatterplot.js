
function add_scatterplot( map_id, json ) {

  console.log( json );

  // reference: https://github.com/uber/deck.gl/blob/master/docs/layers/scatterplot-layer.md

	const scatterLayer = new deck.ScatterplotLayer({
		id: 'scatterplot',
		data: json,
    radiusScale: 1,
    radiusMinPixels: 1,
    getRadius: d => d.radius,
    getPosition: d => [d.lon, d.lat, d.elevation],
    getColor: d => [d.fill_colour_red, d.fill_colour_green, d.fill_colour_blue]
	});

	window[map_id + 'map'].setProps({ layers: [ scatterLayer ]} );
}
