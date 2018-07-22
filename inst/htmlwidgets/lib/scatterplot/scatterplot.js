
function add_scatterplot( map_id, json, layer_id ) {

  console.log( json );

  // reference: https://github.com/uber/deck.gl/blob/master/docs/layers/scatterplot-layer.md

	const scatterLayer = new deck.ScatterplotLayer({
		id: 'scatterplot-'+layer_id,  // TODO
		data: json,
    radiusScale: 1,
    radiusMinPixels: 1,
    getRadius: d => d.radius,
    getPosition: d => [d.lon, d.lat, d.elevation],
    //getColor: d => [d.fill_colour_red, d.fill_colour_green, d.fill_colour_blue]
    getColor: d => hexToRgb( d.fill_colour ),
    onClick: info => layer_click( map_id, "scatterplot", info )
	});

  console.log( window[map_id + 'map'] ); // this is teh deck obj
  console.log( window[map_id + 'layers'] );
	window[map_id + 'layers'].push( scatterLayer );
  window[map_id + 'map'].setProps({ layers: window[map_id + 'layers'] });
}
