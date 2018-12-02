
function add_line_geo( map_id, line_data, layer_id, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition ) {

  const lineLayer = new LineLayer({
  	map_id: map_id,
    id: 'line-'+layer_id,
    data: line_data,
    pickable: true,
    getStrokeWidth: d => d.properties.stroke_width,
    getSourcePosition: d => md_get_origin_coordinates( d ),
    getTargetPosition: d => md_get_destination_coordinates( d ),
    getColor: d => md_hexToRGBA( d.properties.stroke_colour ),
    onClick: info => md_layer_click( map_id, "line", info ),
    onHover: md_update_tooltip,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    transitions: js_transition || {}
  });

  md_update_layer( map_id, 'line-'+layer_id, lineLayer );

  if (legend !== false) {
    add_legend(map_id, layer_id, legend);
  }
  md_layer_view( map_id, layer_id, focus_layer, bbox, update_view );
}


function add_line_polyline( map_id, line_data, layer_id, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition ) {

  const lineLayer = new LineLayer({
    map_id: map_id,
    id: 'line-'+layer_id,
    data: line_data,
    pickable: true,
    getStrokeWidth: d => d.stroke_width,
    getSourcePosition: d => md_decode_points( d.origin ),
    getTargetPosition: d => md_decode_points( d.destination ),
    getColor: d => md_hexToRGBA( d.stroke_colour ),
    onClick: info => md_layer_click( map_id, "line", info ),
    onHover: md_update_tooltip,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    transitions: js_transition || {}
  });

  md_update_layer( map_id, 'line-'+layer_id, lineLayer );

  if (legend !== false) {
    add_legend(map_id, layer_id, legend);
  }
  md_layer_view( map_id, layer_id, focus_layer, bbox, update_view );
}
