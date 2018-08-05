
function add_geojson( map_id, geojson, layer_id ) {

  // reference: https://github.com/uber/deck.gl/blob/master/docs/layers/geojson-layer.md
  console.log(geojson);

	const geojsonLayer = new deck.GeoJsonLayer({
		id: 'geojson-'+layer_id,
		data: geojson,
		pickable: true,
    stroked: true,
    filled: true,
    extruded: true,
    pointRadiusScale: 1,
    pointRadiusMinPixels: 0.5,
    lineWidthScale: 20,
    lineWidthMinPixels: 2,
    //getFillColor: [200, 0, 0, 200],
    getFillColor: f => geojson_fill( f ),
    getLineColor: l => geojson_line( l ),
    getRadius: 10000,   // TODO
    getLineWidth: 1,  // TODO
    getElevation: d => d.properties.elevation || 1000,
    //onHover: ({object}) => setTooltip(object.properties.name || object.properties.station)
    onClick: info => layer_click( map_id, "geojson", info )
  });

  update_layer( map_id, 'geojson-'+layer_id, geojsonLayer );
}

function geojson_fill( fill ) {
	if( fill.properties === undefined) {
		console.log( "properties undefined, returning default");
		return [200, 0, 0, 200];
	}

	if (fill.properties.fillColor === undefined) {
		console.log( ' fillColor undefined, returning default' );
		return [200, 0, 0, 200];
  }
  return hexToRGBA( fill.properties.fillColor, fill.properties.fillOpacity || 200 );
}

function geojson_line( line ) {
	if (line.properties === undefined) {
	  	return [200, 0, 0, 200];
	}
	if (line.properties.lineColor === undefined) {
			return [200, 0, 0, 200];
	}
	return hexToRGBA( line.properties.lineColor, line.properties.lineOpacity || 200 );
}
