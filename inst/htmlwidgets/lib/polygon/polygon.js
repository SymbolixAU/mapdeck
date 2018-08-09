

function add_polygon( map_id, polygon_data, layer_id, light_settings ) {

  const polygonLayer = new PolygonLayer({
    id: 'polygon-'+layer_id,  // TODO
    data: polygon_data,
    pickable: true,
    stroked: true,
    filled: true,
    wireframe: false,
    extruded: true,
    lineWidthMinPixels: 1,
    getPolygon: d => decode_polygons( d.polyline ),
    getLineColor: d => hexToRgb( d.stroke_colour ),
    getFillColor: d => hexToRGBA( d.fill_colour, d.fill_opacity ),
    getLineWidth: d => d.stroke_width,
    getElevation: d => d.elevation,
    lightSettings: light_settings,
    onHover: updateTooltip,
    //onHover: ({object}) => setTooltip(object.name)  // TODO
    onClick: info => layer_click( map_id, "path", info )
  });
  update_layer( map_id, 'polygon-'+layer_id, polygonLayer );
}


// following: https://codepen.io/vis-gl/pen/pLLQpN
// and: https://beta.observablehq.com/@pessimistress/deck-gl-geojsonlayer-example
function updateTooltip({x, y, object}) {

  const tooltip = document.getElementById('tooltip');
  //console.log(tooltip);

  //if (object) {
  //  tooltip.style.top = `${y}px`;
  //  tooltip.style.left = `${x}px`;
  //  tooltip.innerHTML = '<div><b>Hovering</b></div>';
  //} else {
    tooltip.innerHTML = '';
  //}
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
