
function add_polygon_geo( map_id, polygon_data, layer_id, light_settings, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition, is_extruded ) {

  const polygonLayer = new PolygonLayer({
  	map_id: map_id,
    id: 'polygon-'+layer_id,
    data: polygon_data,
    pickable: true,
    stroked: true,
    filled: true,
    wireframe: false,
    extruded: is_extruded,
    lineWidthMinPixels: 0,
    getPolygon: d => md_get_polygon_coordinates( d ),
    getLineColor: d => md_hexToRGBA( d.properties.stroke_colour ),
    getFillColor: d => md_hexToRGBA( d.properties.fill_colour ),
    getLineWidth: d => d.properties.stroke_width,
    getElevation: d => d.properties.elevation,
    lightSettings: light_settings,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    onHover: md_update_tooltip,
    onClick: info => md_layer_click( map_id, "polygon", info ),
    transitions: js_transition || {}
  });
  md_update_layer( map_id, 'polygon-'+layer_id, polygonLayer );

  if (legend !== false) {
    add_legend(map_id, layer_id, legend);
  }

  md_layer_view( map_id, layer_id, focus_layer, bbox, update_view );
}


function add_polygon_polyline( map_id, polygon_data, layer_id, light_settings, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition, is_extruded ) {


  const polygonLayer = new PolygonLayer({
    map_id: map_id,
    id: 'polygon-'+layer_id,
    data: polygon_data,
    pickable: true,
    stroked: true,
    filled: true,
    wireframe: false,
    extruded: is_extruded,
    lineWidthMinPixels: 0,
    getPolygon: d => decode_polygons( d.polyline ),
    getLineColor: d => md_hexToRGBA( d.stroke_colour ),
    getFillColor: d => md_hexToRGBA( d.fill_colour ),
    getLineWidth: d => d.stroke_width,
    getElevation: d => d.elevation,
    lightSettings: light_settings,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    onHover: md_update_tooltip,
    onClick: info => md_layer_click( map_id, "polygon", info ),
    transitions: js_transition || {}
  });
  md_update_layer( map_id, 'polygon-'+layer_id, polygonLayer );

  if (legend !== false) {
    add_legend(map_id, layer_id, legend);
  }

  md_layer_view( map_id, layer_id, focus_layer, bbox, update_view );
}

function decode_polygons( polylines ) {
  var i, j, p;
  var coordinates = [];
  var lines = [];

  for (i = 0; i < polylines.length; i++ ) {
    //p = polylines[i];
    lines = polylines[i];
    //console.log( "p");
    //console.log( p );

    for (j = 0; j < lines.length; j++ ) {
    	p = lines[j];
	    if ( p != "-") {
	      coordinates.push( md_decode_polyline( p ) );
	    }
    }
  }
  return coordinates;
}
