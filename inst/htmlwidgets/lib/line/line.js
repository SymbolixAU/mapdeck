
function add_line_geo( map_id, line_data, layer_id, auto_highlight, highlight_colour, legend ) {

  const lineLayer = new LineLayer({
    id: 'line-'+layer_id,
    data: line_data,
    pickable: true,
    getStrokeWidth: d => d.properties.stroke_width,
    getSourcePosition: d => get_origin_coordinates( d ),
    getTargetPosition: d => get_destination_coordinates( d ),
    getColor: d => hexToRGBA2( d.properties.stroke_colour ),
    onClick: info => layer_click( map_id, "line", info ),
    onHover: updateTooltip,
    autoHighlight: auto_highlight,
    highlightColor: hexToRGBA2( highlight_colour ),
  });

  update_layer( map_id, 'line-'+layer_id, lineLayer );

  if (legend !== false) {
    add_legend(map_id, layer_id, legend);
  }
}


function add_line_polyline( map_id, line_data, layer_id, auto_highlight, highlight_colour, legend ) {

  const lineLayer = new LineLayer({
    map_id: map_id,
    id: 'line-'+layer_id,
    data: line_data,
    pickable: true,
    getStrokeWidth: d => d.stroke_width,
    getSourcePosition: d => decode_points( d.origin ),
    getTargetPosition: d => decode_points( d.destination ),
    getColor: d => hexToRGBA2( d.stroke_colour ),
    onClick: info => layer_click( map_id, "line", info ),
    onHover: updateTooltip,
    autoHighlight: auto_highlight,
    highlightColor: hexToRGBA2( highlight_colour )
  });

  update_layer( map_id, 'line-'+layer_id, lineLayer );

  if (legend !== false) {
    add_legend(map_id, layer_id, legend);
  }
}

function clear_line( map_id, layer_id ) {
  clear_layer( map_id, 'line-'+layer_id );
  clear_legend( map_id, layer_id );
}
