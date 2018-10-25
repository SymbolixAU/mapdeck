
function add_line( map_id, line_data, layer_id, auto_highlight, legend ) {

  const lineLayer = new LineLayer({
    id: 'line-'+layer_id,
    data: line_data,
    pickable: true,
    getStrokeWidth: d => d.stroke_width,
    getSourcePosition: d => decode_points( d.origin ),
    getTargetPosition: d => decode_points( d.destination ),
    getColor: d => hexToRGBA( d.stroke_colour, d.stroke_opacity ),
    onClick: info => layer_click( map_id, "line", info ),
    onHover: updateTooltip,
    autoHighlight: auto_highlight
  });

  update_layer( map_id, 'line-'+layer_id, lineLayer );

  if (legend !== false) {
    add_legend(map_id, layer_id, legend);
  }
}


function add_line2( map_id, line_data, layer_id, auto_highlight, legend ) {

  const lineLayer = new LineLayer({
    id: 'line-'+layer_id,
    data: line_data,
    pickable: true,
    getStrokeWidth: d => d.stroke_width,
    getSourcePosition: d => decode_points( d.origin ),
    getTargetPosition: d => decode_points( d.destination ),
    getColor: d => hexToRGBA2( d.stroke_colour ),
    onClick: info => layer_click( map_id, "line", info ),
    onHover: updateTooltip,
    autoHighlight: auto_highlight
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
