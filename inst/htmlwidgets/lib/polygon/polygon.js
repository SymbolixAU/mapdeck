
function add_polygon_geo( map_id, polygon_data, layer_id, light_settings, auto_highlight, highlight_colour, legend ) {

  const polygonLayer = new PolygonLayer({
    id: 'polygon-'+layer_id,
    data: polygon_data,
    pickable: true,
    stroked: true,
    filled: true,
    wireframe: false,
    extruded: true,
    lineWidthMinPixels: 1,
    getPolygon: d => get_polygon_coordinates( d ),
    getLineColor: d => hexToRGBA2( d.properties.stroke_colour ),
    getFillColor: d => hexToRGBA2( d.properties.fill_colour ),
    getLineWidth: d => d.properties.stroke_width,
    getElevation: d => d.properties.elevation,
    lightSettings: light_settings,
    autoHighlight: auto_highlight,
    highlightColor: hexToRGBA2( highlight_colour ),
    onHover: updateTooltip,
    onClick: info => layer_click( map_id, "polygon", info )
  });
  update_layer( map_id, 'polygon-'+layer_id, polygonLayer );

  if (legend !== false) {
    add_legend(map_id, layer_id, legend);
  }
}


function add_polygon_polyline( map_id, polygon_data, layer_id, light_settings, auto_highlight, highlight_colour, legend ) {


  const polygonLayer = new PolygonLayer({
    map_id: map_id,
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
    highlightColor: hexToRGBA2( highlight_colour ),
    onHover: updateTooltip,
    onClick: info => layer_click( map_id, "polygon", info )
  });
  update_layer( map_id, 'polygon-'+layer_id, polygonLayer );

    //console.log( polygonLayer );
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
