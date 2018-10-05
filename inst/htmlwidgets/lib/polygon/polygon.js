

function add_polygon( map_id, polygon_data, layer_id, light_settings, auto_highlight ) {
  const polygonLayer = new PolygonLayer({
    id: 'polygon-'+layer_id,
    data: polygon_data,
    pickable: true,
    stroked: true,
    filled: true,
    wireframe: false,
    extruded: true,
    lineWidthMinPixels: 1,
    getPolygon: d => decode_polygons( d.polyline ),
    getLineColor: d => hexToRgb_simple( d.stroke_colour ),
    getFillColor: d => hexToRGBA( d.fill_colour, d.fill_opacity ),
    getLineWidth: d => d.stroke_width,
    getElevation: d => d.elevation,
    lightSettings: light_settings,
    autoHighlight: auto_highlight,
    onHover: updateTooltip,
    onClick: info => layer_click( map_id, "path", info )
  });
  update_layer( map_id, 'polygon-'+layer_id, polygonLayer );
}

function add_polygon2( map_id, polygon_data, layer_id, light_settings, auto_highlight ) {
  const polygonLayer = new PolygonLayer({
    id: 'polygon-'+layer_id,
    data: polygon_data,
    pickable: true,
    stroked: true,
    filled: true,
    wireframe: false,
    extruded: true,
    lineWidthMinPixels: 1,
    getPolygon: d => decode_polygons( d.polyline ),
    getLineColor: d => hexToRgb_simple( d.stroke_colour ),
    getFillColor: d => hexToRGBA2( d.fill_colour ),
    getLineWidth: d => d.stroke_width,
    getElevation: d => d.elevation,
    lightSettings: light_settings,
    autoHighlight: auto_highlight,
    onHover: updateTooltip,
    onClick: info => layer_click( map_id, "path", info )
  });
  update_layer( map_id, 'polygon-'+layer_id, polygonLayer );
}

function decode_polygons( polylines ) {
  var i, p, coordinates = [];

  //console.log( polylines );
  //console.log("polygon length: " + polylines.length);

  for (i = 0; i < polylines.length; i++ ) {
    p = polylines[i];
    if ( p != "-") {
      coordinates.push( decode_polyline( p ) );
    }
  }

  //console.log(coordinates);
  return coordinates;
}
