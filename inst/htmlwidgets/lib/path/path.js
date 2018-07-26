

function add_path( map_id, path_data, layer_id ) {

  const pathLayer = new PathLayer({
    id: 'path-'+layer_id,  // TODO
    data: path_data,
    pickable: true,
    widthScale: 20,
    widthMinPixels: 2,
    getPath: d => decode_polyline( d.polyline ),
    getColor: d => hexToRgb(d.stroke_colour),
    getWidth: d => d.stroke_width,
    //onHover: ({object}) => setTooltip(object.name)  // TODO
    onClick: info => layer_click( map_id, "path", info )
  });

  window[map_id + 'layers'].push(pathLayer);
  window[map_id + 'map'].setProps({ layers: window[map_id + 'layers'] } );
}

function decode_paths( polylines ) {
	// polygons can be an array of polylines
	var i, coordinates = [];

	for (i = 0; i < polylines.length; i++ ) {
		coordinates.push( decode_polyline( polylines[i] ) );
	}
	return coordinates;
}
