

function add_path_geo( map_id, path_data, layer_id, auto_highlight, highlight_colour,
legend, bbox, update_view, focus_layer, js_transition ) {

  const pathLayer = new PathLayer({
    map_id: map_id,
    id: 'path-'+layer_id,
    data: path_data,
    pickable: true,
    widthScale: 20,
    widthMinPixels: 1,
    rounded: true,
    getPath: d => get_line_coordinates( d ),
    getColor: d => hexToRGBA2( d.properties.stroke_colour ),
    getWidth: d => d.properties.stroke_width,
    onClick: info => layer_click( map_id, "path", info ),
    onHover: updateTooltip,
    autoHighlight: auto_highlight,
    highlightColor: hexToRGBA2( highlight_colour ),
    transitions: js_transition || {}
  });
  update_layer( map_id, 'path-'+layer_id, pathLayer );

  if ( legend !== false ) {
      add_legend( map_id, layer_id, legend );
  }

  layer_view( map_id, layer_id, focus_layer, bbox, update_view );
}

function add_path_polyline( map_id, path_data, layer_id, auto_highlight, highlight_colour,
legend, bbox, update_view, focus_layer, js_transition ) {

  const pathLayer = new PathLayer({
    map_id: map_id,
    id: 'path-'+layer_id,
    data: path_data,
    pickable: true,
    widthScale: 20,
    widthMinPixels: 1,
    rounded: true,
    getPath: d => decode_polyline( d.polyline ),  // needs to be one row per polyline
    getColor: d => hexToRGBA2( d.stroke_colour ),
    getWidth: d => d.stroke_width,
    onClick: info => layer_click( map_id, "path", info ),
    onHover: updateTooltip,
    autoHighlight: auto_highlight,
    highlightColor: hexToRGBA2( highlight_colour ),
    transitions: js_transition || {}
  });
  update_layer( map_id, 'path-'+layer_id, pathLayer );

  if ( legend !== false ) {
      add_legend( map_id, layer_id, legend );
  }

  layer_view( map_id, layer_id, focus_layer, bbox, update_view );
}
