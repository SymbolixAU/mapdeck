
function add_scatterplot( map_id, json ) {

	console.log("scatter plot");

//	const MALE_COLOR = [0, 128, 255];
//  const FEMALE_COLOR = [255, 0, 128];

	const scatterLayer = new deck.ScatterplotLayer({
		id: 'scatterplot',
		data: json,
    radiusScale: 50,
    radiusMinPixels: 1,
    getPosition: d => [d.lon, d.lat, 0],
    getColor: d => [d.red, d.blue, d.green]
	});

	window[map_id + 'map'].setProps({ layers: [ scatterLayer ]} );

}
