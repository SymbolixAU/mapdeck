
function add_arc_geo( map_id, arc_data, layer_id, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition ) {

  const arcLayer = new ArcLayer({
  	map_id: map_id,
    id: 'arc-'+layer_id,
    data: arc_data,
    pickable: true,
    getStrokeWidth: d => d.properties.stroke_width,
    getSourcePosition: d => md_get_origin_coordinates( d ),
    getTargetPosition: d => md_get_destination_coordinates( d ),
    getSourceColor: d => md_hexToRGBA( d.properties.stroke_from ),
    getTargetColor: d => md_hexToRGBA( d.properties.stroke_to ),
    onClick: info => md_layer_click( map_id, "arc", info ),
    onHover: md_update_tooltip,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    transitions: js_transition || {}
  });

  md_update_layer( map_id, 'arc-'+layer_id, arcLayer );
  if (legend !== false) {
    add_legend( map_id, layer_id, legend );
  }
  md_layer_view( map_id, layer_id, focus_layer, bbox, update_view );
}


function add_arc_polyline( map_id, arc_data, layer_id, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition ) {

  const arcLayer = new ArcLayer({
    map_id: map_id,
    id: 'arc-'+layer_id,
    data: arc_data,
    pickable: true,
    getStrokeWidth: d => d.stroke_width,
    getSourcePosition: d => md_decode_points( d.origin ),
    getTargetPosition: d => md_decode_points( d.destination ),
    getSourceColor: d => md_hexToRGBA( d.stroke_from ),
    getTargetColor: d => md_hexToRGBA( d.stroke_to ),
    onClick: info => md_layer_click( map_id, "arc", info ),
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    onHover: md_update_tooltip,
    transitions: js_transition || {}
  });

  md_update_layer( map_id, 'arc-'+layer_id, arcLayer );
  if (legend !== false) {
    add_legend( map_id, layer_id, legend );
  }

  md_layer_view( map_id, layer_id, focus_layer, bbox, update_view );
}
