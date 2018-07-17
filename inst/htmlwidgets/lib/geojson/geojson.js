
function add_geojson( map_id, geojson ) {

  const data = JSON.parse(geojson);
  console.log("geojson");
  console.log(data);

	const geojsonLayer = new deck.GeoJsonLayer({
		id: 'geojson-layer',
		data: 'https://raw.githubusercontent.com/uber-common/deck.gl-data/master/examples/geojson/vancouver-blocks.json',
		pickable: true,
    stroked: false,
    filled: true,
    extruded: true,
    lineWidthScale: 20,
    lineWidthMinPixels: 2,
    getFillColor: [160, 160, 180, 200],
    //getLineColor: d => colorToRGBArray(d.properties.color),
    getRadius: 100,
    getLineWidth: 1,
    getElevation: 30,
    //onHover: ({object}) => setTooltip(object.properties.name || object.properties.station)
	});

	window[map_id + 'map'].setProps({ layers: [ geojsonLayer ]} );
}

