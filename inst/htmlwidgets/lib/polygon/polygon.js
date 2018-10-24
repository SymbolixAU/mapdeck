function add_polygon( map_id, polygon_data, layer_id, light_settings, auto_highlight, legend ) {

  //console.log( polygon_data ) ;
  //console.log( legend );
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

  if (legend !== false) {
    add_legend(map_id, layer_id, legend);
  }

}

function add_polygon2( map_id, polygon_data, layer_id, light_settings, auto_highlight, legend ) {
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
    getLineColor: d => hexToRGBA2( d.stroke_colour ),
    getFillColor: d => hexToRGBA2( d.fill_colour ),
    getLineWidth: d => d.stroke_width,
    getElevation: d => d.elevation,
    lightSettings: light_settings,
    autoHighlight: auto_highlight,
    onHover: updateTooltip,
    onClick: info => layer_click( map_id, "path", info )
  });
  update_layer( map_id, 'polygon-'+layer_id, polygonLayer );
  
  console.log( legend );
    
  if (legend !== false) {
    add_legend(map_id, layer_id, legend);
  }
}

function decode_polygons( polylines ) {
  var i, p, coordinates = [];

  for (i = 0; i < polylines.length; i++ ) {
    p = polylines[i];
    if ( p != "-") {
      coordinates.push( decode_polyline( p ) );
    }
  }

  return coordinates;
}

function clear_polygon( map_id, layer_id ) {
  clear_layer( map_id, 'polygon-'+layer_id );
  clear_legend( map_id, layer_id );
}