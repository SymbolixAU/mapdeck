

function add_polygon( map_id, polygon_data, layer_id ) {

  const pathLayer = new PolygonLayer({
    id: 'polygon-'+layer_id,  // TODO
    data: polygon_data,
    pickable: true,
    stroked: true,
    filled: true,
    wireframe: true,
    lineWidthMinPixels: 1,
    getPolygon: d => decode_polygons( d.polyline ),
    getLineColor: d => hexToRgb( d.stroke_colour ),
    getFillColor: d => hexToRgb( d.fill_colour ),
    getLineWidth: d => d.stroke_width,
    //onHover: ({object}) => setTooltip(object.name)  // TODO
    onClick: info => layer_click( map_id, "path", info )
  });

  update_layer( map_id, 'polygon-'+layer_id, polygonLayer );
}

function decode_polygons( polylines ) {
	// polygons can be an array of polylines
	var i, coordinates = [];

	for (i = 0; i < polylines.length; i++ ) {
		coordinates.push( decode_polyline( polylines[i] ) );
	}
	return coordinates;
}
