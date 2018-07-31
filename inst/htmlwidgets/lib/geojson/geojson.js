
function add_geojson( map_id, geojson, layer_id ) {

  console.log(geojson);
  // reference: https://github.com/uber/deck.gl/blob/master/docs/layers/geojson-layer.md

	const geojsonLayer = new deck.GeoJsonLayer({
		id: 'geojson-'+layer_id,
		//data: 'https://raw.githubusercontent.com/uber-common/deck.gl-data/master/examples/geojson/vancouver-blocks.json',
		data: geojson,
		pickable: true,
    stroked: true,
    filled: true,
    extruded: true,
    lineWidthScale: 20,
    lineWidthMinPixels: 2,
    //getFillColor: [160, 160, 180, 200],
    getFillColor: f => hexToRgb( f.properties.fillColor ),
    getLineColor: d => hexToRgb( d.properties.lineColor ),
    getRadius: 100,   // TODO
    getLineWidth: 1,  // TODO
    getElevation: 30, // TODO
    //onHover: ({object}) => setTooltip(object.properties.name || object.properties.station)
    onClick: info => layer_click( map_id, "geojson", info )
  });

  update_layer( map_id, 'geojson-'+layer_id, geojsonLayer );
}

