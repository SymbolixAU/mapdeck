
function add_scatterplot( map_id, json ) {

	console.log("scatter plot");

	const MALE_COLOR = [0, 128, 255];
  const FEMALE_COLOR = [255, 0, 128];

	const scatterLayer = new deck.ScatterplotLayer({
		id: 'scatterplot',
		data: json,
    radiusScale: 50,
    radiusMinPixels: 0.5,
    getPosition: d => [d[0], d[1], 0],
    getColor: d => (d[1] >= 0 ? MALE_COLOR : FEMALE_COLOR)
	});

	window[map_id + 'map'].setProps({ layers: [ scatterLayer ]} );

}
