

function add_polygon( map_id, polygon_data, layer_id, light_settings ) {


/*
  const LIGHT_SETTINGS = {
    lightsPosition: [-0.144528, 49.739968, 8000],
    ambientRatio: 0.4,
    diffuseRatio: 0.6,
    specularRatio: 0.2,
    lightsStrength: [0.2, 0.0, ],
    numberOfLights: 1
  };
*/

  const polygonLayer = new PolygonLayer({
    id: 'polygon-'+layer_id,  // TODO
    data: polygon_data,
    pickable: true,
    stroked: true,
    filled: true,
    wireframe: true,
    extruded: true,
    lineWidthMinPixels: 1,
    getPolygon: d => decode_polygons( d.polyline ),
    getLineColor: d => hexToRgb( d.stroke_colour ),
    getFillColor: d => hexToRGBA( d.fill_colour, d.fill_opacity ),
    getLineWidth: d => d.stroke_width,
    getElevation: d => d.elevation,
    lightSettings: light_settings,
    //onHover: ({object}) => setTooltip(object.name)  // TODO
    onClick: info => layer_click( map_id, "path", info )
  });
  update_layer( map_id, 'polygon-'+layer_id, polygonLayer );
}

function decode_polygons( polylines ) {
	// polygons can be an array of polylines
	var i, p, coordinates = [];

	for (i = 0; i < polylines.length; i++ ) {
		p = polylines[i];
		if ( p != "-") {
		  coordinates.push( decode_polyline( p ) );
	  }
	}
	return coordinates;
}
